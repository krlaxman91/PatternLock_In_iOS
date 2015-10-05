//
//  ViewController.m
//  IosPatternLock
//
//  Created by Laxman on 29/09/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import "ViewController.h"
#import "MIPatternLockViewController.h"
#import "PatternDocument.h"
#import "DataObjectContainer.h"

@interface ViewController ()
{
    PatternDocument *_patternDocument;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _patternDocument = [DataObjectContainer sharedInstance].patternDocument;
}


- (IBAction)setPattern:(id)sender {
    
    MIPatternLockViewController *patternLockVC = [[MIPatternLockViewController alloc] init];
    [patternLockVC showPatternLockFor:showForEnable withActiveDotImage:[UIImage imageNamed:@"whitecircle.png"] withInactiveDotImage:[UIImage imageNamed:@"whitecircle.png"] withLineColor:nil withCompletionHandler:^(MIPatternLockViewController *viewController, NSString *patternString) {
        NSLog(@"%@", patternString);
        _patternDocument.patternString = patternString;
    }];
}


- (IBAction)matchPattern:(id)sender {
    
    MIPatternLockViewController *patternLockVC = [[MIPatternLockViewController alloc] init];
    [patternLockVC showPatternLockFor:showForAuthenticate withActiveDotImage:[UIImage imageNamed:@"whitecircle.png"] withInactiveDotImage:[UIImage imageNamed:@"whitecircle.png"] withLineColor:nil withCompletionHandler:^(MIPatternLockViewController *viewController, NSString *patternString) {
        NSLog(@"%@", patternString);
    }];

}

@end
