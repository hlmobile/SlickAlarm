//
//  FarmViewCon.m
//  SlickTime
//
//  Created by Miles Alden on 5/2/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "FarmNightViewCon.h"
#import "FarmViewCon.h"
#import "SlickTimeAppDelegate.h"
#import "CentralControl.h"
#import "BaseViewCon.h"
#import "TimeFaceCon.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Common.h"
@implementation FarmNightViewCon




- (void)setup
{
    rotationAmount = 0;
    float num = self.view.center.x;
    cloudX =  -(num * 2);
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
}

- (void)stopAllAnimations
{
    NSArray *animKeys = [self.view.layer animationKeys];
    
    NSLog(@"%d", animKeys.count);
    for (NSString *key in animKeys)
        NSLog(@"%@", key);
    [CATransaction begin];
    [windmill.layer removeAllAnimations];
    [clouds.layer removeAllAnimations];
    [foreground.layer removeAllAnimations];
    [backdrop.layer removeAllAnimations];
    [sun.layer removeAllAnimations];
    [moon.layer removeAllAnimations];
    [self.view.layer removeAllAnimations];

    [CATransaction commit];
}
- (void)animate
{
    /*
    if ( cloudX > self.view.center.x * 2 ) 
    {
        float num = self.view.center.x;
        cloudX =  -num;
    }
    */
    rotationAmount += ROTATION_INCREMENT;
    //cloudX += CLOUD_INCREMENT;
    
    
    windmill.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
	[UIView beginAnimations:@"nightview_windmill" context:nil];
	[UIView setAnimationRepeatCount:100000];
	[UIView setAnimationDuration:2];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
    windmill.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
	
	[UIView commitAnimations];
    
    
    clouds.transform = CGAffineTransformMakeTranslation(-clouds.frame.size.width, 0);
    //clouds.transform = CGAffineTransformIdentity;
    [UIView beginAnimations:@"nightview_clouds" context:nil];
	[UIView setAnimationRepeatCount:100000];
	[UIView setAnimationDuration:80];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //clouds.transform = CGAffineTransformMakeTranslation([[UIScreen mainScreen] applicationFrame].size.width + (clouds.frame.size.width + (clouds.frame.size.width / 6)), 0); 
    clouds.transform = CGAffineTransformMakeTranslation(clouds.frame.size.width - 20, 0);
	
	[UIView commitAnimations];
    
    
}
//
//
- (void)transitionToDay
{
    
    SlickTimeAppDelegate *del = (SlickTimeAppDelegate *)APP_DELEGATE;

    if (del.centralCon.sceneState != AlarmRinging)
        del.centralCon.sceneState = TransitionToDayMovieScene;
    NSString *eveForeground = [[NSBundle mainBundle] pathForResource:@"dawn_foreground@2x~iphone" ofType:@"png"];
    NSString *eveWindmill = [[NSBundle mainBundle] pathForResource:@"dawn_windmill@2x~iphone" ofType:@"png"];
    NSString *eveBackdrop = [[NSBundle mainBundle] pathForResource:@"dawn_backdrop~iphone" ofType:@"png"];
    NSString *eveClouds = [[NSBundle mainBundle] pathForResource:@"dawn_clouds@2x~iphone" ofType:@"png"];
   

    
    //CGPoint sunPoint = CGPointMake(-deltaX, deltaY * 1.5);

    
    
    CATransition *transition = [CATransition animation];
    transition.duration = TRANSITION_ANIMATION_DURATION;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
	[foreground.layer addAnimation:transition forKey:nil];
	[backdrop.layer addAnimation:transition forKey:nil];
	[clouds.layer addAnimation:transition forKey:nil];
	[windmill.layer addAnimation:transition forKey:nil];
    
    foreground.image = [UIImage imageWithContentsOfFile:eveForeground];
    clouds.image = [UIImage imageWithContentsOfFile:eveClouds];
    backdrop.image = [UIImage imageWithContentsOfFile:eveBackdrop];
    windmill.image = [UIImage imageWithContentsOfFile:eveWindmill];
    
    
    float deltaX = self.view.frame.size.width;
    float deltaY = self.view.frame.size.height;
    
    CGPoint moonPoint = CGPointMake(deltaX * 2, deltaY * 1.5);
    
    
    [UIView beginAnimations:@"moon_setoff" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:TRANSITION_ANIMATION_DURATION];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(completeDayTransition)];
    
    moon.transform = CGAffineTransformMakeTranslation(moonPoint.x / 2, moonPoint.y / 2);
    
    [UIView commitAnimations];
    
    
}

