//
//  GameSound.h
//  Angry Rhino Rampage
//
//  Created by Mark Zamoyta on 1/20/11.
//  Copyright 2011 Milk Drinking Cow, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "EWSoundSourceObject.h"

@interface MDCSoundPlayer : EWSoundSourceObject {
	BOOL *pIsActive;
	EWSoundBufferData *currentSoundData;
};

- (id) initWithActivePtr: (BOOL *)pActive Volume: (float)gain andLooping: (BOOL)loop;
- (void) play: (NSString *)file;
- (void) stop;

@end

#define MAX_SIMULTANEOUS_SFX 6

@interface GameSound : NSObject {
	
	BOOL isVibrationActive;
	
	MDCSoundPlayer *currentMusic;
	MDCSoundPlayer *sFX[MAX_SIMULTANEOUS_SFX];
	
	int latestSFxIdx;
}

@property (readonly) MDCSoundPlayer *currentMusic;


//- (void) activateMusic: (BOOL) isActive;
//- (void) activateSound: (BOOL) isActive;
- (void) activateVibration: (BOOL) isActive;


- (void) playMusic: (NSString *)music volume: (NSNumber *)volume looping: (NSNumber *)oneOrZero andPitch:(NSNumber *)pitch;
- (void)stopMusic;

- (void) playSFX: (NSString *)audio volume: (NSNumber *)volume looping: (NSNumber *)oneOrZero andPitch:(NSNumber *)pitch;




- (void)setCurrentSFXVolume: (float) gain;
- (void)stopSFXAudio;
- (void) vibrateDevice;
- (BOOL)silenced;


@end
