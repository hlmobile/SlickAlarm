//
//  CentralControl.h
//  SlickTime
//
//  Created by Miles Alden on 5/2/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "Common.h"
#import "WeatherControl.h"

@class FarmViewCon, TimeFaceCon, BaseViewCon, FarmNightViewCon;
@class SettingsViewCon, SettingsRootViewCon, Alarm, WeatherSettingsCon;
@class AVCaptureSession, WeatherViewCon, InfoScreenCon;

@class ClockRooster, SnoozeViewCon;
// NOTE (AppFireState): On init, AppFireState was being set to "NotPlaying".  On 
//   first call to loadTransitionToDayMovieCon the state was being set to "Playing".
//   But there is no logic to reset it to "NotPlaying", so the code always thought
//   it was "Playing" which meant that no alarms would ever be allowed to fire
//   after that.   Clearly as written this code didn't work.  The apparent intention
//   was to prevent to alarms from firing at the same time -- but that would mean
//   the second alarm never actually fires, which would be incorrect behavior.  If
//   there is actually something wrong with firing a new alarm while a previous one
//   is still firing, the right thing to do would be to add code to kill the earlier
//   one and fire the later one. 
//   Until a need for this is actuall shown I'm commenting it out.
// 
//typedef enum {
//    AppFireStatePlaying = 0,
//    AppFireStateNotPlaying = 1,
//} AppFireState;


@interface CentralControl : NSObject <UIAlertViewDelegate, WeatherControlDelegate> {
	

    ClockStage clockStage;
    LoadedScene loadedScene;
    SceneState sceneState;
    // [See: NOTE (AppFireState)]:  int appFireState;
    
    SEL videoTransitionToPlay, videoSceneToLoad;
    SEL videoTransitionUnload, videoSceneToUnload;
    SEL videoAlarmFireToLoad, videoAlarmFireToUnload;
    
    
    MPMusicPlayerController *myPlayer;
    
    NSTimeInterval elapsedTime;
    
    AVCaptureSession *torchSession;
    
    NSDate *oldDate;
    NSDateFormatter *formatter;
	NSMutableString *minuteCheck;
    NSTimer *weatherTimer, *movieTimer;
    
    
    
	BaseViewCon *baseVCon;
	FarmViewCon *farmSceneCon;
    FarmNightViewCon *farmNightSceneCon;
    
	TimeFaceCon *timeFaceCon;
    SnoozeViewCon *snoozeViewCon;
    SettingsViewCon *settingsViewCon;
	SettingsRootViewCon *settingsRootViewCon;

    WeatherSettingsCon *weatherSettingsCon;
    InfoScreenCon *infoScreenCon;
	
    ClockRooster *roosterView;
}

@property (retain) BaseViewCon *baseVCon;
@property (readonly) int alarmBeingEdited;
@property (readonly) CFTimeInterval elapsedTime;
@property (assign) ClockStage clockStage;
@property (assign) SceneState sceneState;
@property (assign) LoadedScene loadedScene;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) MPMusicPlayerController *musicPlayer;

- (void)playBackgroundSilence;
- (void)resetFrameTimer: (id)target repeats: (BOOL)repeatVal;
- (void)callTransitionUnloadSelectors;


- (void)restartAnimating;
- (void)loadRooster;
- (void)unloadRooster;
- (void)loadClockFace;
- (void)unloadClockFace;
- (void)loadFarmScene;
- (void)unloadFarmScene;
- (void)loadSettingsCon;
- (void)unloadSettingsCon;
- (void)loadSnoozeView;
- (void)unloadSnoozeView;

- (void)setup;

- (void)flipView;
- (void)flipViewWithNightTransition;


- (void)checkBatteryState;
- (void)setupFlashlightSession;
- (void)incrementClock;
- (void)resetOldDate;
- (int)runMinuteCheckOn: (int)which;

- (void)playSound:(NSString *)fileName;
- (void)stopSound;

- (void)fireAlarm:(Alarm *)alarm;
- (void)snoozeAlarm;
- (void)stopFiringAlarm;
- (void)handleAlarmNotification: (UILocalNotification *)notification;


- (FarmViewCon *)farmViewCon;
- (TimeFaceCon *)clockFace;

- (void)showHelp;


- (SEL)selectorForSceneLoad;
- (SEL)selectorForSceneUnload;

- (void)updateLocalPlace;
- (void)setTheme: (Theme)newTheme;
- (void)updateSelectors;
- (void)loadNightFarmScene;
- (void)unloadNightFarmScene;
- (FarmViewCon *)farmNightSceneCon;

- (void)presentWeatherSetting;
- (void)finishWeatherSetting;
- (void)presentInfoScreen;
- (void)dismissInfoScreen;




@end
