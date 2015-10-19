//
//  DrawPatternLockView.h
//  IosPatternLock
//
//  Created by Laxman on 29/09/15.
//  Copyright © 2015 mac. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface DrawPatternLockView : UIView {
    NSValue *_trackPointValue;
    NSMutableArray *_dotViews;
}

@property (nonatomic, strong) UIButton *setHidePatternMatch;

- (void)clearDotViews;
- (void)addDotView:(UIView*)view;
- (void)drawLineFromLastDotTo:(CGPoint)pt;
@end
