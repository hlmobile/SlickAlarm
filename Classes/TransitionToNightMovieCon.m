//
//  TransitionToNightMovieCon.m
//  SlickTime
//
//  Created by Miles Alden on 6/14/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "TransitionToNightMovieCon.h"
#import "SlickTimeAppDelegate.h"
#import "CentralControl.h"















@implementation TransitionToNightMovieCon


#pragma mark -
#pragma mark FrameBy Setup
- (void)setupForFrameByFrame
{
    frCounter = 0;
    framesPaused = NO;
}




- (void)setup
{
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    NSURL *movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"day-night_test02" ofType:@"mov"]];
    self->movieCon = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    [self.view addSubview:movieCon.view];
    
    [movieCon setControlStyle:MPMovieControlStyleNone];
    [movieCon.view setFrame:CGRectMake(0, 0, 320, 480)]; 
    
    [movieCon play];
    
}

- (void)startMovie
{
    
    if ( movieCon != nil )
    {
        [movieCon play];
    }
}

- (void)stopMovie
{
    [movieCon stop];
}


- (MPMoviePlayerController *)movieCon
{
    return movieCon;
}

//night_day_test0













#pragma mark -
#pragma mark Frame by frame
- (void)animate
{
    
    if ( framesPaused ) return;
    
    int LastFrame = 95;
    
	
	if (frCounter == 0) {
		frZeroTime = CACurrentMediaTime(); 
        frCounter = 0; //[[NSProcessInfo processInfo] systemUptime];
	} else if (frCounter <= LastFrame) {
		CFTimeInterval elapsed = CACurrentMediaTime() - frZeroTime;
		int nextFrame = (int)(elapsed * FRAMES_PER_SECOND);
		frCounter = (nextFrame > LastFrame) ? LastFrame : nextFrame;
	}
	
	
	if ( frCounter > LastFrame ) 
    {
        frCounter = 0;
        SlickTimeAppDelegate *del = APP_DELEGATE;
        [del.centralCon updateSelectors];
        [del.centralCon callTransitionUnloadSelectors];
        return;
    }
    NSString *theStr = [NSString stringWithFormat:@"%@%d", @"day_night_test", frCounter];
    NSString *nm = [NSString stringWithString: [[NSBundle mainBundle] pathForResource:theStr ofType:@"png"]];
    theImage.image = [UIImage imageWithContentsOfFile:nm];    
    
	frCounter++;
    
}






- (void)dealloc
{
    
    if ( movieCon != nil )
    {
        [movieCon stop];
        [movieCon release];
        self->movieCon = nil;
    }
    
    
    
    [super dealloc];
}

@end
