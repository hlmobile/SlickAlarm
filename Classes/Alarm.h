//
//  Alarm.h
//  SlickTime
//
//  Created by Miles Alden on 5/4/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

#define kUserInfoNotificationType	@"type"
#define kUserInfoAlarmTag			@"tag"
#define kUserInfoAlarmSound         @"sound"
#define kUserInfoAlarmMessage       @"message"
#define kUserInfoAlarmSnooze        @"snooze"
@interface Alarm : NSObject <NSCoding> {
	
	int tag;
	BOOL alarmOn;  
	int repeatSettings;
	int snoozeSettings;
    BOOL roosterCrowOn;
    int sleepModeSettings;
    int autoLockSettings;
    int alarmSound;
    BOOL isNew;
    BOOL playFromLibrary;
    
	NSDate *alarmTime;
	NSString *theLabel; 
	//NSString *theDetailLabel;
	
	NSMutableArray *musicList;
	  
}

@property int repeatSettings, snoozeSettings, alarmSound;
@property int sleepModeSettings, autoLockSettings;
@property BOOL alarmOn, roosterCrowOn;
@property (readonly) NSString *theLabel;
//@property (readonly) NSString *theDetailLabel;
@property (readonly) NSDate *alarmTime;
@property BOOL playFromLibrary;
@property (retain, nonatomic) NSMutableArray *musicList;


+ (void)loadAlarms;
+ (void) saveAlarms;
+ (void)unloadAlarms;
+ (Alarm *) newAlarm;
+ (void)clearExpiredAlarms;
+ (void)cleanUnusedAlarm;
+ (void)deleteAlarm: (Alarm *)a;
+ (void)scheduleAll;
+ (Alarm *)alarmWithTag: (int)t;
+ (int) numOfAlarms;
+ (NSArray *) allAlarms;

+ (Alarm *)comingAlarm;
- (BOOL)schedule: (BOOL)firstTime;
- (void)unschedule;
- (BOOL)reschedule;
- (UILocalNotification *)getScheduledNotification;
+ (Alarm *)alarmForNotification: (UILocalNotification *)notification;

- (id)init;

- (void)startEditing;
+ (Alarm *)currentAlarmBeingEdited;
- (void)endEditing;
- (void)abortEditing;

- (void)setAlarmTime:(NSDate *)time;
- (NSString *)alarmTimeString;

- (void)setDefaultValues;


- (void)assignTheLabel: (NSString *)string;
//- (void)assignTheDetailLabel: (NSString *)string;
- (NSArray *)allValuesAsStringSet;






@end

