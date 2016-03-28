//
//  CentralControl.m
//  SlickTime
//
//  Created by Miles Alden on 5/2/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "CentralControl.h"
#import "WeatherSetting.h"
#import "SleepControl.h"
#import <QuartzCore/QuartzCore.h>
#import "SettingsViewCon.h"
#import "SettingsRootViewCon.h"
#import "SlickTimeAppDelegate.h"
#import "Alarm.h"
#import "SleepSetting.h"
#import "Button.h"
#import "GameSound.h"
#import "WeatherFetch.h"
#import "SnoozeViewCon.h"
#import "InfoScreenCon.h"
#import "BaseViewCon.h"
#import "TimeFaceCon.h"
#import "FarmNightViewCon.h"
#import "FarmViewCon.h"
#import "WeatherViewCon.h"
#import "WeatherSettingsCon.h"
#import "ClockRooster.h"
#include <mach/mach.h>
#include <mach/mach_time.h>

void report_memory(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), 
                                   TASK_BASIC_INFO, 
                                   (task_info_t)&info, 
                                   &size);
    if (kerr == KERN_SUCCESS)
    {
        NSLog(@"Memory in use (in bytes): %u  (in mb) %u", info.resident_size, (int)(info.resident_size/ (1024 * 1024)));
    }
    else
    {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
    }
}

@interface CentralControl (Private) {
@private
    
}
- (BOOL)isNight;
@end

@implementation CentralControl

@synthesize baseVCon, alarmBeingEdited, elapsedTime;
@synthesize clockStage;
@synthesize loadedScene, sceneState;
@synthesize audioPlayer, musicPlayer;
- (void)setup {
    if ([self isNight])
        loadedScene = NightFarmScene;
    else
        loadedScene = FarmScene;
    
    sceneState = Idle;
    
    [self updateSelectors];
    [self setupFlashlightSession];
	//[self playBackgroundSilence];
    
    
    self->oldDate = [[NSDate date] retain];
	self->formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
      
	self->baseVCon = [[BaseViewCon alloc] initWithNibName:@"BaseViewCon" bundle:nil];

    
    [Alarm loadAlarms];
    [SleepSetting loadSleepSetting];
    [self performSelector:videoSceneToLoad];
	[self loadClockFace];
//    [self loadSnoozeView];
    [WeatherControl requestWeatherWithDelegate:self];
    self.musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    
}


- (void)resetFrameTimer: (id)target repeats: (BOOL)repeatVal
{
    if ( movieTimer != nil ) 
    {
        [movieTimer invalidate];
        self->movieTimer = nil;
    }
    self->movieTimer = [NSTimer timerWithTimeInterval:1 / FRAMES_PER_SECOND target:target selector:@selector(animate) userInfo:nil repeats:repeatVal];
    [[NSRunLoop mainRunLoop] addTimer:movieTimer forMode:NSDefaultRunLoopMode];
    
}
- (void)stopFrameTimer
{
    if ( movieTimer != nil ) 
    {
        [movieTimer invalidate];
        self->movieTimer = nil;
    }
    
}


- (void)purge
{
    if ( farmSceneCon ) {
		[farmSceneCon release];
		self->farmSceneCon = nil;
	}
	
	if ( timeFaceCon ) {
		[timeFaceCon release];
		self->timeFaceCon = nil;
	}

    if (snoozeViewCon)
    {
        [snoozeViewCon release];
        self->snoozeViewCon = nil;
    }

    if ( farmSceneCon ) {
		[farmSceneCon release];
		self->farmSceneCon = nil;
	}
	
}















#pragma mark -
#pragma mark Clock
- (BOOL)isNight
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [calendar components:(NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:[NSDate date]];
    int hour = dateComps.hour;
    
    if (hour >= 19 || hour < 7)
        return YES;
    return NO;
    
}

- (void)checkAndUpdateScene
{
    
    if([self isNight])
    {
        if (loadedScene == FarmScene)
        {
            if (sceneState == Idle)
                [farmSceneCon transitionToNight];
        }
    }
    else
    {
        if (loadedScene == NightFarmScene)
        {
            if (sceneState == Idle)
                [farmNightSceneCon transitionToDay];
        }
    }
}

