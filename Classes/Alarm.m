//
//  Alarm.m
//  SlickTime
//
//  Created by Miles Alden on 5/4/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "Alarm.h"
#import "CentralControl.h"
#import <Foundation/NSCoder.h>
#import "Common.h"
#define kAlarmList				@"Alarms"
#define kNextTag				@"NextTag"

#define kAlarmTag				@"Tag"
#define kAlarmOn				@"On"
#define kRepeatSettings			@"Repeat"
#define kSnoozeSettings			@"Snooze"
#define kPlayFromLibrary        @"PlayFromLibrary"
#define kRoosterCrowOn          @"RoosterCrow"
#define kSleepModeSettings      @"SleepMode"
#define kAutoLockSettings       @"AutoLock"
#define kAlarmTime				@"Time"
#define kLabel					@"Label"
#define kDetail					@"Detail"
#define kMusicList              @"MusicList"

@implementation Alarm

@synthesize alarmTime;
@synthesize repeatSettings, snoozeSettings, alarmSound;
@synthesize sleepModeSettings, autoLockSettings;
@synthesize alarmOn, roosterCrowOn;
@synthesize theLabel;
@synthesize musicList;
@synthesize playFromLibrary;
int currentAlarmBeingEditedTag = -1;

int globalNextTag = 0;
NSMutableDictionary *globalListOfAlarms = nil;

#pragma mark -
#pragma mark alarmList

+ (NSString *)alarmListFileName
{
	return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/AlarmList.dat"];
}

+ (NSMutableDictionary *)listOfAlarms
{
	// if no list of Alarms exists, create an empty one.
	if (!globalListOfAlarms) {
		globalListOfAlarms = [[NSMutableDictionary alloc] init];
		globalNextTag = 0;
		[[NSUserDefaults standardUserDefaults] setInteger: globalNextTag forKey: kNextTag];
	}
	return globalListOfAlarms;
}

+ (void)clearExpiredAlarms
{
    [self cleanUnusedAlarm];
    NSDate *now = [NSDate date];
    NSMutableDictionary *dict = [Alarm listOfAlarms];
    NSArray *list = [Alarm allAlarms];
    
    for (Alarm *alarm in list)
    {
        if (alarm.repeatSettings == RepeatOptionOff && [alarm.alarmTime compare:now] == NSOrderedAscending)
            alarm.alarmOn = NO;
    }
	[NSKeyedArchiver archiveRootObject: dict toFile: [Alarm alarmListFileName]];
	[[NSUserDefaults standardUserDefaults] setInteger: globalNextTag forKey: kNextTag];
}

+ (void)saveAlarms 
{
    [self cleanUnusedAlarm];
	// if there is no listOfAlarms, then create one an empty dictionary
	NSMutableDictionary *list = [Alarm listOfAlarms];
	[NSKeyedArchiver archiveRootObject: list toFile: [Alarm alarmListFileName]];
	[[NSUserDefaults standardUserDefaults] setInteger: globalNextTag forKey: kNextTag];
}

+ (void)loadAlarms 
{
	if (globalListOfAlarms) {
		[globalListOfAlarms release];
		globalListOfAlarms = nil;
	}
	
	globalListOfAlarms = [[NSKeyedUnarchiver unarchiveObjectWithFile: [Alarm alarmListFileName]] retain];
	
	globalNextTag = [[NSUserDefaults standardUserDefaults] integerForKey: kNextTag];
}

+ (void)unloadAlarms
{
	[Alarm saveAlarms];
	[globalListOfAlarms release];
	globalListOfAlarms = nil;
}

+ (Alarm *)alarmWithTag: (int)t
{
	NSMutableDictionary *list = [Alarm listOfAlarms];
	return (Alarm *)[list objectForKey: [NSString stringWithFormat:@"%d", t]];
}

+ (int) numOfAlarms
{
	return [[Alarm listOfAlarms] count];
}

+ (NSArray *) allAlarms
{
	return [[Alarm listOfAlarms] allValues];
}

#pragma mark -
#pragma mark new and delete					 

+ (Alarm *)newAlarm
{
    [self cleanUnusedAlarm];
    Alarm *a = [[[Alarm alloc] init] autorelease];

	// We want to tag each alarm with a unique tag so we can use the tag to relate local notifications
	// to existing alarms and vice-versa.   So will tag each alarm that is created with a number that
	// we increment each time.  (That number gets archived and unarchived with the alarm list, so its
	// value will persist as long as there are alarms.  It's a 32 bit number, so we won't run out 
	// within the lifetime of any particular iPhone.)
	a->tag = globalNextTag;
    a->isNew = YES;
	NSLog(@"Creating new alarm for number : %d", globalNextTag);
    globalNextTag++;
	
	NSMutableDictionary *list = [Alarm listOfAlarms];
	[list setObject: a forKey: [NSString stringWithFormat:@"%d", a->tag]];
	
	return a;
}
					