- (void)completeDayTransition
{
    
    SlickTimeAppDelegate *del = (SlickTimeAppDelegate *)APP_DELEGATE;
    if (del.centralCon.clockStage != SceneStage)
        return;
    NSLog(@"Start Transition");

    NSString *eveForeground = [[NSBundle mainBundle] pathForResource:@"day_foreground@2x~iphone" ofType:@"png"];
    NSString *eveWindmill = [[NSBundle mainBundle] pathForResource:@"day_windmill@2x~iphone" ofType:@"png"];
    NSString *eveBackdrop = [[NSBundle mainBundle] pathForResource:@"day_backdrop~iphone" ofType:@"png"];
    NSString *eveClouds = [[NSBundle mainBundle] pathForResource:@"day_clouds@2x~iphone" ofType:@"png"];

    NSString *sunStr = [[NSBundle mainBundle] pathForResource:@"dawn_sun@2x~iphone" ofType:@"png"];
    
    self->sun = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:sunStr]];
    sun.frame = CGRectMake(0, 0, 313, 309);
    float deltaX = self.view.frame.size.width;
    float deltaY = self.view.frame.size.height;
    
    sun.center = sun.center = CGPointMake(-deltaX / 2, deltaY - 100);
    [self.view insertSubview:sun belowSubview:foreground];
    
    CATransition *transition = [CATransition animation];
    transition.duration = TRANSITION_SUN_RISE_DURATION - 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;

	[foreground.layer addAnimation:transition forKey:nil];
	[backdrop.layer addAnimation:transition forKey:nil];
	[clouds.layer addAnimation:transition forKey:nil];
	[windmill.layer addAnimation:transition forKey:nil];
    [sun.layer addAnimation:transition forKey:nil];
    
    foreground.image = [UIImage imageWithContentsOfFile:eveForeground];
    clouds.image = [UIImage imageWithContentsOfFile:eveClouds];
    backdrop.image = [UIImage imageWithContentsOfFile:eveBackdrop];
    windmill.image = [UIImage imageWithContentsOfFile:eveWindmill];

    
    //CGPoint moonPoint = CGPointMake(deltaX * 2, deltaY * 1.5);
    
    
    
    [UIView beginAnimations:@"sun_rising1" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:TRANSITION_SUN_RISE_DURATION];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedTransition)];
    
   
    //moon.transform = CGAffineTransformMakeTranslation(moonPoint.x, moonPoint.y);
    sun.center = CGPointMake(78, 210);
    [UIView commitAnimations];
    
}


- (void)finishedTransition
{
    NSLog(@"Finished Transition");
    SlickTimeAppDelegate *del = (SlickTimeAppDelegate *)APP_DELEGATE;
    if (del.centralCon.clockStage != SceneStage)
        return;
    if (del.centralCon.sceneState != AlarmRinging && del.centralCon.sceneState != AlarmSnoozing)
        del.centralCon.sceneState = Idle;
    [self stopAllAnimations];
    [del.centralCon unloadNightFarmScene];
    [del.centralCon loadFarmScene];
    [del.centralCon.baseVCon.view insertSubview:[del.centralCon farmViewCon].view belowSubview:[del.centralCon clockFace].view];
}





- (void)animationDidStart:(CAAnimation *)anim
{
    printf("\nanimation did start\n");
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    printf("\nanimation did stop\n");
    
}

- (void)transitionToNight
{
	NSLog(@"Unimplemented method called:  -(void)transitionToNight");
}

- (void)completeNightTransition
{
	NSLog(@"Unimplemented method called:  -(void)completeNightTransition");
}

- (void)dealloc
{
    
    
    [self stopAllAnimations];

    [sun removeFromSuperview];
    [sun release];
    
    [backdrop removeFromSuperview];
    [backdrop release];
    
    [clouds removeFromSuperview];
    [clouds release];
    
    [windmill removeFromSuperview];
    [windmill release];
    
    [foreground removeFromSuperview];
    [foreground release];
    
    [moon removeFromSuperview];
    [moon release];
    
    
    [super dealloc];
}




@end
