//
//  ClockRooster.m
//  AlarmProject
//
//  Created by Miles Alden on 9/30/10.
//  Copyright 2010 Santa Cruz Singers. All rights reserved.
//

#import "ClockRooster.h"
#import <CoreFoundation/CoreFoundation.h>

#define kAnimationImageCount 78

#define kAnimationDuration 3.0

#define kRoosterPositionX 0
#define kRoosterPositionY 0

@implementation ClockRooster
@synthesize imageArray, timer;
@synthesize theImage;
@synthesize audioPlayer;
- (void)dealloc
{
    [theImage release];
    [imageArray release];
    if (timer)
    {
        [timer invalidate];
        [timer release];
    }
    if (audioPlayer)
    {
        [audioPlayer stop];
        [audioPlayer release];
    }
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        curFrameIndex = 0;
        self.imageArray = [NSMutableArray array];
        for (int i = 0; i < kAnimationImageCount; i += 2)
        {
            
            UIImage *anImage = [UIImage imageNamed:[NSString stringWithFormat:@"rooster%d", i]];
            [imageArray addObject:anImage];
            
            
        }
        delayTime = 0;
    }
    return self;
}

- (UIImage *)imageForIndex:(int)index
{
    return [imageArray objectAtIndex:index];
}

- (void)setupSelfFor:(int)timeOfDay {
	
    
    self.contentMode = UIViewContentModeScaleToFill;
	if (theImage == nil) {
		NSLog(@"initializing Rooster image");
		
        theImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 215, 220)];
        
        curFrameIndex = 0;
        theImage.image = [self imageForIndex:curFrameIndex];		
		//theImage.center = CGPointMake(kRoosterPositionX, kRoosterPositionY); 
	}
	
	NSLog(@"(rooster) theImage retainCount: %d", [theImage retainCount]);
	
}

- (void)playRoosterSound
{
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"RoosterCrow" withExtension:@"caf"];
    self.audioPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil] autorelease];
	audioPlayer.numberOfLoops = 1;     
	[audioPlayer prepareToPlay];
    [audioPlayer setVolume:1];
    [audioPlayer play];
}

- (void)stopRoosterSound
{
    [audioPlayer stop];
    self.audioPlayer = nil;
}

- (void)animationTimer:(NSTimer *)timer
{

    if (curFrameIndex == 0 && audioPlayer)
    {
        [audioPlayer stop];
        audioPlayer.currentTime = 0;
        [audioPlayer setVolume:1];
        [audioPlayer play];    
    }
    if (curFrameIndex < kAnimationImageCount / 2)
    {
        int imageIndex = (curFrameIndex);
        if (imageIndex < 0)
            imageIndex = 0;
        theImage.image = [self imageForIndex:imageIndex];
    }
    curFrameIndex++;
    if (curFrameIndex >= kAnimationImageCount / 2 + 60)
    {
        curFrameIndex = 0;
    }
}

- (void)animate {
	[self addSubview:theImage];
    
    if (timer)
    {
        [timer invalidate];
        [timer release];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kAnimationDuration * 2 /kAnimationImageCount target:self selector:@selector(animationTimer:) userInfo:nil repeats:YES];
    
}

- (void)stopAnimating {
    
    [self.timer invalidate];
    [audioPlayer stop];
}

- (void)fadeIn {}
- (void)fadeOut {}
- (void)viaDelay {}


- (void)makeNoise {}

- (void)reset {}

- (void)checkNeedsAnimating {}


@end