- (void)updateClock 
{
    
    report_memory();
    
    if (sceneState == AlarmRinging)
    {
        [timeFaceCon toggleAlarmFlash];
    }
    
    [[SleepControl sharedSleepControl] reduceVolumn];
    
    int minutes = (int)[self runMinuteCheckOn:DateOldDate] ;
    int minutes_ = (int)[self runMinuteCheckOn:DateNewDate];
    

    int hour = (int)[self runHourCheckOn:DateOldDate] ;
    int hour_ = (int)[self runHourCheckOn:DateNewDate];
    
    if ( hour - hour_ != 0)
    {
        SlickTimeAppDelegate *appDelegate = (SlickTimeAppDelegate *)APP_DELEGATE;
        [appDelegate requestUserLocation];
        [WeatherControl requestWeatherWithDelegate:self];
    }
    if ( minutes - minutes_ != 0 ) 
    {
        [self resetOldDate];
        [self incrementClock];
        [self checkAndUpdateScene];
    }
    
}


- (void)resetOldDate
{
    [oldDate release];
    self->oldDate = nil;
    self->oldDate = [[NSDate date] retain];
}


// [See: NOTE (AppFireState)]:
//- (void)setAppFireState: (int)fireState
//{
//    appFireState = fireState;
//}

// [See: NOTE (AppFireState)]:
//- (BOOL)isAppReadyToFireNewAlarm
//{
//   return ( appFireState != AppFireStatePlaying );
//}

- (void)checkBatteryState
{
    float batteryLevel = getBatteryLevel();
    if (batteryLevel >= 0 && batteryLevel <= 0.4)
    {
        [timeFaceCon.lblBatteryState setHidden:NO];
    }
    else
    {
        [timeFaceCon.lblBatteryState setHidden:YES];
        return;
    }
    if (batteryLevel >= 0)
        timeFaceCon.lblBatteryState.text = [NSString stringWithFormat:@"%g%%", batteryLevel * 100.0];
    else
        timeFaceCon.lblBatteryState.text = @"Plugged in";
    
    if (0 <= batteryLevel && batteryLevel <= 0.25)
    {
        if (![SleepSetting sharedSleepSetting].autoLockEnabled)
        {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"Your battery is not safe. Your autolock setting will be canceled"
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                   otherButtonTitles: nil] autorelease];
            [alert show];
            [[SleepSetting sharedSleepSetting] setAutoLockEnabled:NO];
        }
    }
    else {
        [[SleepSetting sharedSleepSetting] setAutoLockEnabled:YES];
    }
}

- (void)updateLocalPlace
{
    [timeFaceCon updateLocalPlace];
}


- (void)incrementClock
{
    [timeFaceCon updateTimeWithAnimation:NO];
    [self checkBatteryState];
    
}


- (void)handleAlarmNotification: (UILocalNotification *)notification
{
    NSLog(@"Notification Received");
	Alarm *alarm = [Alarm alarmForNotification: notification];
    [self fireAlarm:alarm];
}

- (void)playSound:(NSString *)fileName
{
    if (audioPlayer != nil)
        [audioPlayer stop];
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"];
    NSURL *soundURL = [[[NSURL alloc] initFileURLWithPath:soundPath] autorelease];
    self.audioPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil] autorelease];
    audioPlayer.numberOfLoops = -1;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}

- (void)playMusic:(NSArray *)musicList
{
    NSMutableArray *itemsList = [NSMutableArray array];
    for (int i = 0; i < musicList.count; i ++)
    {
        NSDictionary *musicInfo = [musicList objectAtIndex:i];
        NSNumber *persistentId = [musicInfo objectForKey:@"pid"];
        MPMediaQuery *songQuery = [MPMediaQuery songsQuery];
        [songQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:persistentId forProperty:MPMediaItemPropertyPersistentID]];
        NSArray *matchingList = [songQuery items];
        if (matchingList.count > 0)
        {
            MPMediaItem *item = [matchingList objectAtIndex:0];
            [itemsList addObject:item];
        }
    }
    if (itemsList.count > 0)
    {
        MPMediaItemCollection *collection = [MPMediaItemCollection collectionWithItems:itemsList];
        [self.musicPlayer setQueueWithItemCollection:collection];
    }
    else
        [self.musicPlayer setQueueWithQuery:[[[MPMediaQuery alloc] init] autorelease]];
    self.musicPlayer.repeatMode = MPMusicRepeatModeAll;
    [self.musicPlayer play];
}

