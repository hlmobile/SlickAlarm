//
//  SleepControl.h
//  SlickTime
//
//  Created by Jin Bei on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>




@class SleepSetting;

@interface SleepControl : NSObject
{
    int  musicIndex;
    BOOL isPlaying;
    BOOL isReducingVolumn;
    float currentvolumn;
    float originalvolumn;
    int currentTime;
}

@property (nonatomic, retain) NSTimer *sleepTimer;
@property (nonatomic, retain) NSTimer *reduceVolumeTimer;
@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) SleepSetting *sleepSetting;

@property BOOL isPlaying;

- (void)startSleepMusic;
- (void)stopSleepMusic;
- (void)sleepTimerFinished;
- (void)reduceVolumeTimerFinished;
- (void)reduceVolumn;

+ (SleepControl *)sharedSleepControl;
+ (void)startSleepMusic;
+ (void)stopSleepMusic;
@end
