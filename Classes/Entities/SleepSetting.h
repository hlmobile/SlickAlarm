//
//  SleepSetting.h
//  SlickTime
//
//  Created by Jin Bei on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SleepSetting : NSObject <NSCoding>
{
    BOOL sleepOn;
    int sleepMode;
    int autoLockMode;
    BOOL autoLockEnabled;
    BOOL musicOn;
    BOOL noiseOn;
    int sleepSound;
    
    NSMutableArray *musicList;
}

@property (nonatomic, assign) BOOL sleepOn;
@property (nonatomic, assign) int sleepMode;
@property (nonatomic, assign) int autoLockMode;
@property (nonatomic, assign) BOOL autoLockEnabled;
@property (nonatomic, assign) BOOL musicOn;
@property (nonatomic, assign) BOOL noiseOn;
@property (nonatomic, assign) int sleepSound;
@property (nonatomic, retain) NSMutableArray *musicList;


+ (SleepSetting *)sharedSleepSetting;
+ (void)saveSleepSetting;
+ (void)loadSleepSetting;
@end