- (void)stopSound
{
    if (audioPlayer != nil)
        [audioPlayer stop];
    self.audioPlayer = nil;
    [self.musicPlayer stop];
}

- (void)fireAlarm:(Alarm *)alarm
{
    
    if (clockStage == SettingStage)
    {
        [self flipView];
        
        [self performSelector:@selector(fireAlarm:) withObject:alarm afterDelay:1.0];
        return;
    }
    
    
    
	if (loadedScene == FarmScene)
    {
        [farmSceneCon raiseSun];
    }
    else if (loadedScene == NightFarmScene)
    {
        [farmNightSceneCon transitionToDay];
    }
    
    
    
    [self loadRooster];
    if (alarm.roosterCrowOn)
        [roosterView playRoosterSound];
    [roosterView animate];
    
    //[timeFaceCon startRinging];
    MPMusicPlayerController *player = [MPMusicPlayerController iPodMusicPlayer];
    player.volume = 0.5;
    NSString *soundFile = soundFileNameAtIndex(alarm.alarmSound);
    if (alarm.playFromLibrary)
        [self playMusic:alarm.musicList];
    else
        [self playSound:soundFile];
    /*
    if (sceneState == AlarmSnoozing)
    {
        [snoozeViewCon fireAlarm];
    }
    else 
    */    
        if (alarm.snoozeSettings != SnoozeOptionOff)
    {
        [self loadSnoozeView];
        snoozeViewCon.view.transform = CGAffineTransformMakeTranslation(0, -50);
        [UIView beginAnimations:@"snooze" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.2];
        snoozeViewCon.view.transform = CGAffineTransformMakeTranslation(0, 0);
        [UIView commitAnimations];
    }
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.5];
    [[SleepControl sharedSleepControl] stopSleepMusic];
    sceneState = AlarmRinging;
}
- (void)snoozeAlarm
{
    [roosterView stopRoosterSound];
    [self unloadRooster];
    [self unloadSnoozeView];
    sceneState = AlarmSnoozing;
    [self stopSound];
    SlickTimeAppDelegate *appDelegate = (SlickTimeAppDelegate *)APP_DELEGATE;
    [appDelegate snoozeCurrentAlarm];
}

- (void)stopFiringAlarm
{
    
    [self unloadRooster];
    [self unloadSnoozeView];
    [self stopSound];
    
    [timeFaceCon stopRinging];
    [timeFaceCon setAlarm:[Alarm comingAlarm]];
    [self performSelector:(videoSceneToUnload)];
    [self checkAndUpdateScene];
    [self performSelector:(videoSceneToLoad)];
    [self.baseVCon.view bringSubviewToFront:timeFaceCon.view];
    [Alarm scheduleAll];
    sceneState = Idle;
    
}


- (int)runMinuteCheckOn: (int)which
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *dateComps;
    NSDate *date = [NSDate date];
    if (which == DateOldDate)
        dateComps = [cal components:(NSMinuteCalendarUnit) fromDate:oldDate];
    else
        dateComps = [cal components:(NSMinuteCalendarUnit) fromDate:date];
    return dateComps.minute;
}

- (int)runHourCheckOn: (int)which
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *dateComps;
    NSDate *date = [NSDate date];
    if (which == DateOldDate)
        dateComps = [cal components:(NSHourCalendarUnit) fromDate:oldDate];
    else
        dateComps = [cal components:(NSHourCalendarUnit) fromDate:date];
    return dateComps.hour;
}




#pragma -
#pragma Flashlight setup

- (void)setupFlashlightSession {
    // initialize flashlight
    // test if this class even exists to ensure flashlight is turned on ONLY for iOS 4 and above
    return;
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]){
            
            
            //Setup device input
            if (device.torchMode == AVCaptureTorchModeOff) {
                                
                AVCaptureDeviceInput *flashInput = [AVCaptureDeviceInput deviceInputWithDevice:device error: nil];
                AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
                
                self->torchSession = [[AVCaptureSession alloc] init];
                
                [torchSession beginConfiguration];
                [device lockForConfiguration:nil];
                
                [torchSession addInput:flashInput];
                [torchSession addOutput:output];
                
                [device unlockForConfiguration];
                
                [output release];
                
                [torchSession commitConfiguration];
                [torchSession startRunning];
                
//                [self setTorchSession:session];
//                [session release];
            }
        }
    }

}


