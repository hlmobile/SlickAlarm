//
//  TimeFaceCon.m
//  SlickTime
//
//  Created by Miles Alden on 5/2/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "TimeFaceCon.h"
#import "SlickTimeAppDelegate.h"
#import "CentralControl.h"
#import "SlickTimeAppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "Alarm.h"
#import "SingleWatchCon.h"
#import "WeatherSetting.h"
#import "QuartzCore/QuartzCore.h"
#import "Weather.h"

@implementation TimeFaceCon


@synthesize btnBell, btnAlarm;
@synthesize lstSingleWatchCon;
@synthesize selectedPlace;

@synthesize btnSearch, lblCityName, pageControl, vwScroll, vwTitleBackground;
@synthesize btnFlashlight;
@synthesize lblBatteryState;
@synthesize lstWeatherImages;
@synthesize btnHelp;
#pragma mark - Dealloc

- (void)dealloc
{
    [lstWeatherImages release];
    [lstSingleWatchCon release];
    [btnAlarm release];
    [btnBell release];
    
    [btnSearch release];
    [lblCityName release];
    [pageControl release];
    [vwScroll release];
    [vwTitleBackground release];
    [selectedPlace release];
    [btnFlashlight release];
    [lblBatteryState release];
    [super dealloc];
    
}
#pragma mark - Helper Functions
- (NSString *)fileNameForWeatherType:(WeatherType)type
{
    NSString *retVal;
    
    switch (type) {
        case WeatherTypeThunderStorm:
            retVal = @"lightning_rain_";
            break;
        case WeatherTypeSunny:
            retVal = @"sunny";
            break;
        case WeatherTypeRainy:
            retVal = @"rain_cloud_";
            break;
        case WeatherTypeSnowy:
            retVal = @"snow_cloud";
            break;
        case WeatherTypePartlyCloudy:
            retVal = @"partial_clouds-";
            break;
        default:
            retVal = @"";
            break;
    }
    return retVal;
}


- (int)countOfWeatherFrames:(WeatherType)type;
{
    int num;
    
    switch (type)
    {
        case WeatherTypeThunderStorm:
            num = 36;
            break;
        case WeatherTypeSnowy:
            num = 40;
            break;
        case WeatherTypeSunny:
            num = 30;
            
            
            break;
        case WeatherTypeRainy:
            num = 36;
            break;
        case WeatherTypePartlyCloudy:
            num = 30;
            break;
        default:
            break;
    }
    
    return num;
}

- (NSArray *)animationImageListForType:(int)type
{
    NSMutableArray *animList = [NSMutableArray array];
    
    NSString *animFileName = [self fileNameForWeatherType:type];
    int count = [self countOfWeatherFrames:type];
    
    for (int i = 0; i < count; i++)
    {
        NSString *aniName = [NSString stringWithFormat:@"%@%d", animFileName, i];
        [animList addObject:[UIImage imageNamed:aniName]];
    }
    return animList;
}

#pragma mark - Initialize

