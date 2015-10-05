//
//  DrawPatternLockView.m
//  IosPatternLock
//
//  Created by Laxman on 29/09/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import "DrawPatternLockView.h"

@implementation DrawPatternLockView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (!_trackPointValue)
        return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 4.0);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {0.8, 0.8, 0.8, 0.8};
    CGColorRef color = CGColorCreate(colorspace, components);
    CGContextSetStrokeColorWithColor(context, color);
    
    CGPoint from;
    UIView *lastDot;
    for (UIView *dotView in _dotViews) {
        from = dotView.center;

        if(from.y < 3)
            continue;
        
        if (!lastDot)
            CGContextMoveToPoint(context, from.x, from.y);
        else
            CGContextAddLineToPoint(context, from.x, from.y);
        lastDot = dotView;
    }
        CGPoint pt = [_trackPointValue CGPointValue];
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
    _trackPointValue = nil;
}


- (void)clearDotViews {
    [_dotViews removeAllObjects];
}


- (void)addDotView:(UIView *)view {
    if (!_dotViews)
        _dotViews = [NSMutableArray array];
    
    [_dotViews addObject:view];
}


- (void)drawLineFromLastDotTo:(CGPoint)pt {
    _trackPointValue = [NSValue valueWithCGPoint:pt];
    [self setNeedsDisplay];
}


@end
