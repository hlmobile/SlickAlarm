//
//  SingleWatchCon.h
//  SlickTime
//
//  Created by Jin Bei on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Place;

@interface SingleWatchCon : UIViewController
{
    NSMutableArray *digits;
    UILabel *digit1, *digit2, *digit3, *digit4;
    UILabel *writtenDate, *amPM;
    UIImageView *clockFace;
    
    UIImageView *weatherIcons;
    UILabel *writtenWeather, *degrees;
    
    Place *place;
    
    CFTimeInterval frZeroTime;
    int frCounter;
    int frameCount;
}

@property (nonatomic, retain) NSArray *lstAniFileName;
@property (nonatomic, retain) Place *place;
@property (nonatomic, retain) NSString *aniFileName;


@property (nonatomic, retain) IBOutlet UILabel *digit1;
@property (nonatomic, retain) IBOutlet UILabel *digit2;
@property (nonatomic, retain) IBOutlet UILabel *digit3;
@property (nonatomic, retain) IBOutlet UILabel *digit4;
@property (nonatomic, retain) IBOutlet UILabel *writtenDate;
@property (nonatomic, retain) IBOutlet UILabel *amPM;
@property (nonatomic, retain) IBOutlet UILabel *writtenWeather;
@property (nonatomic, retain) IBOutlet UILabel *degrees;

@property (nonatomic, retain) IBOutlet UIImageView *clockFace;
@property (nonatomic, retain) IBOutlet UIImageView *weatherIcons;




- (void)updateTimeWithAnimation:(BOOL)bAnimation;
- (void)updateWeather;
- (void)updateWeatherSetting;
- (void)setClockDigits: (char *)digitArray;
- (void)animateDigits;
- (void)setAMpm: (NSString *)amPM;
- (void)setwrittenDate: (NSString *)writ;
- (void)setClockFaceImage: (NSString *)newImage;

- (void)animateWeather;


@end