- (void)setupClockFace
{
    NSArray *placeList = [WeatherSetting listOfPlace];
    vwTitleBackground.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3];
    vwTitleBackground.layer.cornerRadius = 15.0;
    vwTitleBackground.layer.masksToBounds = YES;
    [btnAlarm setTitleColor:SLICK_TIME_BLUE_COLOR forState:UIControlStateNormal];
    [btnAlarm setTitleColor:SLICK_TIME_BLUE_COLOR forState:UIControlStateHighlighted];
    
    self.lstWeatherImages = [NSArray arrayWithObjects:
                             [self animationImageListForType:WeatherTypeSunny],
                             [self animationImageListForType:WeatherTypeRainy],
                             [self animationImageListForType:WeatherTypePartlyCloudy],
                             [self animationImageListForType:WeatherTypeSnowy],
                             [self animationImageListForType:WeatherTypeThunderStorm],
                             nil];
    
    float pageWidth = vwScroll.frame.size.width;
    float pageHeight = vwScroll.frame.size.height;
    
    if (YES /*[WeatherSetting isLocalPlaceEnabled] || placeList.count == 0 */)
    {
        SingleWatchCon *con = [[[SingleWatchCon alloc] initWithNibName:@"SingleWatchCon" bundle:nil] autorelease];
        con.place = [WeatherSetting localPlace];
        
        [lstSingleWatchCon addObject:con];
        con.view.frame = CGRectMake(0, 0, pageWidth, pageHeight);
        [vwScroll addSubview:con.view];
        if (con.place.weather)
        {
            con.lstAniFileName = [self.lstWeatherImages objectAtIndex:con.place.weather.type];
            [con updateWeather];
        }
        if ([WeatherSetting isWeatherEnabled])
        {
            [con.weatherIcons setHidden:NO];
            [con.writtenWeather setHidden:NO];
            [con.degrees setHidden:NO];
        }
        else
        {
            [con.weatherIcons setHidden:YES];
            [con.writtenWeather setHidden:YES];
            [con.degrees setHidden:YES];
        }
    }
    
    
    
    for (Place *place in placeList)
    {
        int index = lstSingleWatchCon.count;
        SingleWatchCon *con = [[[SingleWatchCon alloc] initWithNibName:@"SingleWatchCon" bundle:nil] autorelease];
        con.place = place;
        
        [lstSingleWatchCon addObject:con];
        
        con.view.frame = CGRectMake(pageWidth * index, 0, pageWidth, pageHeight);
        [vwScroll addSubview:con.view];
        if (con.place.weather)
        {
            con.lstAniFileName = [self.lstWeatherImages objectAtIndex:con.place.weather.type];
            [con updateWeather];
        }
        if ([WeatherSetting isWeatherEnabled])
        {
            [con.weatherIcons setHidden:NO];
            [con.writtenWeather setHidden:NO];
            [con.degrees setHidden:NO];
        }
        else
        {
            [con.weatherIcons setHidden:YES];
            [con.writtenWeather setHidden:YES];
            [con.degrees setHidden:YES];
        }
    }
    
    pageControl.numberOfPages = lstSingleWatchCon.count;
    vwScroll.contentSize = CGSizeMake(lstSingleWatchCon.count * pageWidth, pageHeight);
    // Set the city label
    if (lstSingleWatchCon.count > 0)
    {
        SingleWatchCon *con = (SingleWatchCon *)[lstSingleWatchCon objectAtIndex:0];
        Place *place = con.place;
        lblCityName.text = place.name;
    }
    
    [self updateTimeWithAnimation:NO];
    selectedPlace = nil;
    
    
    
}

- (void)updateClockFace
{
    //Remove all subviews from vwScroll
    NSArray *subviews = vwScroll.subviews;
    for (UIView *v in subviews)
        [v removeFromSuperview];
    
    float pageWidth = vwScroll.frame.size.width;
    float pageHeight = vwScroll.frame.size.height;
    
    NSMutableArray *newConList = [NSMutableArray array];
    NSArray *placeList = [WeatherSetting listOfPlace];
    //Reorganize singlewatchcon
    //Local Plaec
    if (YES /*[WeatherSetting isLocalPlaceEnabled] || placeList.count == 0 */)
    {

        SingleWatchCon *con = [[[SingleWatchCon alloc] initWithNibName:@"SingleWatchCon" bundle:nil] autorelease];
        con.place = [WeatherSetting localPlace];
        [newConList addObject:con];

        
        con.view.frame = CGRectMake(0, 0, pageWidth, pageHeight);
        [vwScroll addSubview:con.view];
        if (con.place.weather)
        {
            con.lstAniFileName = [self.lstWeatherImages objectAtIndex:con.place.weather.type];
            [con updateWeather];
        }
    }
    
    
    
    //New places
    for (Place *place in placeList)
    {
        int index = newConList.count;
        
        SingleWatchCon *con = nil;

        
        //Search reusable controller
        
        for (SingleWatchCon *oldCon in lstSingleWatchCon)
        {
            if (oldCon.place == place)
            {
                [newConList addObject:oldCon];
                con = oldCon;
                break;
            }
        }
        
        if (con == nil)
        {
            con = [[[SingleWatchCon alloc] initWithNibName:@"SingleWatchCon" bundle:nil] autorelease];
            con.place = place;
            [newConList addObject:con];
        }
                
        con.view.frame = CGRectMake(pageWidth * index, 0, pageWidth, pageHeight);
        [vwScroll addSubview:con.view];
        if (con.place.weather)
        {
            con.lstAniFileName = [self.lstWeatherImages objectAtIndex:con.place.weather.type];
            [con updateWeather];
        }
    }
    
    [lstSingleWatchCon removeAllObjects];
    
    self.lstSingleWatchCon = newConList;
    
    pageControl.numberOfPages = lstSingleWatchCon.count;
    vwScroll.contentSize = CGSizeMake(lstSingleWatchCon.count * pageWidth, pageHeight);
    // Set the city label
    if (lstSingleWatchCon.count > 0)
    {
        SingleWatchCon *con = (SingleWatchCon *)[lstSingleWatchCon objectAtIndex:0];
        Place *place = con.place;
        lblCityName.text = place.name;
    }
    
    
    //Find original selected index and restore the page.
    if (lstSingleWatchCon.count  > 0 && selectedPlace)
    {
        int i = 0;
        for (i = 0; i < lstSingleWatchCon.count; i++)
        {
            SingleWatchCon *con = [lstSingleWatchCon objectAtIndex:i];
            if (con.place == selectedPlace)
            {
                curIndex = i;
                Place *place = con.place;
                lblCityName.text = place.name;
                pageControl.currentPage = curIndex;
                break;
            }
        }
        
        //Has not fount original selected place
        if (i == lstSingleWatchCon.count)
        {
            SingleWatchCon *con = [lstSingleWatchCon objectAtIndex:0];
            curIndex = 0;
            Place *place = con.place;
            lblCityName.text = place.name;
            pageControl.currentPage = curIndex;

        }
    }
    for (SingleWatchCon *con in lstSingleWatchCon)
    {
        if ([WeatherSetting isWeatherEnabled])
        {
            [con.weatherIcons setHidden:NO];
            [con.writtenWeather setHidden:NO];
            [con.degrees setHidden:NO];
        }
        else
        {
            [con.weatherIcons setHidden:YES];
            [con.writtenWeather setHidden:YES];
            [con.degrees setHidden:YES];
        }
    }
    self.selectedPlace = nil;
    
    [self updateTimeWithAnimation:NO];    
    
}

