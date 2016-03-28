//
//  Common.h
//  SlickTime
//
//  Created by Jin Bei on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern BOOL autoLockEnabled;

typedef enum
{
    ThemeFarmScene = 0
} Theme;


typedef enum {
	TimeOfDayIsDawn = 0,
	TimeOfDayIsDaytime = 1,
	TimeOfDayIsDusk = 2,
	TimeOfDayIsNighttime = 3
} TimeOfDay;

typedef enum {
	RepeatOptionOff = 0,
	//RepeatOptionEveryday = 1,
	RepeatOptionMonday = 1,
	RepeatOptionTuesday = 2,
	RepeatOptionWednesday = 3,
	RepeatOptionThursday = 4,
	RepeatOptionFriday = 5,
	RepeatOptionSaturday = 6,
	RepeatOptionSunday = 7
}  RepeatOption;

typedef enum {
	SnoozeOptionOff = 0,
	SnoozeOptionOneMinute = 1,
	SnoozeOptionThreeMinutes = 2,
	SnoozeOptionTenMinutes = 3,
	SnoozeOptionThirteenMinutes = 4
} SnoozeOption;

typedef enum {
	SleepModeOptionOneMinute = 0,
    SleepModeOptionThreeMinutes = 1,
    SleepModeOptionTenMinutes = 2,
    SleepModeOptionThirtyMinutes = 3,
    SleepModeOptionOneHour = 4,
    SleepModeOptionUntilAlarm = 5
} SleepModeOption;

typedef enum {
    AutoLockOptionFiveMinutes = 0,
    AutoLockOptionTenMinutes = 1,
    AutoLockOptionFifteenMinutes = 2,
    AutoLockOptionThirtyMinutes = 3,
    AutoLockOptionOneHour = 4,
    AutoLockOptionNever = 5
} AutoLockOption;

typedef enum {
	MusicItemAlarmMusic = 0,
	MusicItemWhiteNoiseChoice = 1,
	MusicItemSleepNoiseChoice = 2
} MusicItem;

typedef enum {
	SetAlarmTableIndexTime = 0,
	SetAlarmTableIndexRepeat = 1,
	SetAlarmTableIndexSnooze = 2,
	SetAlarmTableIndexMusic = 3,
    SetAlarmTableIndexRoosterCrow = 4,
	SetAlarmTableIndexLabel =5,
	SetAlarmTableIndexSleepMode = 6,
	SetAlarmTableIndexAutolock = 7,
	SetAlarmTableIndexInfo = 8,
} SetAlarmTableIndex;

typedef enum {
	ArrayNamedControllers = 0,
	ArrayNamedSections = 1,
	ArrayNamedTableList_0 = 2,
	ArrayNamedTableList_1 = 3
} ArrayNamed;


typedef enum {
    LastVideoPlayedTransitionToNight = 0,
    LastVideoPlayedTransitionToDay= 1,
    LastVideoPlayedDaytimeScene = 2,
    LastVideoPlayedNightimeScene = 3
} LastVideoPlayed;

typedef enum {
    DateOldDate = 0,
    DateNewDate = 1
} Date;


typedef enum {
    SceneStage = 0,
    SettingStage = 1
} ClockStage;


typedef enum {
    
    FarmScene = 0,
    NightFarmScene = 1,
} LoadedScene;

typedef enum {
    TransitionToDayMovieScene = 0,
    TransitionToNightMovieScene = 1,
    AlarmRinging = 3,
    AlarmSnoozing = 4,
    Idle = 5
} SceneState;

typedef enum {
    WeatherTypeSunny = 0,
    WeatherTypeRainy = 1,
    WeatherTypePartlyCloudy = 2,
    WeatherTypeSnowy = 3,
    WeatherTypeThunderStorm = 4
}WeatherType;


#define kApplicationDidEnterBackground @"ApplicationDidEnterBackground"
#define kNotificationEnableAutoLock     @"EnableAutoLock"
#define kNotificationDisableAutoLock     @"DisableAutoLock"
#define kNotificationSleepDidFinish     @"SleepDidFinish"
#define TRANSITION_ANIMATION_DURATION 10.0
#define TRANSITION_SUN_RISE_DURATION 40.0

NSString *weatherSettingFileName();
NSString *sleepSettingFileName();

BOOL isIncludingWeekday(int value, int weekday);
int setWeekday(int value, int weekday, BOOL bInclude);
void logAllNotifications(NSString *message);
WeatherType weatherTypeFromCode(int code);
int celciusToFahrenheit(int temp);
NSString * soundFileNameAtIndex(int index);
float getBatteryLevel();
