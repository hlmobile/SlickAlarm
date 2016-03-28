//
//  SlickTimeAppDelegate.h
//  SlickTime
//
//  Created by Miles Alden on 5/2/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HttpClient.h"

@class CentralControl, GameSound;

@interface SlickTimeAppDelegate : NSObject <UIApplicationDelegate, DDHttpClientDelegate, CLLocationManagerDelegate> {
		
	UIWindow *window;
	CentralControl *centralCon;
	GameSound *gameSound;
	NSTimer *theClockTimer;
    HttpClient *client;
    CLLocationManager *locationManager;
    NSDictionary *notifUserInfo;
    
@public
	
	BOOL musicOn, sfxOn;


}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (readonly, retain) CentralControl *centralCon;
@property (readonly, retain) GameSound *gameSound;
@property (nonatomic, retain) HttpClient *client;
@property (nonatomic, retain) NSDictionary  *notifUserInfo;

@property BOOL musicOn, sfxOn;


- (void)setTheClockTimer: (NSTimer *)newVal;
- (void)snoozeCurrentAlarm;
- (NSTimer *)theClockTimer;
- (void)requestUserLocation;



@end