+ (void)cleanUnusedAlarm
{
    Alarm *oldAlarm = [self currentAlarmBeingEdited];
    if (oldAlarm && oldAlarm->isNew)
    {
        int tag = oldAlarm->tag;
        NSMutableDictionary *list = [Alarm listOfAlarms];
        [list removeObjectForKey: [NSString stringWithFormat:@"%d", tag]];
        globalNextTag--;
        currentAlarmBeingEditedTag = -1;
    }
    currentAlarmBeingEditedTag = -1;
}

+ (void)deleteAlarm: (Alarm *)a
{

	//[a unschedule];
    
	int tag = a->tag;
	NSMutableDictionary *list = [Alarm listOfAlarms];
	[list removeObjectForKey: [NSString stringWithFormat:@"%d", tag]];
    [Alarm scheduleAll];
}

+ (void)scheduleAll
{
    NSArray *oldNotifications         = [[UIApplication sharedApplication] scheduledLocalNotifications];
	
	if ([oldNotifications count] > 0) {
		[[UIApplication sharedApplication] cancelAllLocalNotifications];
	}
    
    NSArray *alarmList = [Alarm allAlarms];
    for (int i = 0; i < alarmList.count; i++)
    {
        Alarm *alarm = [alarmList objectAtIndex:i];
        [alarm schedule:YES];
    }
}

+ (Alarm *)comingAlarm
{
    NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDateComponents* now = [calendar components:(NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekdayCalendarUnit) fromDate:[NSDate date]];
	NSInteger hour = [now hour];
	NSInteger minute = [now minute];
	NSInteger week = [now weekday]-1;
	
	Alarm *nextAlarm = nil;
    NSArray *alarmList = [Alarm allAlarms];
	int i;
	for (i = week; i < week + 7; i++)
	{
		int bestHour = 24;
		int bestMin = 60;
		for (Alarm *alarm in alarmList) {
            if (!alarm.alarmOn)
                continue;
            
			int compairWeekday = ((i + 6) % 7);
            if (compairWeekday == 0)
                compairWeekday = 7;
            NSLog(@"%d", alarm.repeatSettings);
            if (isIncludingWeekday(alarm.repeatSettings, compairWeekday) || alarm.repeatSettings == RepeatOptionOff)
			{
                NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease]; 
                unsigned unitFlags = NSYearCalendarUnit | NSWeekCalendarUnit |  NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
                NSDateComponents *alarmComponents = [gregorian components: unitFlags fromDate: alarm.alarmTime];
				int compHour = alarmComponents.hour;
				int compMin = alarmComponents.minute;
                
                
                
                if (alarm.repeatSettings == RepeatOptionOff)
                {
                    NSTimeInterval interval = [alarm.alarmTime timeIntervalSinceNow];
                    if (interval > 3600 * 24 || interval < 0)
                        continue;
                }
				
				if (((compHour > hour || (compHour = hour && compMin > minute)) || i > week)  && bestHour >= compHour) {
					if (bestHour == compHour && bestMin <= compMin)
						continue;
					bestHour = compHour;
					bestMin = compMin;
					nextAlarm = alarm;
				}
			}
		}
		if (nextAlarm != nil)
			break;
	}
    return nextAlarm;
}
#pragma mark -
#pragma mark Coding


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt: tag forKey: kAlarmTag];
    [aCoder encodeBool: alarmOn forKey: kAlarmOn];
    
    [aCoder encodeInt: repeatSettings forKey: kRepeatSettings];
    [aCoder encodeInt: snoozeSettings forKey: kSnoozeSettings];
    
    [aCoder encodeBool: roosterCrowOn forKey: kRoosterCrowOn];
    [aCoder encodeBool: playFromLibrary forKey: kPlayFromLibrary];
    
    [aCoder encodeInt: sleepModeSettings forKey: kSleepModeSettings];
    [aCoder encodeInt: autoLockSettings forKey: kAutoLockSettings];
    
    [aCoder encodeObject: alarmTime forKey: kAlarmTime];
    [aCoder encodeObject: theLabel forKey: kLabel];
    //[aCoder encodeObject: theDetailLabel forKey: kDetail];
 
    [aCoder encodeObject:musicList forKey:kMusicList];
    

}
					 
