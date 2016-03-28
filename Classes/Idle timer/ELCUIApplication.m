//
//  ELCUIApplication.m
//
//  Created by Brandon Trebitowski on 9/19/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCUIApplication.h"
#import "Common.h"
#import "SleepSetting.h"
@implementation ELCUIApplication

- (void)sendEvent:(UIEvent *)event {
	[super sendEvent:event];
	
	// Fire up the timer upon first event

    [self resetIdleTimer];

	return;
	// Check to see if there was a touch event
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0) {
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        if (phase == UITouchPhaseBegan) {
            [self resetIdleTimer];         
		}
    }
}

- (void)resetIdleTimer 
{
    if (_idleTimer) {
        [_idleTimer invalidate];
        [_idleTimer release];
        _idleTimer = nil;
    }
	int sleepMode = [SleepSetting sharedSleepSetting].autoLockMode;
    int minutes = 0;
    switch (sleepMode) {
        case AutoLockOptionFiveMinutes:
            minutes = 5;
            break;
        case AutoLockOptionTenMinutes:
            minutes = 10;
            break;
        case AutoLockOptionFifteenMinutes:
            minutes = 15;
            break;
        case AutoLockOptionThirtyMinutes:
            minutes = 30;
            break;
        case AutoLockOptionOneHour:
            minutes = 60;
            break;
        case AutoLockOptionNever:
            minutes = 0;
            break;
            
        default:
            break;
    }
    
    // Schedule a timer to fire in kApplicationTimeoutInMinutes * 60
	int timeout = minutes * 60;
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    float batteryLevel = getBatteryLevel();
    
    if (0 <= batteryLevel && batteryLevel <= 0.25) {
        
        [self idleTimerExceeded];
    }
    else {
            
        if (timeout > 0 /*&& [SleepSetting sharedSleepSetting].autoLockEnabled */)
        {
            _idleTimer = [[NSTimer scheduledTimerWithTimeInterval:timeout 
                                                  target:self 
                                                selector:@selector(idleTimerExceeded) 
                                                userInfo:nil 
                                                 repeats:NO] retain];    

        }
    }
}

- (void)idleTimerExceeded {
	/* Post a notification so anyone who subscribes to it can be notified when
	 * the application times out */ 

	//[[NSNotificationCenter defaultCenter]
	// postNotificationName:kApplicationDidTimeoutNotification object:nil];
    NSLog(@"Auto Lock Enabled");
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];

}

- (void) dealloc {
	[_idleTimer release];
	[super dealloc];
}

@end