- (void)playBackgroundSilence {

	SlickTimeAppDelegate *del = (SlickTimeAppDelegate *)APP_DELEGATE;
	[del.gameSound playMusic:@"Silence" volume:[NSNumber numberWithFloat:0.1] looping:[NSNumber numberWithInt:1] andPitch:nil];
}




#pragma mark -
#pragma mark Loaders and Unloaders

- (void)restartAnimating
{
    [farmSceneCon animate];
    [farmNightSceneCon animate];
}

- (void)loadRooster
{
    if (roosterView == nil)
        roosterView = [[ClockRooster alloc] initWithFrame:CGRectMake(0, 200, 200, 200)];
    [roosterView setupSelfFor:100];
    

    [baseVCon.view addSubview:roosterView];
}

- (void)unloadRooster
{
    if (roosterView == nil)
        return;
    [roosterView removeFromSuperview];
    [roosterView stopAnimating];
    [roosterView release];
    roosterView = nil;
}

- (void)loadClockFace {

	self->timeFaceCon = [[TimeFaceCon alloc] initWithNibName:@"ClockFace" bundle:nil];
	timeFaceCon.view.tag = 330033;
	timeFaceCon.view.center = baseVCon.view.center;
	[baseVCon.view addSubview:timeFaceCon.view];
    [self performSelector:@selector(incrementClock) withObject:nil afterDelay:1.0];
    [timeFaceCon setAlarm:[Alarm comingAlarm]];
    

}
- (void)unloadClockFace {

	[timeFaceCon.view removeFromSuperview];
	[timeFaceCon release];
	self->timeFaceCon = nil;
}


- (void)loadSnoozeView
{
    snoozeViewCon = [[SnoozeViewCon alloc] initWithNibName:@"SnoozeView" bundle:nil];
    [baseVCon.view addSubview:snoozeViewCon.view];
}

- (void)unloadSnoozeView
{
    if (snoozeViewCon == nil)
        return;
    [snoozeViewCon.view removeFromSuperview];
    [snoozeViewCon release];
    self->snoozeViewCon = nil;
}

- (TimeFaceCon *)clockFace
{
    return timeFaceCon;
}







- (void)loadFarmScene {

	self->farmSceneCon = [[FarmViewCon alloc] initWithNibName:@"FarmView" bundle:nil];
	
    loadedScene = FarmScene;
    [self updateSelectors];
	farmSceneCon.view.center = baseVCon.view.center;
	[baseVCon.view addSubview:farmSceneCon.view];
    //[farmSceneCon setup];
    [farmSceneCon animate];
    NSLog(@"-------------loaded Farm Scene");

}
- (void)unloadFarmScene {

	[farmSceneCon.view removeFromSuperview];
	[farmSceneCon release];
	self->farmSceneCon = nil;
    NSLog(@"---------------Unloaded Farm Scene");
}
- (FarmViewCon *)farmViewCon
{
    return farmSceneCon;
}


- (void)loadNightFarmScene 
{
	self->farmNightSceneCon = [[FarmNightViewCon alloc] initWithNibName:@"FarmNightView" bundle:nil];
	
    loadedScene = NightFarmScene;
    [self updateSelectors];
	farmNightSceneCon.view.center = baseVCon.view.center;
	[baseVCon.view addSubview:farmNightSceneCon.view];
    [farmNightSceneCon animate];
    NSLog(@"------------Loaded Night Farm Scene");
}
- (void)unloadNightFarmScene 
{
    
	[farmNightSceneCon.view removeFromSuperview];
    [farmNightSceneCon release];
	self->farmNightSceneCon = nil;
     NSLog(@"-------------Unloaded Night Farm Scene");
    
}
- (FarmNightViewCon *)farmNightSceneCon
{
    return farmNightSceneCon;
}

#pragma mark -
#pragma mark FlipView

- (void)showHelp
{
    [settingsRootViewCon showHelp];
}