- (id)initWithCoder:(NSCoder *)aDecoder
{

    if( (self = [self init]) ) {
        
        self->tag = [aDecoder decodeIntForKey: kAlarmTag];
        self->alarmOn = [aDecoder decodeBoolForKey: kAlarmOn];
        
        self->repeatSettings = [aDecoder decodeIntForKey: kRepeatSettings]; 
        self->snoozeSettings = [aDecoder decodeIntForKey: kSnoozeSettings];
        
        self->roosterCrowOn = [aDecoder decodeBoolForKey: kRoosterCrowOn];
        self->sleepModeSettings = [aDecoder decodeIntForKey: kSleepModeSettings];
        self->autoLockSettings = [aDecoder decodeIntForKey: kAutoLockSettings];
        self->playFromLibrary = [aDecoder decodeBoolForKey: kPlayFromLibrary];
        
        self->alarmTime = [[aDecoder decodeObjectForKey: kAlarmTime] retain];
        self->theLabel = [[aDecoder decodeObjectForKey: kLabel] retain];
        if (self->theLabel == nil)
            self->theLabel = @"";
        self.musicList = [NSMutableArray arrayWithArray:[aDecoder decodeObjectForKey:kMusicList]];
        
    }
    
    return self;
    
}

#pragma mark - Init
- (id)init
{
    self = [super init];
    if (self)
    {
        tag = 0;
        alarmOn = YES;
        repeatSettings = RepeatOptionOff;
        snoozeSettings = SnoozeOptionOff;
        isNew = NO;
        [self assignTheLabel:theLabel];
        roosterCrowOn = YES;
        self.sleepModeSettings = SleepModeOptionOneMinute;
        self.autoLockSettings = AutoLockOptionNever;
        self.musicList = [NSMutableArray array];	
    }
    return self;
}

#pragma mark -
#pragma mark defaults


- (NSString *)description {

	NSArray *arrayOfStrings = [self allValuesAsStringSet];
	return [arrayOfStrings description];
}


- (void)setDefaultValues {

	alarmOn = YES;
	//roosterOn = YES;
	
	repeatSettings = RepeatOptionOff; 
	snoozeSettings = SnoozeOptionOff;
	
	alarmTime = nil;
	theLabel = @"Good Morning!";
	//theDetailLabel = nil;
	
	
}


#pragma mark -
#pragma mark scheduling

