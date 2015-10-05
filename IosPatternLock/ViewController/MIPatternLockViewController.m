//
//  MIPatternLockViewController.m
//  IosPatternLock
//
//  Created by Laxman on 29/09/15.
//  Copyright © 2015 mac. All rights reserved.
//



#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_LOCK_ENABLED @"lock_enabled"
#define LOCK_STRING @"lock_string"

#import "MIPatternLockViewController.h"
#import "DrawPatternLockView.h"

static void (^completionBlock)();

#define MATRIX_SIZE 3

@interface MIPatternLockViewController() {
    UIColor *_lineColor;
    UIImage *_activeImage;
    UIImage *_inactiveImage;
    NSString *_patternString;
    ShowType _type;
    NSInteger _numberOfFails;
    BOOL _shouldConfirm;
    NSString *_patternToConfirm;
}

@property (nonatomic) int toucheddots;
@property (nonatomic) int dotcount;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailedLabel;



// get key from the pattern drawn
- (NSString*)getKey;

- (void)setTarget:(id)target withAction:(SEL)action;

@end


@implementation MIPatternLockViewController

- (void) showPatternLockFor:(ShowType) type withActiveDotImage:(UIImage *) activeDot withInactiveDotImage:(UIImage *)inactiveDot withLineColor:(UIColor *) color withCompletionHandler:(void (^)(MIPatternLockViewController *viewController, NSString * patternString)) block
{
    _activeImage = activeDot;
    _inactiveImage = inactiveDot;
    _lineColor = color;
    _type = type;
    completionBlock = block;
    
    
    [[[[UIApplication sharedApplication] delegate] window].rootViewController presentViewController:self animated:YES completion:nil];
}


#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    
    self.view = [[DrawPatternLockView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)makeNavigationBar
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 30,50 , 50);
    [button setTitle:@"<" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)backButtonAction{
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self makeNavigationBar];
    
    float x ;
    float y;
    
    if([UIScreen mainScreen].bounds.size.height == 568) {
        x = 50;
        y = 180;
    } else {
        x = 80;
        y = 200;
    }
    int line = MATRIX_SIZE;
    for (int i=0; i<MATRIX_SIZE * MATRIX_SIZE; i++) {
        UIImage *dotImage = _inactiveImage;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:dotImage
                                                   highlightedImage:_activeImage];
                imageView.frame = CGRectMake(x, y, 30, 30);
        imageView.userInteractionEnabled = YES;
        imageView.tag = (i+1);
        [self.view addSubview:imageView];
        x+= 100;
        if((i+1) % line == 0)
        {
            y += 100;
            if([UIScreen mainScreen].bounds.size.height == 568) {
                x = 50;
            } else {
                x = 80;
            }
        }
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    
    CGRect rect = CGRectMake(0, 40, 320, 40);
    self.titleLabel = [[UILabel alloc] initWithFrame:rect];
    rect.origin.y += 40;
    self.detailedLabel = [[UILabel alloc] initWithFrame:rect];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.detailedLabel];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.detailedLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.detailedLabel.textAlignment = NSTextAlignmentCenter;
    if(_type == showForChange)
        self.titleLabel.text = @"Enter your old pattern";
    else
        self.titleLabel.text = @"Enter your pattern";
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _paths = [[NSMutableArray alloc] init];
    self.toucheddots = 0;
    self.dotcount = 0;
}

