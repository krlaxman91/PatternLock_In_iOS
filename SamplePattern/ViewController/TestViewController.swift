//
//  TestViewController.swift
//  SamplePattern
//
//  Created by Laxman on 30/09/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Set Pattern"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- IBAction Methods:
    
    @IBAction func add(sender: AnyObject) {
        let patternLockViewController: ViewController = ViewController()
        patternLockViewController.showPatternLockFor(ShowType.showForEnable, withActiveDotImage: UIImage(named: "circle.png")!  , withInactiveDotImage:UIImage(named: "circle.png")!, withLineColor: UIColor.yellowColor())
    }
    
    @IBAction func patternMatch(sender: AnyObject) {
    
        let patternLockViewController: ViewController = ViewController()
        patternLockViewController.showPatternLockFor(ShowType.showForAuthenticate, withActiveDotImage: UIImage(named: "circle.png")!  , withInactiveDotImage:UIImage(named: "circle.png")!, withLineColor: UIColor.yellowColor())
    
    }
    
}
