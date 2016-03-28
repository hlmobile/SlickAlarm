//
//  FarmViewCon.h
//  SlickTime
//
//  Created by Miles Alden on 5/2/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FarmViewCon : UIViewController {

    float rotationAmount, cloudX;
    
    
    IBOutlet UIImageView *sun, *clouds, *windmill, *backdrop, *foreground;
    UIImageView *moon;
    
}



- (void)setup;
- (void)animate;
- (void)animate_;

- (void)transitionToNight;
- (void)completeNightTransition;
- (void)stopAllAnimations;
- (void)raiseSun;

@end