-(BOOL)array:(NSArray*)array containsNumber:(NSNumber*)number
{
    for(NSNumber *n in array){
        if([n isEqualToNumber:number]) return YES;
    }
    return NO;
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint pt = [[touches anyObject] locationInView:self.view];
    UIView *touched = [self.view hitTest:pt withEvent:event];
        DrawPatternLockView *v = (DrawPatternLockView*)self.view;
    [v drawLineFromLastDotTo:pt];
    
    if (touched!=self.view && touched.tag != 0) {
        self.toucheddots = touched.tag;
        self.dotcount++;
        
        BOOL found = NO;
        for (NSNumber *tag in _paths) {
            found = tag.integerValue==touched.tag;
            if (found)
                break;
        }
                if (found)
            return;
        
        if( touched.tag == [((NSNumber *)[_paths lastObject]) intValue] + 6)
        {
            // To Avoid first touched 6
            if ([((NSNumber *)[_paths lastObject]) intValue]) {
                UIView *view = [self.view viewWithTag:[((NSNumber*) [_paths lastObject]) intValue] + 3];
                ((UIImageView *) view).highlighted = YES;
                [_paths addObject:[NSNumber numberWithInt:[((NSNumber *)[_paths lastObject]) intValue] + 3]];
                [v addDotView:view];
            }
        }
                if( touched.tag == [((NSNumber *)[_paths lastObject]) intValue] + 2)
        {
            if(([((NSNumber *)[_paths lastObject]) intValue] + 2) % 3 == 0)
            {
                UIView *view = [self.view viewWithTag:[((NSNumber*) [_paths lastObject]) intValue] + 1];
                ((UIImageView *) view).highlighted = YES;
                [_paths addObject:[NSNumber numberWithInt:[((NSNumber *)[_paths lastObject]) intValue] + 1]];
                [v addDotView:view];
            }
        }
        
        if(touched.tag == [((NSNumber *)[_paths lastObject]) intValue] + 8)
        {
            // To Avoid first touched 8
            if ([((NSNumber *)[_paths lastObject]) intValue]) {
                UIView *view = [self.view viewWithTag:[((NSNumber*) [_paths lastObject]) intValue] + 4];
                ((UIImageView *) view).highlighted = YES;
                [_paths addObject:[NSNumber numberWithInt:[((NSNumber *)[_paths lastObject]) intValue] + 4]];
                [v addDotView:view];
            }
        }
        
        [_paths addObject:[NSNumber numberWithInt:touched.tag]];
        
        
        if(touched.tag != 0)
        {
            [v addDotView:touched];
            UIImageView* iv = (UIImageView*)touched;
            iv.highlighted = YES;
        }
        
    }
    
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // clear up hilite
    DrawPatternLockView *v = (DrawPatternLockView*)self.view;
    [v clearDotViews];
    
    for (UIView *view in self.view.subviews)
        if ([view isKindOfClass:[UIImageView class]])
            [(UIImageView*)view setHighlighted:NO];
    [self.view setNeedsDisplay];
    
    if(self.toucheddots && [[self getKey] length] != 1)
    {
        // pass the output to target action...
        if (_target && _action)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [_target performSelector:_action withObject:[self getKey]];
#pragma clang diagnostic pop
    }
}


// get key from the pattern drawn
// replace this method with your own key-generation algorithm
- (NSString*)getKey {
    NSMutableString *key;
    key = [NSMutableString string];
    
    // simple way to generate a key
    for (NSNumber *tag in _paths) {
        [key appendFormat:@"%d", tag.integerValue];
    }
    _patternString = key;
    [self saveChanges];
    return key;
}


- (void)setTarget:(id)target withAction:(SEL)action {
    _target = target;
    _action = action;
}

- (void) saveChanges
{
    switch (_type) {
        case 0:
            if([_patternString isEqualToString:[self getPatternLock]]) {
                [self dismissViewControllerAnimated:YES completion:nil];
                completionBlock(self, _patternString);
            } else {
                _numberOfFails++;
                self.detailedLabel.text = @"Invalid pattern";
            }
            break;
            
        case 1:
            if(_shouldConfirm) {
                if([_patternString isEqualToString:_patternToConfirm]) {
                    [self savePatternLock];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    completionBlock(self, _patternString);
                } else {
                    self.detailedLabel.text = @"Pattern does not match";
                    self.titleLabel.text = @"Enter your new pattern";
                    _shouldConfirm = NO;
                }
            } else {
                _patternToConfirm = _patternString;
                self.titleLabel.text = @"Confrim your new pattern";
                self.detailedLabel.text = @"";
                _shouldConfirm = !_shouldConfirm;
            }
            break;
            
        case 2:
            if([_patternString isEqualToString:[self getPatternLock]]) {
                self.titleLabel.text = @"Enter your new pattern";
                self.detailedLabel.text = @"";
                _type = showForEnable;
            } else {
                _numberOfFails++;
                self.detailedLabel.text = @"Invalid pattern";
            }
            break;
        default:
            break;
    }
}

- (NSString *) getPatternLock
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:LOCK_STRING];
}

- (void) savePatternLock
{
    [[NSUserDefaults standardUserDefaults] setObject:_patternString forKey:LOCK_STRING];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_LOCK_ENABLED];
}


- (IBAction)setPatternHidden:(id)sender {
   
    
  
}




@end
