//
//  CircleView.swift
//  SamplePattern
//
//  Created by Laxman on 30/09/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class CircleView: UIView {
    var trackPointValue: NSValue?
    var dotViews: NSMutableArray? = {
        var dotview: NSMutableArray?
        if dotview == nil {
            dotview = NSMutableArray()
        }
        return dotview!
        }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        if trackPointValue == nil {
            return
        }
        let context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 2.0);
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.8,0.8,0.8,0.8]
        let color = CGColorCreate(colorspace, components)
        CGContextSetStrokeColorWithColor(context, color)
        
        var from: CGPoint?
        var lastDot: UIView?
        for  dotView  in dotViews! {
            from = dotView.center
            if from!.y < 3 {
                continue;
            }
            if !(lastDot != nil) {
                CGContextMoveToPoint(context, (from?.x)!, (from?.y)!)
            }else {
                CGContextAddLineToPoint(context, (from?.x)!, (from?.y)!)
            }
            lastDot = dotView as? UIView
           // trackPointValue = nil
        }
        let pt: CGPoint =  (trackPointValue!.CGPointValue())
        CGContextAddLineToPoint(context, pt.x, pt.y)
        CGContextStrokePath(context)
    }
    
    func clearDotViews() {
        dotViews!.removeAllObjects()
    }
    
    func addDotView(view: UIView){
        if (dotViews?.count == 0) {
            dotViews = NSMutableArray()
        }
        dotViews!.addObject(view)
    }
    
    func drawLineFromLastDotTo(pt: CGPoint) {
        trackPointValue = NSValue(CGPoint: pt)
        self.setNeedsDisplay()
    }
}






