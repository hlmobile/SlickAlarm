//
//  SingleWatchCon.m
//  SlickTime
//
//  Created by Jin Bei on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SingleWatchCon.h"
#import "Alarm.h"
#import "Place.h"
#import "Weather.h"
#import "WeatherSetting.h"
#import "Common.h"
#import "QuartzCore/QuartzCore.h"
@implementation SingleWatchCon
@synthesize place;
@synthesize aniFileName;

@synthesize digit1, digit2, digit3, digit4;
@synthesize writtenDate, amPM, writtenWeather, degrees;
@synthesize clockFace,weatherIcons;
@synthesize lstAniFileName;

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
#pragma mark - Setup
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        frCounter = YES;
        frZeroTime = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [self updateWeather];
    
}
- (void)setClockFaceImage: (NSString *)newImage
{
    NSString *nm = [NSString stringWithString: [[NSBundle mainBundle] pathForResource:newImage ofType:@"png"]];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.15];
    
    clockFace.image = [UIImage imageWithContentsOfFile:nm];    
    
    [UIView commitAnimations];
}

#pragma mark - Update
- (void)updateTimeWithAnimation:(BOOL)bAnimation
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:place.timeZone]];
    //Set written date
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [self setwrittenDate:[formatter stringFromDate:[NSDate date]]];
    
    
    //Reset formatter settings
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSMutableString *str = [NSMutableString stringWithString:[formatter stringFromDate:[NSDate date]]];
    
    
    // THIS IS HANDLED BY THE LOCAL NOTIFICATIONS NOW: [self fireTest:str];
    
    
    //Set AM/PM symbol
    if ( [str rangeOfString:@"AM"].length == 0 ) [self setAMpm:@"PM"];
    else [self setAMpm:@"AM"];
    
    [str replaceOccurrencesOfString:@"AM" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [str length] )];
    [str replaceOccurrencesOfString:@"PM" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [str length] )];
    [str replaceOccurrencesOfString:@":" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [str length] )];
    [str replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [str length] )];
    
    
    char a [10];
    int num = [str length];
    if ( num == 3 ) a [0] = '0';
    for (int i = 0; i < [str length]; i++)
    {
        if ( [str length] == 3 )
            a [i+1] = [str characterAtIndex: i];
        
        else
        {
            a [i] = [str characterAtIndex: i];
            //            printf("\n a: %c\n", a[i] );
        }
    }
    
    
    [self setClockDigits: a ];
    if (bAnimation)
        [self animateDigits];
}

- (void)updateWeather
{
    
    Weather *w = place.weather;
    if (!w)
        return;
    int realTemp = [WeatherSetting isCelcius]?w.temperature:celciusToFahrenheit(w.temperature);
    self.aniFileName = [self fileNameForWeatherType:w.type];
    writtenWeather.text = w.condition;
    if ([WeatherSetting isCelcius])
        degrees.text = [NSString stringWithFormat:@"%d°C", realTemp];
    else
        degrees.text = [NSString stringWithFormat:@"%d°F", realTemp];
    self.aniFileName = [self fileNameForWeatherType:w.type];
    
    frCounter = 0;
    frZeroTime = 0;
    frameCount = [self countOfWeatherFrames:w.type];
    
    [self.weatherIcons setAnimationImages:lstAniFileName];
    [self.weatherIcons setAnimationDuration:((1.0 / FRAMES_PER_SECOND) * lstAniFileName.count)];
    [self.weatherIcons startAnimating];
}

- (void)updateWeatherSetting
{
    Weather *w = place.weather;
    if (!w)
        return;
    int realTemp = [WeatherSetting isCelcius]?w.temperature:celciusToFahrenheit(w.temperature);
    writtenWeather.text = w.condition;
    if ([WeatherSetting isCelcius])
        degrees.text = [NSString stringWithFormat:@"%d°C", realTemp];
    else
        degrees.text = [NSString stringWithFormat:@"%d°F", realTemp];
}

- (void)setClockDigits: (char *)digitArray
{

    int num = [[NSString stringWithFormat:@"%c", digitArray[0]] intValue];
    if ( num == 0 ) digit1.text = @"";
    
    else
        digit1.text = [NSString stringWithFormat:@"%c", digitArray[0]]; // [digits objectAtIndex:0];
    digit2.text = [NSString stringWithFormat:@"%c", digitArray[1]]; //[digits objectAtIndex:1];
    digit3.text = [NSString stringWithFormat:@"%c", digitArray[2]]; //[digits objectAtIndex:2];
    digit4.text = [NSString stringWithFormat:@"%c", digitArray[3]];  //[digits objectAtIndex:3];
    
    
}






- (void)setAMpm: (NSString *)theAMpm
{
    amPM.text = theAMpm;
}
- (void)setwrittenDate: (NSString *)writ;
{
    writtenDate.text = writ;
}



#pragma mark - Animation
- (void)animateDigits
{
    //Start with 0.0 opacity
    digit1.alpha = 0.0;
    digit2.alpha = 0.0;
    digit3.alpha = 0.0;
    digit4.alpha = 0.0;
    
    //Track first frame sizes
    CGRect frame1 = digit1.frame;
    CGRect frame2 = digit2.frame;
    CGRect frame3 = digit3.frame;
    CGRect frame4 = digit4.frame;
    
    //Set frames to zero
    digit1.frame = CGRectZero;
    digit2.frame = CGRectZero;
    digit3.frame = CGRectZero;
    digit4.frame = CGRectZero;
    
    
    //Run animation
    [UIView beginAnimations:@"Digit Flip Animations" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    
    
    //Fade in
    digit1.alpha = 1.0;
    digit2.alpha = 1.0;
    digit3.alpha = 1.0;
    digit4.alpha = 1.0;
    
    //Set frames to zero
    digit1.frame = frame1;
    digit2.frame = frame2;
    digit3.frame = frame3;
    digit4.frame = frame4;
    
    
    [UIView commitAnimations];
    
}

- (void)animateWeather
{
    if (!place.weather)
        return;
    
    if (aniFileName && aniFileName.length > 0)
    {
        
        if (!frCounter)
        {
            frZeroTime = CACurrentMediaTime();
            frCounter = 0;
        }
        else if (frCounter < frameCount)
        {
            CFTimeInterval elapsed = CACurrentMediaTime() - frZeroTime;
            int nextFrame = (int)(elapsed * FRAMES_PER_SECOND);
            frCounter = (nextFrame >= frameCount) ? (frameCount - 1) : nextFrame;
        }
        
        if (frCounter >= frameCount)
        {
            frCounter = 0;
            return;
        } 

        weatherIcons.image = [lstAniFileName objectAtIndex:frCounter];
        frCounter++;
    }
    else
    {
        weatherIcons.image = nil;
    }
}

#pragma mark - Dealloc
- (void)dealloc
{
    
    
    // Clock
    [lstAniFileName release];
    [digits release];
    [digit1 release];
    [digit2 release];
    [digit3 release];
    [digit4 release];
    [writtenDate release];
    [amPM release];
    [weatherIcons release];
    [writtenWeather release];
    [degrees release];
    
    [aniFileName release];
    [super dealloc];
    
}

@end