- (void)setClockFaceImage: (NSString *)newImage
{
    for (SingleWatchCon *con in lstSingleWatchCon)
    {
        [con setClockFaceImage:newImage];
    }
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.lstSingleWatchCon = [NSMutableArray array];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupClockFace];
    framesPaused = YES;
    [self toggleFramesPaused];
    alarmFlashed = NO;
}
#pragma mark - Alarm Control
- (void)setAlarm:(Alarm *)alarm;
{
    if (alarm == nil)
    {
        btnBell.hidden = NO;
        btnAlarm.hidden = YES;
        btnHelp.hidden = NO;
        CGRect frame = btnHelp.frame;
        frame.origin.x = btnBell.frame.origin.x - frame.size.width - 10;
        btnHelp.frame = frame;
    }
    else
    {
        btnBell.hidden = YES;
        btnAlarm.hidden = NO;
        btnHelp.hidden = NO;
        CGRect frame = btnHelp.frame;
        frame.origin.x = btnAlarm.frame.origin.x - frame.size.width - 10;
        btnHelp.frame = frame;
        NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease]; 
        
        unsigned unitFlags = NSYearCalendarUnit | NSWeekCalendarUnit |  NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
        NSDateComponents *alarmComponents = [gregorian components: unitFlags fromDate: alarm.alarmTime];
        
        NSString *alarmString = [NSString stringWithFormat:@"%02d:%02d %@", (alarmComponents.hour + 11) % 12 + 1, alarmComponents.minute, (alarmComponents.hour < 12?@"AM":@"PM")];
        [btnAlarm setTitle:alarmString forState:UIControlStateNormal];
        [btnAlarm setTitle:alarmString forState:UIControlStateHighlighted];
    }
}

- (void)startRinging
{
    [btnAlarm setBackgroundImage:[UIImage imageNamed:@"alarm_goingoff~iphone"] forState:UIControlStateNormal];
    [btnAlarm setBackgroundImage:[UIImage imageNamed:@"alarm_goingoff~iphone"] forState:UIControlStateNormal];
    [btnAlarm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[self updateTimeWithAnimation:YES];
    alarmFlashed = YES;
}

- (void)stopRinging
{
    
    [btnAlarm setBackgroundImage:[UIImage imageNamed:@"alarm_bar~iphone"] forState:UIControlStateNormal];
    [btnAlarm setBackgroundImage:[UIImage imageNamed:@"alarm_bar~iphone"] forState:UIControlStateNormal];
    [btnAlarm setTitleColor:SLICK_TIME_BLUE_COLOR forState:UIControlStateNormal];
    alarmFlashed = NO;
}

- (void)toggleAlarmFlash
{
    if (alarmFlashed)
        [self stopRinging];
    else
        [self startRinging];
}




#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;  
    int newIndex = floor((scrollView.contentOffset.x - pageWidth / 3) / pageWidth) + 1;
    if (newIndex < 0 || newIndex >= lstSingleWatchCon.count)
        return;
    if (newIndex != curIndex)
    {
        curIndex = newIndex;
        SingleWatchCon *con = (SingleWatchCon *)[lstSingleWatchCon objectAtIndex:curIndex];
        Place *place = con.place;
        lblCityName.text = place.name;
        pageControl.currentPage = curIndex;
    }
    
}

