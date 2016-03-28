//
//  SleepSetting.m
//  SlickTime
//
//  Created by Jin Bei on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SleepSetting.h"
#import "Common.h"
@implementation SleepSetting

@synthesize sleepOn, sleepMode, musicOn, noiseOn, autoLockMode, autoLockEnabled, sleepSound;
@synthesize musicList;

#pragma mark - Dealloc

- (void)dealloc
{
    [musicList release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.sleepOn = NO;
        self.autoLockEnabled = YES;
        self.sleepMode = SleepModeOptionOneMinute;
        self.autoLockMode = AutoLockOptionNever;
        self.musicOn = YES;
        self.noiseOn = NO;
        self.sleepSound = 0;
        self.musicList = [NSMutableArray array];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.sleepMode = [aDecoder decodeIntForKey:@"sleep_mode"];
        self.autoLockMode = [aDecoder decodeIntForKey:@"auto_lock"];
        self.musicOn = [aDecoder decodeBoolForKey:@"music_on"];
        self.noiseOn = [aDecoder decodeBoolForKey:@"noise_on"];
        self.autoLockEnabled = [aDecoder decodeBoolForKey:@"auto_lock_enabled"];
        self.sleepSound = [aDecoder decodeIntForKey:@"sleep_sound"];
        NSArray *list = (NSArray *)[aDecoder decodeObjectForKey:@"music_list"];
        
        if (list)
            self.musicList = [NSMutableArray arrayWithArray:list];
        else
            self.musicList = [NSMutableArray array];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:sleepMode forKey:@"sleep_mode"];
    [aCoder encodeInt:autoLockMode forKey:@"auto_lock"];
    [aCoder encodeBool:autoLockEnabled forKey:@"auto_lock_enabled"];
    [aCoder encodeBool:musicOn forKey:@"music_on"];
    [aCoder encodeBool:noiseOn forKey:@"noise_on"];
    [aCoder encodeInt:sleepSound forKey:@"sleep_sound"];
    [aCoder encodeObject:musicList forKey:@"music_list"];
    
}

#pragma mark - Static Functions

+ (SleepSetting *)sharedSleepSetting
{
    static SleepSetting *instance = nil;
    
    if (instance == nil)
    {
        @synchronized(self)
        {
            if (instance == nil)
                instance = [[SleepSetting alloc] init];
        }
    }
    return instance;
}

+ (void)saveSleepSetting
{
    SleepSetting *setting = [SleepSetting sharedSleepSetting];
    [NSKeyedArchiver archiveRootObject:setting toFile:sleepSettingFileName()];
}

+ (void)loadSleepSetting
{
    SleepSetting *setting = (SleepSetting *)[NSKeyedUnarchiver unarchiveObjectWithFile:sleepSettingFileName()];
    SleepSetting *sharedSetting = [SleepSetting sharedSleepSetting];
    if (setting)
    {
        sharedSetting.sleepOn = setting.sleepOn;
        sharedSetting.sleepMode = setting.sleepMode;
        sharedSetting.autoLockMode = setting.autoLockMode;
        sharedSetting.musicOn = setting.musicOn;
        sharedSetting.noiseOn = setting.noiseOn;
        sharedSetting.musicList = setting.musicList;
        sharedSetting.sleepSound = setting.sleepSound;
        sharedSetting.autoLockEnabled = setting.autoLockEnabled;
    }
}

@end
