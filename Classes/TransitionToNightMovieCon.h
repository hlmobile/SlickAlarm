//
//  TransitionToNightMovieCon.h
//  SlickTime
//
//  Created by Miles Alden on 6/14/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>


@interface TransitionToNightMovieCon : UIViewController {

    BOOL framesPaused;
    
    NSString *fileName;
    int frCounter, lastCount;
    CFTimeInterval frZeroTime;
    
    IBOutlet UIImageView *theImage;

    
    MPMoviePlayerController *movieCon;

}

- (void)setup;
- (void)stopMovie;
- (void)startMovie;
- (MPMoviePlayerController *)movieCon;
- (void)setupForFrameByFrame;
- (void)animate;


@end