#pragma mark - Animation

- (void)toggleFramesPaused
{
    
    if ( framesPaused )
    {
        framesPaused = NO;
    }
    
    else
    {
        framesPaused = YES;
    }
}

- (void)animateWeather
{

    if ( framesPaused ) return;
    int count = lstSingleWatchCon.count;
    for (int i = 0; i < count; i++)
    {
        if (i == curIndex || i - 1 == curIndex || i + 1 == curIndex)
        {
            SingleWatchCon *con = [lstSingleWatchCon objectAtIndex:i];
            [con animateWeather];
        }
    }
    
}


#pragma mark - Update Weather and Time

- (void)updateLocalPlace
{
    if (YES /*[WeatherSetting isLocalPlaceEnabled] || placeList.count == 0 */)
    {
        SingleWatchCon *con = [lstSingleWatchCon objectAtIndex:0];
        con.place = [WeatherSetting localPlace];
        [con updateTimeWithAnimation:NO];
        
        if (curIndex == 0)
        {
            lblCityName.text = con.place.name;
        }
    }
}

- (void)updateWeatherForPlace: (Place*)place
{
    for (SingleWatchCon *con in lstSingleWatchCon)
    {
        if (con.place == place)
        {
            con.lstAniFileName = [self.lstWeatherImages objectAtIndex:place.weather.type];
            [con updateWeather];
            
            
        }
        
    }
}

- (void)updateWeatherSetting
{
    for (SingleWatchCon *con in lstSingleWatchCon)
    {

        [con updateWeatherSetting];

        
    }
}

- (void)updateTimeWithAnimation:(BOOL)animated
{
    for (SingleWatchCon *con in lstSingleWatchCon)
    {
        [con updateTimeWithAnimation:animated];
    }
}

#pragma mark - IBAction
- (IBAction)pressAlarmButton {
    
	SlickTimeAppDelegate *del = (SlickTimeAppDelegate *)APP_DELEGATE;
    if (del.centralCon.sceneState == AlarmRinging || del.centralCon.sceneState == AlarmSnoozing)
        [del.centralCon stopFiringAlarm];
    else
        [del.centralCon flipView];
	//[del.centralCon fireAlarm:nil];
}

- (IBAction)pressHelpButton
{
    SlickTimeAppDelegate *del = (SlickTimeAppDelegate *)APP_DELEGATE;
    [del.centralCon presentInfoScreen];
//    SlickTimeAppDelegate *del = (SlickTimeAppDelegate *)APP_DELEGATE;
//    if (del.centralCon.sceneState == AlarmRinging || del.centralCon.sceneState == AlarmSnoozing)
//        [del.centralCon stopFiringAlarm];
//    [del.centralCon flipView];
//    [del.centralCon showHelp];
}

- (IBAction)pressFlashlightButton {
    
    // initialize flashlight
    // test if this class even exists to ensure flashlight is turned on ONLY for iOS 4 and above
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]){
            
            
            //turn flashlight on
            if (device.torchMode == AVCaptureTorchModeOff) {
                
                [device lockForConfiguration:nil];
                
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                
                [device unlockForConfiguration];
                [btnFlashlight setImage:[UIImage imageNamed:@"flashlight_on"] forState:UIControlStateNormal];
            }
            
            //Turn flashlight off
            else {
                
                [device lockForConfiguration:nil];
                
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];  
                
                [device unlockForConfiguration];  
                [btnFlashlight setImage:[UIImage imageNamed:@"flashlight_on"] forState:UIControlStateNormal];
            }
            
            
        }
    }
	
    
}

- (IBAction)pageValueChanged:(id)sender
{
    curIndex = pageControl.currentPage;
    CGFloat pageWidth = vwScroll.frame.size.width;
    [vwScroll setContentOffset:CGPointMake(curIndex * pageWidth, 0)];
    
    // Set the city label

    SingleWatchCon *con = (SingleWatchCon *)[lstSingleWatchCon objectAtIndex:curIndex];
    Place *place = con.place;
    lblCityName.text = place.name;

}

- (IBAction)weatherSettingButtonPressed:(id)sender
{
    SlickTimeAppDelegate *del = (SlickTimeAppDelegate *)APP_DELEGATE;
    [del.centralCon presentWeatherSetting];
    if (lstSingleWatchCon.count > 0)
    {
        SingleWatchCon *con = [lstSingleWatchCon objectAtIndex:curIndex];
        self.selectedPlace = con.place;
    }
}


@end
