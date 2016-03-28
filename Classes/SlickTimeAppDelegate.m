//
//  SlickTimeAppDelegate.m
//  SlickTime
//
//  Created by Miles Alden on 5/2/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "SleepControl.h"
#import "SlickTimeAppDelegate.h"
#import "Common.h"
#import "CentralControl.h"
#import "BaseViewCon.h"
#import "GameSound.h"
#import "Alarm.h"
#import "Place.h"
#import "WeatherSetting.h"

@implementation SlickTimeAppDelegate

@synthesize window, musicOn, sfxOn;
@synthesize centralCon, gameSound, locationManager;
@synthesize client;
@synthesize notifUserInfo;

#pragma mark - Location

- (void)requestUserLocation {
    
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	locationManager.delegate = self;
	locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
	locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 100 m
	[locationManager startUpdatingLocation];	

}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
	[manager stopUpdatingLocation];
	double latitude = newLocation.coordinate.latitude;
	double longitude = newLocation.coordinate.longitude;
    
	NSString *location = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
    

    
    self.client = [[[HttpClient alloc] init] autorelease];
    client.delegate = self;
	[client reqPlaceByLocation:location];
}

#pragma mark DDHttpClientDelegate
- (void)HttpClientSucceeded:(HttpClient*)sender
{	
    self.client = nil;
    
    Place *place = (Place *)sender.result;
    [WeatherSetting setLocalPlace:place];	
    [centralCon updateLocalPlace];
    [WeatherControl requestWeatherWithDelegate:centralCon forPlace:place];
}

- (void)HttpClientFailed:(HttpClient*)sender {
}

#pragma mark -
#pragma mark Application lifecycle

- (void)createAudioSession
{
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    UInt32 doSetProperty = 1;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(doSetProperty), &doSetProperty);
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
    musicOn = YES;
    sfxOn = YES;
    
    [WeatherSetting loadPlaces];
    
	self->gameSound = [[GameSound alloc] init];
	self->centralCon = [[CentralControl alloc] init];
	[centralCon setup];
		
    
	//[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error:nil];
    //[[AVAudioSession sharedInstance] setActive:YES error:nil];

    // Workaround for iOS5 bug. We need to register for remote notifications,
    // otherwise all notifications are disabled by default in the Notification Center
    // per: http://www.reigndesign.com/blog/ios5-notification-center-disables-local-notifications-by-default-on-your-existing-apps/a
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:     UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
	
    
    self->theClockTimer = [NSTimer timerWithTimeInterval:1 
                                                    target:centralCon 
                                                    selector:@selector(updateClock) 
                                                    userInfo:nil 
                                                    repeats:YES]; 
     
    [[NSRunLoop mainRunLoop] addTimer:theClockTimer forMode:NSDefaultRunLoopMode]; 
    
	[self.window addSubview:centralCon.baseVCon.view];	
    
    [self.window makeKeyAndVisible];
    autoLockEnabled = NO;
    [self requestUserLocation];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self createAudioSession];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	NSDictionary *info = notification.userInfo;
    self.notifUserInfo = info;
	id value = [info objectForKey:@"type"];
	if (value && [value isKindOfClass: [NSString class]]) {
		NSString *notifyType = (NSString *)value;
		if ([notifyType isEqualToString:@"wakeup"]) {
			
            
            // Compairing
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDateComponents* now = [calendar components:(NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit) fromDate:[NSDate date]];
            
            unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
            NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease]; 
            NSDateComponents *alarmComps = [gregorian components: unitFlags fromDate: notification.fireDate];
            if ([now weekday] != [alarmComps weekday])
                return;
            
            
            
			UIApplicationState state = [application applicationState];
			if (state == UIApplicationStateInactive) {
				
				// Application was in the background when notification
				// was delivered.
				
				// we already played the alarm sound and the user selected the wake-up button....
				
			} else {
				
				
                
				
				
				
			}
            
			[centralCon handleAlarmNotification: notification];
            [Alarm clearExpiredAlarms];

		}
	}
}