- (BOOL)schedule: (BOOL)firstTime
{
	
    if (alarmOn == NO)
        return YES;
    for (int weekday = 0; weekday < 7; weekday++)
    {
        
        int compairWeekday = ((weekday + 6) % 7);
        if (compairWeekday == 0)
            compairWeekday = 7;
        
        if (isIncludingWeekday(repeatSettings, compairWeekday) || repeatSettings == RepeatOptionOff)
        {
            
            
            //Registering Notification
            NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease]; 
            
            NSString *strTime = [NSDateFormatter localizedStringFromDate: alarmTime dateStyle: kCFDateFormatterShortStyle timeStyle: kCFDateFormatterShortStyle];
            NSLog(@"Rescheduling alarm, current alarm: %@", strTime);
            
            unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
            NSDateComponents *alarmComponents = [gregorian components: unitFlags fromDate: alarmTime];
            
            NSLog(@"Year: %d", [alarmComponents year]);
            NSLog(@"Week: %d", [alarmComponents week]);
            NSLog(@"Weekday: %d", [alarmComponents weekday]);
            NSLog(@"Hour: %d", [alarmComponents hour]);
            NSLog(@"Minutes: %d", [alarmComponents minute]);
            
            NSDate *now = [NSDate date];
            NSDateComponents *nowComponents = [gregorian components: unitFlags fromDate: alarmTime];
            
            NSDateComponents *newAlarmComponents = [[[NSDateComponents alloc] init] autorelease];
            [newAlarmComponents setYear:nowComponents.year];
            [newAlarmComponents setMonth:nowComponents.month];
            //[newAlarmComponents setWeekday:((weekday % 7) + 1)];
            [newAlarmComponents setDay:nowComponents.day + ((weekday - nowComponents.weekday + 7) % 7)]; 
            [newAlarmComponents setHour: [alarmComponents hour]];
            [newAlarmComponents setMinute: [alarmComponents minute]];
            NSDateComponents *repeatInterval = [[[NSDateComponents alloc] init] autorelease];
            [repeatInterval setWeek: -1];
                            
            
            NSDate *newAlarm = [gregorian dateFromComponents: newAlarmComponents];
            newAlarm = [gregorian dateByAddingComponents: repeatInterval toDate: newAlarm options:0];
            
            [repeatInterval setWeek:1];
            // make sure alarm is in the future:
            while ([newAlarm compare: now] == NSOrderedAscending) {
                newAlarm = [gregorian dateByAddingComponents: repeatInterval toDate: newAlarm options:0];
            }
            
            if (repeatSettings == RepeatOptionOff)
            {
                NSTimeInterval interval = [newAlarm timeIntervalSinceNow];
                if (interval > 3600 * 24 || interval < 0)
                    continue;
            }
            
            // create a new one scheduled for the future time/date we just calculated:
            if (self->alarmTime)
                [self->alarmTime release];
            self->alarmTime = [newAlarm retain];
            
            UILocalNotification *wakeUp = [[UILocalNotification alloc] init];
            wakeUp.fireDate = newAlarm;
            wakeUp.timeZone = [NSTimeZone localTimeZone];
            wakeUp.repeatInterval = NSWeekCalendarUnit;
            wakeUp.alertAction = @"Wake Up";
            wakeUp.alertBody = @"Open Alarm Clock to turn off the alarm.";
            wakeUp.hasAction = YES;
            
            NSString *soundName = soundFileNameAtIndex(alarmSound);
            wakeUp.soundName = @"RoosterCrow.aiff";
            wakeUp.userInfo = [NSDictionary dictionaryWithObjectsAndKeys: @"wakeup", kUserInfoNotificationType, 
                               [NSNumber numberWithInt: tag], kUserInfoAlarmTag, 
                               theLabel, kUserInfoAlarmMessage,
                               [NSNumber numberWithInt:snoozeSettings], kUserInfoAlarmSnooze,
                               soundName, kUserInfoAlarmSound, nil];
            
            [[UIApplication sharedApplication] scheduleLocalNotification: wakeUp];
            
            // Per the documentatoin: "Because the operating system copies notification, you may release it once you have scheduled it."
            [wakeUp release];
            
            
            NSDateComponents *logAlarmComps = [gregorian components: unitFlags fromDate: alarmTime];
            NSLog(@"Alarm Dates: %d/%d/%d - %d:%d", [logAlarmComps year], [logAlarmComps month], [logAlarmComps day], [logAlarmComps hour], [logAlarmComps minute] );
            
        }
    }

    
    return YES;
    
			
}

- (BOOL) reschedule
{
	return [self schedule: NO];
}

- (void) unschedule
{
	UILocalNotification *notification = [self getScheduledNotification];
	if (notification) {
		[[UIApplication sharedApplication] cancelLocalNotification: notification];
	}
}
					 
- (UILocalNotification *)getScheduledNotification
{
	NSArray *schedule = [UIApplication sharedApplication].scheduledLocalNotifications;
	
	int count = [schedule count];
    //Getting Schedules;
	for (int idx = 0; idx < count; idx++) {
		
		id obj = [schedule objectAtIndex: idx];
		if (obj && [obj isKindOfClass:[UILocalNotification class]]) {
            
			  id value = [((UILocalNotification *)obj).userInfo objectForKey: kUserInfoAlarmTag];

			  if (value && [value isKindOfClass: [NSNumber class]]) {
				  if ([(NSNumber *)value intValue] == self->tag) {
					  return (UILocalNotification *)obj;
				  }
			  }
		}
		
	}
	return nil;
}

 + (Alarm *)alarmForNotification: (UILocalNotification *)notification
{
	id value = [notification.userInfo objectForKey: kUserInfoAlarmTag];
	if (value && [value isKindOfClass: [NSNumber class]]) {
		int n = [(NSNumber *)value intValue];
		return [Alarm alarmWithTag: n];
	}
	return nil;
}

#pragma mark -
#pragma mark editing




- (void) startEditing
{
	if (currentAlarmBeingEditedTag != -1)
		NSLog(@"Oops! You are still editing something else!");
	
	// Don't allow this alarm to go off in the middle of editing it.
	// We could have a race condition if the alarm went off and we rescheduled it
	// at the same time we were changing the time.   So, simply unschedule this
	// until we are don editing.
	currentAlarmBeingEditedTag = self->tag;
	
}

