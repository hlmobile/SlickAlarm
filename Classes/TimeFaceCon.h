//
//  TimeFaceCon.h
//  SlickTime
//
//  Created by Miles Alden on 5/2/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Alarm;
@class Place;
@interface TimeFaceCon : UIViewController <UIPageViewControllerDelegate, UIScrollViewDelegate> {
    BOOL framesPaused;
    int curIndex;
    BOOL alarmFlashed;
}

@property (nonatomic, retain) NSArray *lstWeatherImages;
@property (nonatomic, retain) IBOutlet UIButton *btnAlarm;
@property (nonatomic, retain) IBOutlet UIButton *btnBell;
@property (nonatomic, retain) IBOutlet UIButton *btnHelp;
@property (nonatomic, retain) IBOutlet UIButton *btnSearch;
@property (nonatomic, retain) IBOutlet UIButton *btnFlashlight;
@property (nonatomic, retain) NSMutableArray *lstSingleWatchCon;
@property (nonatomic, retain) IBOutlet UIScrollView *vwScroll;
@property (nonatomic, retain) IBOutlet UILabel *lblCityName;
@property (nonatomic, retain) IBOutlet UIView *vwTitleBackground;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

@property (nonatomic, retain) IBOutlet UILabel *lblBatteryState;
@property (nonatomic, retain) Place *selectedPlace;

- (IBAction)pressAlarmButton;
- (IBAction)pressFlashlightButton;
- (IBAction)pageValueChanged:(id)sender;
- (IBAction)weatherSettingButtonPressed:(id)sender;
- (IBAction)pressHelpButton;

- (void)setupClockFace;
- (void)updateClockFace;
- (void)setClockFaceImage: (NSString *)newImage;
- (void)updateTimeWithAnimation:(BOOL)animated;
- (void)updateLocalPlace;
- (void)updateWeatherForPlace: (Place*)place;
- (void)updateWeatherSetting;

- (void)setAlarm:(Alarm *)alarm;
- (void)startRinging;
- (void)stopRinging;
- (void)toggleAlarmFlash;

- (void)toggleFramesPaused;
- (void)animateWeather;


@end