- (void)snoozeCurrentAlarm
{
    

    NSNumber *snoozeTime = [notifUserInfo objectForKey:@"snooze"];

    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents* now = [calendar components:(NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit) fromDate:[NSDate date]];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setHour:[now hour]];	
    [dateComps setMinute:[now minute]];
    [dateComps setYear:[now year]];
    [dateComps setMonth:[now month]];
    [dateComps setDay:[now day]];
    NSLog(@"Snoozing" );
    NSDateComponents *addDate = [[[NSDateComponents alloc] init] autorelease];
    int snoozeMode = [snoozeTime intValue];
    int snoozeMinutes = 0;
    switch (snoozeMode) {
        case SnoozeOptionOff:
            snoozeMinutes = 0;
            break;
        case SnoozeOptionOneMinute:
            snoozeMinutes = 1;
            break;
        case SnoozeOptionThreeMinutes:
            snoozeMinutes = 3;
            break;
        case SnoozeOptionTenMinutes:
            snoozeMinutes = 10;
            break;
        case SnoozeOptionThirteenMinutes:
            snoozeMinutes = 30;
            break;
            
            
        default:
            break;
    }
    [addDate setMinute:snoozeMinutes];
    
    NSDate *itemDate = [calendar dateByAddingComponents:addDate toDate:[calendar dateFromComponents:dateComps] options:0];
    [dateComps release];
    
    UILocalNotification *wakeUp = [[UILocalNotification alloc] init];
    wakeUp.fireDate = itemDate;
    wakeUp.timeZone = [NSTimeZone localTimeZone];
    wakeUp.alertAction = @"Wake Up";
    wakeUp.alertBody = @"Open Alarm Clock to turn off the alarm.";
    wakeUp.hasAction = YES;
    // wakeUp.alertLaunchImage = // choose an image to show when app is started by the alert...
    wakeUp.soundName = @"Rooster.wav";
    wakeUp.userInfo = [NSDictionary dictionaryWithObjectsAndKeys: @"wakeup", kUserInfoNotificationType, 
                       [notifUserInfo objectForKey:kUserInfoAlarmTag], kUserInfoAlarmTag, 
                       [notifUserInfo objectForKey:kUserInfoAlarmMessage], kUserInfoAlarmMessage,
                       [notifUserInfo objectForKey:kUserInfoAlarmSnooze], kUserInfoAlarmSnooze,
                       [notifUserInfo objectForKey:kUserInfoAlarmSound], kUserInfoAlarmSound, nil];
    
    [[UIApplication sharedApplication] scheduleLocalNotification: wakeUp];
    
    // Per the documentatoin: "Because the operating system copies notification, you may release it once you have scheduled it."
    [wakeUp release];
    
    
    NSDateComponents *logAlarmComps = [calendar components: (NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit| NSMinuteCalendarUnit) fromDate: itemDate];
    NSLog(@"Alarm Dates: %d/%d/%d - %d:%d", [logAlarmComps year], [logAlarmComps month], [logAlarmComps day], [logAlarmComps hour], [logAlarmComps minute] );
}

- (void)applicationWillResignActive:(UIApplication *)application 
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application 
{
	//if ( [centralCon syncAlarmsToDisk] ) printf("\nsynced to disk\n");
	[Alarm saveAlarms];
    [SleepControl stopSleepMusic];
}

- (void)applicationWillEnterForeground:(UIApplication *)application 
{
    [self.centralCon restartAnimating];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSleepDidFinish object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application 
{
    [Alarm clearExpiredAlarms];
    
}

- (void)applicationWillTerminate:(UIApplication *)application 
{
}





- (NSTimer *)theClockTimer
{
    return theClockTimer;
}

- (void)setTheClockTimer: (NSTimer *)newVal
{
    [theClockTimer invalidate];
    if ( [theClockTimer retainCount] > 0 ) [theClockTimer release];
    self->theClockTimer = nil;
    self->theClockTimer = newVal;
}




#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {}


- (void)dealloc {
    
	[window release];
	self->window = nil;
	
	[centralCon release];
	self->centralCon = nil;
	
    [locationManager release];
    [client release];
    [notifUserInfo release];
    [super dealloc];
}


@end
