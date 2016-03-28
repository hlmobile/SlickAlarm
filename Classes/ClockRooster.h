//
//  ClockRooster.h
//  AlarmProject
//
//  Created by Miles Alden on 9/30/10.
//  Copyright 2010 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface ClockRooster : UIView {

	UIImageView *theImage;
    int curFrameIndex;
    int delayTime;
}

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) UIImageView *theImage;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

- (void)animate;
- (void)stopAnimating;
- (void)setupSelfFor:(int)timeOfDay;

- (void)playRoosterSound;
- (void)stopRoosterSound;
@end