- (void)flipView {
	
	SlickTimeAppDelegate *del= (SlickTimeAppDelegate *)APP_DELEGATE;
	
    //Setting -> Main View
	if ( settingsViewCon ) {
        
        [self unloadSettingsCon];
		[UIView beginAnimations:@"flipView" context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:del.window cache:YES];
		[UIView setAnimationDuration:0.8];
		[[UIApplication sharedApplication] setStatusBarHidden:YES];

        
        [self performSelector:(videoSceneToLoad)];
		[self loadClockFace];
        clockStage = SceneStage;
		[UIView commitAnimations];
	}
		
    //Main View -> Setting
	else {
		
        if (sceneState == AlarmRinging)
            [self unloadRooster];
        [self performSelector:videoSceneToUnload];
		[self unloadClockFace];
		[UIView beginAnimations:@"flipView" context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:del.window cache:YES];
		[UIView setAnimationDuration:0.8];
		[[UIApplication sharedApplication] setStatusBarHidden:NO];

		[self loadSettingsCon];

        clockStage = SettingStage;
	
        [UIView commitAnimations];
		
		
	}
    
	logAllNotifications(@"Reset All");
}


- (void)flipViewWithNightTransition
{
    SlickTimeAppDelegate *del= (SlickTimeAppDelegate *)APP_DELEGATE;
    
	
	if ( settingsViewCon ) {
		
		[UIView beginAnimations:@"flipViewWithNightTransition" context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:del.window cache:YES];
		[UIView setAnimationDuration:0.8];
		[[UIApplication sharedApplication] setStatusBarHidden:YES];
		//[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES ];
        
        [self unloadSettingsCon];
        [self loadFarmScene];
		[self loadClockFace];
        
        clockStage = SceneStage;
		[UIView commitAnimations];
        
        //[farmSceneCon performSelector:@selector(transitionToNight) withObject:nil afterDelay:1.0 ];
        [farmSceneCon performSelector:@selector(raiseSun) withObject:nil afterDelay:1.0];
	}
    
//	else {
//		
//		[UIView beginAnimations:@"flipViewWithNightTransition" context:nil];
//		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//		[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:del.window cache:YES];
//		[UIView setAnimationDuration:0.8];
//		
//		[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES ];
//        
//		[self loadSettingsCon];
//		[self unloadClockFace];
//      [self performSelector:videoTransitionUnload];
//		[self unloadWeatherViewCon];
//        
//		[UIView commitAnimations];
//		
//		
//	}
	
    logAllNotifications(@"Reset All");
}


#pragma mark - Selectors

- (void)updateSelectors
{
    videoSceneToLoad =      [self selectorForSceneLoad];
    videoSceneToUnload =    [self selectorForSceneUnload];
}


- (void)callTransitionUnloadSelectors
{
    [self performSelector:videoTransitionUnload];
    [self performSelector:videoSceneToLoad];
}



- (SEL)selectorForSceneLoad
{
    SEL retVal = nil;
    if (loadedScene == FarmScene)
        retVal = @selector(loadFarmScene);
    else if (loadedScene == NightFarmScene)
        retVal = @selector(loadNightFarmScene);
    return  retVal;
}

- (SEL)selectorForSceneUnload
{
    SEL retVal = nil;
    if (loadedScene == FarmScene)
        retVal = @selector(unloadFarmScene);
    else if (loadedScene == NightFarmScene)
        retVal = @selector(unloadNightFarmScene);
    return  retVal;
}




#pragma mark - Settings Loading


- (void)loadSettingsCon {

	self->settingsRootViewCon = [[SettingsRootViewCon alloc] init];
	self->settingsViewCon = [[SettingsViewCon alloc] initWithRootViewController:settingsRootViewCon];
	[settingsRootViewCon loadArrayData:NO];

    
    
	UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ReverseDayScene.png"]];
	backgroundImage.alpha = 0.5;
		
	[settingsViewCon.view insertSubview:backgroundImage atIndex:0];
    settingsViewCon.view.backgroundColor = [UIColor whiteColor];
	[backgroundImage release];
        
    [settingsRootViewCon setTitle:@"Alarms"];

	settingsViewCon.view.center = baseVCon.view.center;
	[baseVCon.view addSubview:settingsViewCon.view];
    [settingsViewCon setDelegate:settingsRootViewCon];

}
- (void)unloadSettingsCon {

	[settingsViewCon.view removeFromSuperview];
	[settingsViewCon release];
	self->settingsViewCon = nil;
}






