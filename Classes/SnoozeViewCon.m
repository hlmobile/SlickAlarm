//
//  SnoozeViewCon.m
//  SlickTime
//
//  Created by Jin Bei on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SnoozeViewCon.h"
#import "SlickTimeAppDelegate.h"
#import "CentralControl.h"
#import "QuartzCore/QuartzCore.h"

#define kAccelerationThrethold 1.5
#define kUpdateInterval        (1.0f/10.0f)

@implementation SnoozeViewCon

@synthesize vwClickableScroll, vwBackground;
@synthesize vwSnoozeImage;
@synthesize accel;


int VIEWHEIGHT = 400;
int PADDING = 100;

#pragma mark - Dealloc
- (void)dealloc
{
    if (accel)
    {
        accel.delegate = nil;
        [accel release];
    }
    [vwBackground release];
    [vwClickableScroll removeFromSuperview];
    [vwClickableScroll release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
}

#pragma mark - Initialize
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, 320, VIEWHEIGHT);
    [vwClickableScroll setMovable:YES];
    vwClickableScroll.bounces = NO;
    vwClickableScroll.frame = CGRectMake(0, 0, 320, VIEWHEIGHT);
    vwClickableScroll.contentSize = CGSizeMake(320, VIEWHEIGHT);
    vwClickableScroll.contentInset = UIEdgeInsetsMake(VIEWHEIGHT - PADDING, 0, 0, 0);
    vwClickableScroll.subView.frame = CGRectMake(0, PADDING - VIEWHEIGHT, 320, VIEWHEIGHT);
    vwClickableScroll.delegate = self;
    vwBackground.frame = CGRectMake(0 , -20, 320, VIEWHEIGHT + 20);
    //vwBackground.layer.cornerRadius = 25;
    //vwBackground.layer.masksToBounds = YES;
    
    //Shaking
    vwSnoozeImage.animationDuration = 0.3;
    vwSnoozeImage.animationRepeatCount = 0;
    vwSnoozeImage.animationImages = [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"snooze_handler1"],
                                     [UIImage imageNamed:@"snooze_handler2"], nil];
    [vwSnoozeImage startAnimating];
    self. accel = [UIAccelerometer sharedAccelerometer];
    accel.delegate = self;
    accel.updateInterval = kUpdateInterval;
}
- (void)snoozeAlarm
{
    [vwClickableScroll setContentOffset:CGPointMake(0, PADDING - VIEWHEIGHT) animated:YES];
    [vwSnoozeImage stopAnimating];
}
- (void)fireAlarm
{
    [vwClickableScroll setMovable:YES];
    [vwClickableScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    self. accel = [UIAccelerometer sharedAccelerometer];
    [vwSnoozeImage startAnimating];
    accel.delegate = self;
    accel.updateInterval = kUpdateInterval;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y == PADDING - VIEWHEIGHT)
    {
        SlickTimeAppDelegate *del = (SlickTimeAppDelegate *)APP_DELEGATE;
        [del.centralCon snoozeAlarm];
        [vwClickableScroll setMovable:NO];
    }
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake)
        [self snoozeAlarm];
    [super motionEnded:motion withEvent:event];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - UIAccelerometerDelegate
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    if (ABS(acceleration.x) > kAccelerationThrethold
        || ABS(acceleration.y) > kAccelerationThrethold
        || ABS(acceleration.z) > kAccelerationThrethold)
    {
        [self snoozeAlarm];
        accel.delegate = nil;
        self.accel = nil;
    }
    
}

@end
