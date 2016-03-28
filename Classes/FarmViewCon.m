//
//  FarmViewCon.m
//  SlickTime
//
//  Created by Miles Alden on 5/2/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "FarmViewCon.h"
#import "SlickTimeAppDelegate.h"
#import "CentralControl.h"
#import "BaseViewCon.h"
#import "TimeFaceCon.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Common.h"
@implementation FarmViewCon




- (void)setup
{
    rotationAmount = 0;
    float num = self.view.center.x;
    cloudX =  -(num * 2);
    
    
}
- (void)stopAllAnimations
{
    [CATransaction begin];
    [windmill.layer removeAllAnimations];
    [clouds.layer removeAllAnimations];
    [foreground.layer removeAllAnimations];
    [backdrop.layer removeAllAnimations];
    [CATransaction commit];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    
}
//
//
- (void)animate
{
    if ( cloudX > self.view.center.x * 2 ) 
    {
        float num = self.view.center.x;
        cloudX =  -num;
    }
    
    rotationAmount += ROTATION_INCREMENT;
    cloudX += CLOUD_INCREMENT;
    
    
    
    windmill.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
    [UIView beginAnimations:@"farmview_windmill" context:nil];
	[UIView setAnimationRepeatCount:10000];
	[UIView setAnimationDuration:2];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
    windmill.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
	
	[UIView commitAnimations];

    
    clouds.transform = CGAffineTransformMakeTranslation(-clouds.frame.size.width, 0);

    [UIView beginAnimations:@"farmview_clouds" context:nil];
	[UIView setAnimationRepeatCount:10000];
	[UIView setAnimationDuration:80];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
    clouds.transform = CGAffineTransformMakeTranslation(clouds.frame.size.width - 20, 0);
	
	[UIView commitAnimations];

}

- (void)animate_
{

}
//
//Day Background -> Semi Night Background, Sun set off
- (void)transitionToNight
{
    SlickTimeAppDelegate *del = (SlickTimeAppDelegate *)APP_DELEGATE;
    if (del.centralCon.sceneState != AlarmRinging)
        del.centralCon.sceneState = TransitionToNightMovieScene;
    
    NSString *eveForeground = [[NSBundle mainBundle] pathForResource:@"dusk_foreground@2x~iphone" ofType:@"png"];
    NSString *eveWindmill = [[NSBundle mainBundle] pathForResource:@"dusk_windmill@2x~iphone" ofType:@"png"];
    NSString *eveBackdrop = [[NSBundle mainBundle] pathForResource:@"dusk_backdrop~iphone" ofType:@"png"];
    NSString *eveClouds = [[NSBundle mainBundle] pathForResource:@"dusk_clouds@2x~iphone" ofType:@"png"];
    
    

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
    
    CGPoint sunPoint = CGPointMake(deltaX * 2, deltaY * 1.5);
    
    
    [UIView beginAnimations:@"sun_setoff" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:TRANSITION_ANIMATION_DURATION];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(completeNightTransition)];
    
    sun.transform = CGAffineTransformMakeTranslation(sunPoint.x / 2, sunPoint.y / 2);
    
    
    [UIView commitAnimations];


}

- (void)raiseSun
{
    
    float deltaX = self.view.frame.size.width;
    float deltaY = self.view.frame.size.height;
    sun.transform = CGAffineTransformMakeTranslation(0, 0);
    sun.center = CGPointMake(-deltaX / 2, deltaY - 100);
    [UIView beginAnimations:@"moon_rising" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:TRANSITION_SUN_RISE_DURATION];
    sun.center = CGPointMake(78, 210);
    
    [UIView commitAnimations];
}

//Semi Night Background -> Day Background, Moon rise

- (void)completeNightTransition
{
    SlickTimeAppDelegate *del = (SlickTimeAppDelegate *) APP_DELEGATE;
    if (del.centralCon.clockStage == SettingStage)
        return;
    
    NSString *eveForeground = [[NSBundle mainBundle] pathForResource:@"night_foreground@2x~iphone" ofType:@"png"];
    NSString *eveWindmill = [[NSBundle mainBundle] pathForResource:@"night_windmill@2x~iphone" ofType:@"png"];
    NSString *eveBackdrop = [[NSBundle mainBundle] pathForResource:@"night_backdrop~iphone" ofType:@"png"];
    NSString *eveClouds = [[NSBundle mainBundle] pathForResource:@"night_clouds@2x~iphone" ofType:@"png"];
    NSString *moonStr = [[NSBundle mainBundle] pathForResource:@"crecent_moon@2x~iphone" ofType:@"png"];

    
    self->moon = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:moonStr]];
    moon.frame = CGRectMake(0, 0, 156, 156);

    float deltaX = self.view.frame.size.width;
    float deltaY = self.view.frame.size.height;

    moon.center = CGPointMake(-deltaX / 2, deltaY - 100);
    [self.view insertSubview:moon belowSubview:foreground];
    
    CATransition *transition = [CATransition animation];
    transition.duration = TRANSITION_SUN_RISE_DURATION - 1;
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

    

    
    //CGPoint sunPoint = CGPointMake(deltaX * 2, deltaY * 1.5);

    
    
    [UIView beginAnimations:@"moon_rising" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:TRANSITION_SUN_RISE_DURATION];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedTransition)];
    
    //sun.transform = CGAffineTransformMakeTranslation(sunPoint.x, sunPoint.y);
    moon.center = CGPointMake(62, 213);
    
    [UIView commitAnimations];

}


- (void)finishedTransition
{
    SlickTimeAppDelegate *del = (SlickTimeAppDelegate *)APP_DELEGATE;
    if (del.centralCon.clockStage == SettingStage)
        return;
    if (del.centralCon.sceneState != AlarmRinging && del.centralCon.sceneState != AlarmSnoozing)
        del.centralCon.sceneState = Idle;
    [del.centralCon unloadFarmScene];
    [del.centralCon loadNightFarmScene];
    [del.centralCon.baseVCon.view insertSubview:[del.centralCon farmNightSceneCon].view belowSubview:[del.centralCon clockFace].view];
}


- (void)transitionToDay
{
    
}



- (void)animationDidStart:(CAAnimation *)anim
{
    printf("\nanimation did start\n");
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    printf("\nanimation did stop\n");
    
}



- (void)dealloc
{
    [self stopAllAnimations];

    [sun release];
    [sun removeFromSuperview];
    
    [backdrop release];
    [backdrop removeFromSuperview];

    [clouds release];
    [clouds removeFromSuperview];

    [windmill release];
    [windmill removeFromSuperview];

    [foreground release];
    [foreground removeFromSuperview];

    [moon removeFromSuperview];
    [moon release];
    
    [super dealloc];
}




@end
