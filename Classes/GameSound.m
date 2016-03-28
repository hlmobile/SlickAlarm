//
//  GameSound.m
//  Angry Rhino Rampage
//
//  Created by Mark Zamoyta on 1/20/11.
//  Copyright 2011 Milk Drinking Cow, Inc. All rights reserved.
//

#import "GameSound.h"
#import "OpenALSoundController.h"
#import "EWSoundSourceObject.h"
#import "EWSoundBufferData.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SlickTimeAppDelegate.h"

#define MUSIC_VOLUME 0.5
#define ZAP_VOLUME 0.6
#define GUS_VOLUME 0.6
#define WIN_VOLUME 0.8
#define SFX_VOLUME 0.6
#define AMBIENCE_VOLUME 0.1

@implementation MDCSoundPlayer

- (id) initWithActivePtr: (BOOL *)pActive Volume: (float)gain andLooping: (BOOL)loop
{
	if ((self = [super init]) != nil) {
		pIsActive = pActive;
		currentSoundData = nil;
		self.audioLooping = loop;
		self.gainLevel = gain;
	}
	return self;
}

- (void) play: (NSString *)file;
{
//	if ( [self silenced] ) { printf("\tphone is muted\t"); return; }
	
//	else { printf("\ncurrentSoundData is null\n"); }
	
	[self stop];
	if (pIsActive == NULL || *pIsActive) {
		
		currentSoundData = [[[OpenALSoundController sharedSoundController] soundBufferDataFromFileBaseName:file withCaching: NO] retain];

		[self playSound: currentSoundData];
		
	}
}

- (void) stop
{
	[self stopSound];
	if (currentSoundData) {
		[currentSoundData release];
		currentSoundData = NULL;
	}
}


- (void) dealloc
{
	[self stop];
	[super dealloc];
}

@end



@implementation GameSound

@synthesize currentMusic;
	
- (id) init
{
	if ((self = [super init]) != nil) {
		SlickTimeAppDelegate *del = (SlickTimeAppDelegate *) APP_DELEGATE;
	
		currentMusic = [[MDCSoundPlayer alloc] initWithActivePtr: &del->musicOn Volume: MUSIC_VOLUME  andLooping: YES];
		
		for (int ix = 0; ix < MAX_SIMULTANEOUS_SFX; ix++) {
			sFX[ix]  = [[MDCSoundPlayer alloc] initWithActivePtr: &del->sfxOn   Volume: SFX_VOLUME    andLooping: NO];
		}
		latestSFxIdx = -1;
	}
	return self;
}



#pragma mark -
#pragma mark Music

- (void) playMusic: (NSString *)music volume: (NSNumber *)volume looping: (NSNumber *)oneOrZero andPitch:(NSNumber *)pitch
{
	[currentMusic play:music];
	if ( volume != nil && oneOrZero != nil && pitch != nil ) {
		if ( volume != nil )	[self->currentMusic setGainLevel:[volume floatValue]];
		if ( oneOrZero != nil )	[self->currentMusic setAudioLooping: ( [oneOrZero intValue] == 1 ) ? YES : NO];
		if ( pitch != nil )		[self->currentMusic setPitchShift:[pitch floatValue]];
		[self->currentMusic update];
	}
		
}

- (void) stopMusic
{
	[currentMusic stop];
	//[currentMusic stopSound];
}



- (BOOL)silenced {
	//#if TARGET_IPHONE_SIMULATOR
	//	// return NO in simulator. Code causes crashes for some reason.
	//	return NO;
	//#endif
	
    CFStringRef state;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state);
    if(CFStringGetLength(state) > 0)
        return NO;
    else
        return YES;
	
}









#pragma mark -
#pragma mark SFX
- (void) playSFX: (NSString *)audio volume: (NSNumber *)volume looping: (NSNumber *)oneOrZero andPitch:(NSNumber *)pitch
{
	
	latestSFxIdx++;
	if (latestSFxIdx >= MAX_SIMULTANEOUS_SFX)
		latestSFxIdx = 0;
	
	[sFX[latestSFxIdx] play: audio];
	
	if ( volume != nil || oneOrZero != nil || pitch != nil ) {
		if ( volume != nil )	[self->sFX[latestSFxIdx] setGainLevel:[volume floatValue]];
		if ( oneOrZero != nil )	[self->sFX[latestSFxIdx] setAudioLooping: ( [oneOrZero intValue] == 1 ) ? YES : NO];
		if ( pitch != nil )		[self->sFX[latestSFxIdx] setPitchShift:[pitch floatValue]];
		[self->sFX[latestSFxIdx] update];
	}
		
}



- (void)setCurrentSFXVolume: (float) gain
{
	[sFX[latestSFxIdx] setGainLevel: gain ]; 
	[sFX[latestSFxIdx] update];
}

- (void)stopSFXAudio 
{
	
	for (int ix = 0; ix < MAX_SIMULTANEOUS_SFX; ix++)
		[sFX[ix] stop];
	
	latestSFxIdx = -1;
	
	//[sFX stopSound];
	
}

- (void) vibrateDevice
{
	if (isVibrationActive)
		AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}
















#pragma mark -
#pragma mark Activation

/*
- (void) activateMusic: (BOOL) isActive
{
	isMusicActive = isActive;
	if (!isMusicActive)
	{
		[self stopMusic];
	}
}

- (void) activateSound: (BOOL) isActive
{
	isSoundActive = isActive;
}
*/

- (void) activateVibration: (BOOL) isActive
{
	isVibrationActive = isActive;
}


#pragma mark -
#pragma mark Lifecycle

- (void) dealloc
{
	if (currentMusic) {
		[currentMusic stopSound];
		[currentMusic release];
		currentMusic = nil;
	}

		
	
	if (sFX) {
		for (int ix = 0; ix < MAX_SIMULTANEOUS_SFX; ix++) {
			[sFX[ix] stopSound];
			[sFX[ix] release];
			sFX[ix] = nil;
		}
		latestSFxIdx = -1;
	}
	
	[super dealloc];
}









@end
