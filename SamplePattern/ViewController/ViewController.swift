//  ViewController.swift
//  SamplePattern
//
//  Created by Laxman on 29/09/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
enum ShowType: Int {
    case showForEnable  = 0
    case showForAuthenticate
}

class ViewController: UIViewController {
    var titleLabel: UILabel?
    var detailedLabel: UILabel?
    var activeImage: UIImage?
    var inactiveImage: UIImage?
    var lineColor: UIColor?
    var typeService: ShowType!
    var patternString: String?
    private var paths: NSMutableArray?
    var toucheddots: Int?
    var dotcount: Int?
    var _target: AnyObject?
    var _action: Selector?
    var numberOfFails: NSInteger!
    var _shouldConfirm: Bool!
    var _patternToConfirm: NSString!
    var patternDocument: PatternDocument?
    
    func showPatternLockFor(type: ShowType , withActiveDotImage activeDot: UIImage ,withInactiveDotImage inactiveDot: UIImage , withLineColor  color : UIColor  )
    {
        activeImage = activeDot;
        inactiveImage = inactiveDot;
        lineColor = color;
        typeService = type;
        (UIApplication.sharedApplication().delegate as! AppDelegate).window!.rootViewController?.presentViewController(self, animated: true, completion: nil)
    }
    
    override func loadView() {
        super.loadView()
        self.view = CircleView(frame: UIScreen.mainScreen().bounds)
    }
    
    //MARK:- lifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var x: CGFloat? //= 30.0
        var y: CGFloat?
        if WINDOWS_HEIGHT > 568 {
            x = 80
            y = 220
        }else {
            x = 50
            y = 180
        }
        
        let line: Int = 3
        for var i:Int = 0 ;i < 9 ; i++ {
            let dotImage: UIImage = inactiveImage!
            let imageView: UIImageView = UIImageView(image: dotImage, highlightedImage: activeImage)
            imageView.frame = CGRectMake(x!, y!, 25, 25)
            imageView.userInteractionEnabled = true
            imageView.tag = i+1
            self.view.addSubview(imageView)
            
            x = x! + 100
            if (i+1) % line == 0 {
                y = y! + 90
                if WINDOWS_HEIGHT > 568 {
                    x = 80
                }else {
                    x = 50
                }
            }
        }
        self.view.backgroundColor = UIColor.blackColor()
        var rect: CGRect = CGRectMake(0, 80, WINDOWS_WIDTH, 44)
        self.titleLabel = UILabel(frame: rect)
        rect.origin.y += 40
        self.detailedLabel = UILabel(frame: rect)
        self.view.addSubview(titleLabel!)
        self.view.addSubview(detailedLabel!)
        self.titleLabel?.textColor = UIColor.whiteColor()
        self.detailedLabel?.textColor = UIColor.whiteColor()
        self.titleLabel?.textAlignment = NSTextAlignment.Center
        self.detailedLabel?.textAlignment = NSTextAlignment.Center
        self.titleLabel?.text = "Enter your  pattern"
        
        patternDocument = DataObjectContainer.sharedInstance.patternDocument
        addBackButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- back Button
    
    func addBackButton() {
        let button: UIButton = UIButton(type: UIButtonType.System)
        button.frame = CGRectMake(10, 30, 20, 25)
        //button.setTitle("<", forState: UIControlState.Normal)
        button.setImage(UIImage(named: "Back_button_png.png"), forState: UIControlState.Normal)
        button.addTarget(self, action:  "backButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    func backButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:- UITouch
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        paths = NSMutableArray()
        self.toucheddots = 0
        self.dotcount = 0
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch =  touches.first
        let pt = touch!.locationInView(self.view)
        let touched: UIView = self.view.hitTest(pt, withEvent: event)!
        let v =  self.view  as! CircleView
        v.drawLineFromLastDotTo(pt)
        
        if touched != self.view && touched.tag != 0 {
            self.toucheddots = touched.tag
            self.dotcount! = dotcount! + 1
            var found: Bool = false
            for tag in paths!  {
                if tag.integerValue == touched.tag {
                    found = true
                }
                else {
                    found = false
                }
                if found == true {
                    break
                }
            }
            if found == true{
                return
            }
            paths?.addObject(touched.tag)
            if touched.tag != 0 {
                v.addDotView(touched)
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let circleView: CircleView =  self.view as! CircleView
        circleView.clearDotViews()
        for view in self.view.subviews {
            if view.isKindOfClass(UIImageView)  {
                self.view.setNeedsDisplay()
            }
        }
        if self.toucheddots > 0 && self.getKey().length != 1 {
            if !(_target == nil) && !(_action == nil)  {
                _target?.performSelector(_action!, withObject: self.getKey())
            }
        }
    }
    
    func getKey() -> NSString {
        let key = NSMutableString()
        for tag in paths! {
            key.appendFormat("%2d", tag.integerValue)
        }
        patternString = key as String
        //  self.saveChanges()
        patternDocument?.patternString = key as String
        
        return key
    }
    
    func setTarget( target: AnyObject , withAction action: (Selector)){
        _target = target
        _action = action
    }
    
    func getPatternLock() -> NSString {
        return NSUserDefaults.standardUserDefaults().stringForKey("lock_string")!
    }
    
    
    func savePatternLock() {
        NSUserDefaults.standardUserDefaults().setObject(patternString, forKey: "lock_string")
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "lock_enabled")
    }
    
    
    func saveChanges(){
        switch (ShowType.RawValue())
        {
        case 0 :
            if patternString == self.getPatternLock() {
                self.dismissViewControllerAnimated(true, completion: nil)
            }else
            {
                numberOfFails = numberOfFails! + 1;
                self.detailedLabel?.text = "Invalid pattern"
            }
            break
        case 1 :
            if _shouldConfirm == true {
                if patternString == _patternToConfirm {
                    self.savePatternLock()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else {
                    self.detailedLabel?.text = "Pattern does not match"
                    self.titleLabel?.text = "Enter your new pattern"
                    _shouldConfirm = false
                }
            }else {
                _patternToConfirm = patternString
                self.titleLabel?.text = "Confrim your new pattern"
                self.detailedLabel?.text = ""
                (_shouldConfirm = !_shouldConfirm)
            }
            break
        default:
            break
            
        }
    }
    
    
    
    
}