#pragma mark -
#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
}



#pragma mark - WeatherSetting
- (void)presentWeatherSetting
{
    weatherSettingsCon = [[WeatherSettingsCon alloc] initWithNibName:@"WeatherSettingsCon" bundle:nil];
    [baseVCon.view addSubview:weatherSettingsCon.view];
    
    [timeFaceCon toggleFramesPaused];
    
    weatherSettingsCon.view.frame = CGRectMake(0, 20, 320, 460);
    
    weatherSettingsCon.view.transform = CGAffineTransformScale(
                                                               CGAffineTransformIdentity, 0.1, 0.1);    
    
    [UIView beginAnimations:@"showSettings" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    weatherSettingsCon.view.transform = CGAffineTransformScale(
                                                               CGAffineTransformMakeTranslation(0, 0), 1, 1);
    
    [UIView commitAnimations];
    
}

- (void)finishWeatherSetting
{
    
    [UIView beginAnimations:@"showSettings" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    weatherSettingsCon.view.transform = CGAffineTransformScale(
                                                               CGAffineTransformMakeTranslation(weatherSettingsCon.view.center.x, weatherSettingsCon.view.center.y), 0, 0); 
    
    [UIView commitAnimations];
    
    [weatherSettingsCon.view removeFromSuperview];
    [weatherSettingsCon release];
    self->weatherSettingsCon = nil;
    
    [timeFaceCon updateClockFace];
    [timeFaceCon toggleFramesPaused];
    [timeFaceCon updateWeatherSetting];
    [WeatherSetting saveWeatherSetting];
    [WeatherControl requestWeatherForNewPlacesWithDelegate:self];
    
}


- (void)presentInfoScreen
{
    infoScreenCon = [[InfoScreenCon alloc] initWithNibName:@"InfoScreen" bundle:nil];
    [baseVCon.view addSubview:infoScreenCon.view];
    
    [timeFaceCon toggleFramesPaused];
    
    infoScreenCon.view.frame = CGRectMake(0, 20, 320, 460);
    
    infoScreenCon.view.transform = CGAffineTransformScale(
                                                               CGAffineTransformIdentity, 0.1, 0.1);    
    
    [UIView beginAnimations:@"showInfo" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    infoScreenCon.view.transform = CGAffineTransformScale(
                                                               CGAffineTransformMakeTranslation(0, 0), 1, 1);
    
    [UIView commitAnimations];
}

- (void)dismissInfoScreen
{
    
    [UIView beginAnimations:@"hideInfo" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    infoScreenCon.view.transform = CGAffineTransformScale(
                                                               CGAffineTransformMakeTranslation(infoScreenCon.view.center.x, infoScreenCon.view.center.y), 0, 0); 
    
    [UIView commitAnimations];
    
    [infoScreenCon.view removeFromSuperview];
    [infoScreenCon release];
    self->infoScreenCon = nil;
    
    [timeFaceCon toggleFramesPaused];
    
}

#pragma mark - WeaterControlDelegate

- (void)weatherDataUpdatedForPlace:(Place *)place
{
    [timeFaceCon updateWeatherForPlace:place];
}



#pragma mark -
#pragma mark Memory

- (void)dealloc {
	
	if ( baseVCon ) {
		[baseVCon release];
		self->baseVCon = nil;
	}
	
	if ( farmSceneCon ) {
		[farmSceneCon release];
		self->farmSceneCon = nil;
	}
	
	if ( timeFaceCon ) {
		[timeFaceCon release];
		self->timeFaceCon = nil;
	}
	
	if ( settingsViewCon ) {
		[settingsViewCon release];
		self->settingsViewCon = nil;
	}
	
    if (roosterView)
    {
        [roosterView removeFromSuperview];
        [roosterView stopAnimating];
        [roosterView release];
        roosterView = nil;
    }
    if (audioPlayer)
    {
        [audioPlayer stop];
        [audioPlayer release];
    }
    
	[Alarm unloadAlarms];
	
	[super dealloc];
}


@end
