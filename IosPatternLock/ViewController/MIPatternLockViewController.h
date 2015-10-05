//
//  MIPatternLockViewController.h
//  IosPatternLock
//
//  Created by Laxman on 29/09/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum {
    showForAuthenticate = 0,
    showForEnable,
    showForChange
  } ShowType;

@interface MIPatternLockViewController : UIViewController {
    NSMutableArray* _paths;
    
    // after pattern is drawn, call this:
    id _target;
    SEL _action;
}

- (void) showPatternLockFor:(ShowType) type withActiveDotImage:(UIImage *) activeDot withInactiveDotImage:(UIImage *)inactiveDot withLineColor:(UIColor *) color withCompletionHandler:(void (^)(MIPatternLockViewController *viewController, NSString * patternString)) block;

@end
