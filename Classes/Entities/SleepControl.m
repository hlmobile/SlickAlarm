//
//  SleepControl.m
//  SlickTime
//
//  Created by Jin Bei on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SleepControl.h"
#import "SleepSetting.h"
#import "Common.h"

@implementation SleepControl

@synthesize sleepTimer, musicPlayer;
@synthesize sleepSetting, isPlaying;
@synthesize reduceVolumeTimer;
@synthesize audioPlayer;

- (void)dealloc
{
    if (sleepTimer)
    {
        [sleepTimer invalidate];
        [sleepTimer release];
    }
    
    if (reduceVolumeTimer)
    {
        [reduceVolumeTimer invalidate];
        [reduceVolumeTimer release];
    }

    [musicPlayer release];
    
    [audioPlayer release];
    [sleepSetting release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.sleepSetting = [SleepSetting sharedSleepSetting];
        self.musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
        isReducingVolumn = NO;
    }
    return self;
}

- (void)setQueueWithMusicList:(NSArray *)musicList
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
}


- (void)startSleepMusic{
	
    musicIndex = 0;
    [self stopSleepMusic];
    self.isPlaying = YES;
    NSArray *musicList = sleepSetting.musicList;
    if (musicList.count == 0 && sleepSetting.musicOn)
        return;
    
    int sleepMinutes = 0;
    SleepModeOption sleepMode = sleepSetting.sleepMode;
    if (sleepMode == SleepModeOptionOneMinute)
        sleepMinutes = 1;
    else if (sleepMode == SleepModeOptionThreeMinutes)
        sleepMinutes = 3;
    else if (sleepMode == SleepModeOptionTenMinutes)
        sleepMinutes = 10;
    else if (sleepMode == SleepModeOptionThirtyMinutes)
        sleepMinutes = 30;
    else if (sleepMode == SleepModeOptionOneHour)
        sleepMinutes = 60;
    else if (sleepMode == SleepModeOptionThreeMinutes)
        sleepMinutes = 0;
    
    
    if (sleepSetting.musicOn)
    {
        [self setQueueWithMusicList:musicList];
        self.musicPlayer.repeatMode = MPMusicRepeatModeAll;
        [self.musicPlayer play];
    }
    else 
    {
        if (audioPlayer != nil)
            [audioPlayer stop];
        NSString *fileName = [[NSArray arrayWithObjects:WHITE_NOISE_LIST, nil] objectAtIndex:sleepSetting.sleepSound];
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *soundPath = [bundle pathForResource:fileName ofType:@"mp3"];

        NSURL *soundURL = [[[NSURL alloc] initFileURLWithPath:soundPath] autorelease];
        self.audioPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil] autorelease];
        audioPlayer.numberOfLoops = -1;
        [audioPlayer prepareToPlay];
        [audioPlayer play];

    }
    
    [self.musicPlayer setVolume:0.7];
    
    
    isReducingVolumn = NO;
    if (sleepMinutes > 0)
    {
        self.sleepTimer = [NSTimer scheduledTimerWithTimeInterval:sleepMinutes * 60 target:self selector:@selector(sleepTimerFinished) userInfo:nil repeats:NO];

        self.reduceVolumeTimer = [NSTimer scheduledTimerWithTimeInterval:(sleepMinutes - 1) * 60 target:self selector:@selector(reduceVolumeTimerFinished) userInfo:nil repeats:NO];

    }
    
    [SleepSetting sharedSleepSetting].sleepOn = YES;
    
}


-(void)stopSleepMusic {
    if (self.isPlaying == NO)
        return;
    self.isPlaying = NO;
    [self.musicPlayer stop];
    self.audioPlayer = nil;
    [sleepTimer invalidate];
    self.sleepTimer = nil;
    [self.reduceVolumeTimer invalidate];
    self.reduceVolumeTimer = nil;
    isReducingVolumn = NO;
    [SleepSetting sharedSleepSetting].sleepOn = NO;
}

- (void)sleepTimerFinished{
	[self stopSleepMusic];
    sleepSetting.sleepOn = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSleepDidFinish object:nil];

}

- (void)reduceVolumeTimerFinished
{
    isReducingVolumn = YES;
    currentTime = 60;
    currentvolumn = self.musicPlayer.volume;
    originalvolumn = currentvolumn;
    [self.reduceVolumeTimer invalidate];
    self.reduceVolumeTimer = nil;
}

- (void)reduceVolumn
{
    if (isReducingVolumn)
    {
        currentvolumn = self.musicPlayer.volume;
        if (currentTime > 0)
        {
            currentvolumn -= originalvolumn/60.0;
        }
        if (currentvolumn <= 0.1)
        {
            currentvolumn = 0.1;
        }
        [self.musicPlayer setVolume:currentvolumn];
        
    }
}




#pragma mark - Static Functions

+ (SleepControl *)sharedSleepControl
{
    static SleepControl *instance = nil;
    
    if (instance == nil)
    {
        @synchronized(self)
        {
            if (instance == nil)
                instance = [[SleepControl alloc] init];
        }
    }
    return instance;
}

+ (void)startSleepMusic
{
    SleepControl *control = [SleepControl sharedSleepControl];
    [control startSleepMusic];
}
+ (void)stopSleepMusic
{
    SleepControl *control = [SleepControl sharedSleepControl];
    
    [control stopSleepMusic];
}

@end
