//
//  FarmNightViewCon.h
//  SlickTime
//
//  Created by Miles Alden on 6/22/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FarmNightViewCon : UIViewController {
    
    float rotationAmount, cloudX;
    
    
    IBOutlet UIImageView *clouds, *windmill, *backdrop, *foreground, *moon;
    UIImageView *sun;
    
}

- (void)setup;
- (void)animate;

- (void)transitionToNight;
- (void)transitionToDay;
- (void)completeNightTransition;


@end
