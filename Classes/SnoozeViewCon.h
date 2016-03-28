//
//  SnoozeViewCon.h
//  SlickTime
//
//  Created by Jin Bei on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBClickableScrollView.h"
@interface SnoozeViewCon : UIViewController <UIScrollViewDelegate, UIAccelerometerDelegate>

@property (nonatomic, retain) IBOutlet JBClickableScrollView *vwClickableScroll;
@property (nonatomic, retain) IBOutlet UIView *vwBackground;
@property (nonatomic, retain) IBOutlet UIImageView *vwSnoozeImage;;
@property (nonatomic, retain) UIAccelerometer *accel;

- (void)fireAlarm;
- (void)snoozeAlarm;
@end