+ (Alarm *) currentAlarmBeingEdited
{
	if (currentAlarmBeingEditedTag == -1)
		return nil;
	return [Alarm alarmWithTag: currentAlarmBeingEditedTag];
}

- (void) endEditing
{
	if (currentAlarmBeingEditedTag != self->tag)
		NSLog(@"Oops! You aren't editing what you think you are editing!");
	
	// Done editing, save it to disk and then schedule it for the first time if it's on.
    isNew = NO;
	currentAlarmBeingEditedTag = -1;
    [Alarm saveAlarms];
    [Alarm scheduleAll];
    /*
	if (self->alarmOn)
		[self schedule: YES];
	*/
	
	
}

- (void)abortEditing
{
	if (currentAlarmBeingEditedTag != self->tag)
		NSLog(@"Oops! You aren't editing what you think you are editing!");
	
	// Cancel the edit, don't save anything to disk or schedule anything;
	currentAlarmBeingEditedTag = -1;
}

		
		


#pragma mark -
#pragma mark AlarmTime


- (void)setAlarmTime:(NSDate *)time {
	
	//NSString *strTime = [NSDateFormatter localizedStringFromDate: time dateStyle: kCFDateFormatterShortStyle timeStyle: kCFDateFormatterShortStyle];
	//NSLog(@"Time picked: %@", strTime);
	
	if (self->alarmTime)
		[self->alarmTime release];
	
	self->alarmTime = [time retain];
}


- (NSString *)alarmTimeString {

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    
    NSString *retVal = [formatter stringFromDate:alarmTime];
	[formatter release];
    
	return retVal;
}










- (NSArray *)allValuesAsStringSet {

	NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
	
	//Alarm Time
	if ( alarmTime != nil )
		[array addObject:[self alarmTimeString]];
	else [array addObject:@"None"];
	
	//Repeat Settings
    NSString *repeatText = @"";
    NSArray *weekdayStringList = [NSArray arrayWithObjects:WEEKDAY_STRING_SHORT_LIST, nil];
    BOOL bFirst = YES;
    if (repeatSettings == 0)
        repeatText = @"Off";
    else if (repeatSettings == 1111111)
        repeatText = @"Every day";
    else
    {
        for (int i = 0; i < 7; i++)
        {
            if (isIncludingWeekday(repeatSettings, i + 1))
            {
                if (bFirst)
                {
                    repeatText = [weekdayStringList objectAtIndex:i];
                    bFirst = NO;
                }
                else
                {
                    repeatText = [repeatText stringByAppendingFormat:@", %@", [weekdayStringList objectAtIndex:i]];
                }
            }
        }
    }
    if (repeatText.length == 0)
        repeatText = @"Off";
    [array addObject: repeatText];
    
	
	switch (snoozeSettings) {
		case SnoozeOptionOff:
			[array addObject:@"Off"];
			break;
		case SnoozeOptionOneMinute:
			[array addObject:@"1 Minute"];
			break;
		case SnoozeOptionTenMinutes:
			[array addObject:@"10 Minutes"];
			break;
		case SnoozeOptionThreeMinutes:
			[array addObject:@"3 Minutes"];
			break;
		case SnoozeOptionThirteenMinutes:
			[array addObject:@"30 Minutes"];
			break;
			
		default:
			[array addObject:@"Off"];
			break;
	}
	
	
	//Alarm Music Choice
    /*
	if ( alarmMusic != nil )
		[array addObject:[self stringValueFor:MusicItemAlarmMusic]];
	else [array addObject:@"None"];
	*/
    
    NSString *song;
    if (playFromLibrary)
        song = @"Music From Library";
    else
        song = soundFileNameAtIndex(alarmSound);
    [array addObject:song];
    
    
    //Rooster Crow
    
    if ( roosterCrowOn == YES )
        [array addObject:@"on"];
    else
        [array addObject:@"off"];
    
	
	//The label
	if ( theLabel != nil )
		[array addObject:theLabel];
	else [array addObject:@"None"];
    
	return (NSArray *)array;
}



- (void)assignTheLabel: (NSString *)string 
{

	if ( string != nil ) {
		if (theLabel)
			[theLabel release];
		theLabel = [string retain];
	}
    else
        theLabel = @"";
			
}
	

//- (void)assignTheDetailLabel: (NSString *)string {}

- (void) dealloc
{
	if (alarmTime)
		[alarmTime release];
	if (theLabel)
		[theLabel release];
	if (musicList)
        [musicList release];
    
	
	[super dealloc];
}

@end
