//
//  WeatherViewCon.m
//  SlickTime
//
//  Created by Miles Alden on 6/13/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "WeatherViewCon.h"
#import "SlickTimeAppDelegate.h"
#import "CentralControl.h"
#import <QuartzCore/QuartzCore.h>
#import "WeatherFetch.h"
#import "WeatherSettingsCon.h"
#import "BaseViewCon.h"

@implementation WeatherViewCon


int NumImages (int weatherType)
{
    int num;
    
    switch ()
    {
        case NumWeatherImagesThunderstorm:
            num = 36;
            break;
        case NumWeatherImagesSnowy:
            num = 40;
            break;
        case NumWeatherImagesSunny:
            num = 30;
            break;
        case NumWeatherImagesRainy:
            num = 36;
            break;
            
        default:
            break;
    }
    
    return num;
}




//const char NameOfFile (int weatherType)
//{
//    char fileName [30];
//    
//    switch (weatherType)
//    {
//        case NumWeatherImagesThunderstorm:
//            strcpy(fileName, "lightning_rain_");
//            break;
//        default:
//            break;
//    }
//    
//    return fileName;
//}



- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"\tself.view: %@\n", self.view);
    self.view.frame = CGRectMake(0, 0, 320, 240);
}


- (WeatherFetch *)fetch
{
    return fetch;
}

// Get the weather animation image number from the string in xml weather text.
- (int)weatherType: (NSString *)string
{
    int retVal;
    BOOL aDefault = NO;
    NSRange range;
    

    range = [string rangeOfString:@"sunny" options:NSCaseInsensitiveSearch];
    if ( range.length > 0 )
    {
        retVal = NumWeatherImagesSunny;
        aDefault = YES;
    }

    range = [string rangeOfString:@"rain" options:NSCaseInsensitiveSearch];
    if ( range.length > 0 )
    {
        retVal = NumWeatherImagesRainy;
        aDefault = YES;
    }
    
    range = [string rangeOfString:@"drizzle" options:NSCaseInsensitiveSearch];
    if ( range.length > 0 )
    {
        retVal = NumWeatherImagesRainy;
        aDefault = YES;
    }

    
    range = [string rangeOfString:@"Cloud" options:NSCaseInsensitiveSearch];
    if ( range.length > 0 )
    {
        retVal = NumWeatherImagesPartlyCloudy;
        aDefault = YES;
    }
    range = [string rangeOfString:@"Overcast" options:NSCaseInsensitiveSearch];
    if ( range.length > 0 )
    {
        retVal = NumWeatherImagesPartlyCloudy;
        aDefault = YES;
    }
    range = [string rangeOfString:@"Fog" options:NSCaseInsensitiveSearch];
    if ( range.length > 0 )
    {
        retVal = NumWeatherImagesPartlyCloudy;
        aDefault = YES;
    }
    range = [string rangeOfString:@"Mist" options:NSCaseInsensitiveSearch];
    if ( range.length > 0 )
    {
        retVal = NumWeatherImagesPartlyCloudy;
        aDefault = YES;
    }

    
    
    
    
//    if ( [string isEqualToString:@"Thundery outbreaks in nearby"] ||
//        [string isEqualToString:@"Patchy light rain in area with thunder"] ||
//        [string isEqualToString:@"Moderate or heavy rain in area with thunder"] ||
//        [string rangeOfString:@"thunder"].length > 0 )
    range = [string rangeOfString:@"thunder" options:NSCaseInsensitiveSearch];
    if ( range.length > 0 )
    {
        retVal = NumWeatherImagesThunderstorm;
        aDefault = YES;
    }
 

    range = [string rangeOfString:@"snow" options:NSCaseInsensitiveSearch];
    if ( range.length > 0 )
    {
        retVal = NumWeatherImagesSnowy;
        aDefault = YES;
    }
    range = [string rangeOfString:@"sleet" options:NSCaseInsensitiveSearch];
    if ( range.length > 0 )
    {
        retVal = NumWeatherImagesSnowy;
        aDefault = YES;
    }
    range = [string rangeOfString:@"Ice" options:NSCaseInsensitiveSearch];
    if ( range.length > 0 )
    {
        retVal = NumWeatherImagesSnowy;
        aDefault = YES;
    }
    range = [string rangeOfString:@"Blizzard" options:NSCaseInsensitiveSearch];
    if ( range.length > 0 )
    {
        retVal = NumWeatherImagesSnowy;
        aDefault = YES;
    }



    if ( !aDefault ) fileName = @"";
    
    return retVal;
}


// Get the actual file name prefix of the weather anmiation images.
- (NSString *)nameOfFile
{
    NSString *retVal;
    
    switch (weather) {
        case NumWeatherImagesThunderstorm:
            retVal = @"lightning_rain_";
            break;
        case NumWeatherImagesSunny:
            retVal = @"sunny";
            break;
        case NumWeatherImagesRainy:
            retVal = @"rain_cloud_";
            break;
        case NumWeatherImagesSnowy:
            retVal = @"snow_cloud";
            break;
        case NumWeatherImagesPartlyCloudy:
            retVal = @"partial_clouds-";
        default:
            retVal = @"";
            break;
    }
    return retVal;
}


- (void)setupForWeatherType: (int)weatherType;
{
    frCounter = 0;
    weather = weatherType;
    tempType = TempTypeFarenheit;
    locationType = LocationTypeGeolocation;
    
    self->fileName = [[NSString alloc] initWithString:[self nameOfFile]];  
 
    
    self->fetch = [[WeatherFetch alloc] init];
    [fetch fetchDataForCurrentLocation];

}


- (void)updateWeatherValues
{
     
    writtenWeather.text = [[fetch values] valueForKey: kWeatherDescription];
    degrees.text = [[fetch values] valueForKey:( tempType == TempTypeFarenheit ) ? kTemperatureFarenheit : kTemperatureCelcius];
    weather = [self weatherType:writtenWeather.text];
    fileName = [[self nameOfFile] retain];
    NSLog(@"\tfileName:\n%@\n", fileName);
}


- (void)animateWeather
{
    
    if ( framesPaused ) return;
    
    if (fileName && [fileName length] > 0) {

        int LastFrame = NumImages(weather) - 1;
        
        
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
            return;
        }
        
        
        NSString *theStr = [NSString stringWithFormat:@"%@%d", fileName, frCounter];
        NSString *nm = [[NSBundle mainBundle] pathForResource:theStr ofType:@"png"];
        weatherIcons.image = [UIImage imageWithContentsOfFile:nm];    
        
        
        frCounter++;
        
    } else {
     
        // no filename... 
        weatherIcons.image = nil;
    }
}


- (IBAction)pressedWeatherButton
{
    SlickTimeAppDelegate *del = APP_DELEGATE;
    
    [self toggleFramesPaused];
    
    
    self->settings = [[WeatherSettingsCon alloc] initWithNibName:@"WeatherSettingsCon" bundle:nil];
    
    settings.view.frame = CGRectMake(160, 240, 0, 0);
    [del.centralCon.baseVCon.view addSubview:settings.view];

    
    [UIView beginAnimations:@"showSettings" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    
    settings.view.frame = CGRectMake(0, 0, 320, 480);
    
    [UIView commitAnimations];
    
}

- (void)doneWithSettings
{
    SlickTimeAppDelegate *del = APP_DELEGATE;
    
    [self toggleFramesPaused];
    
    
    [UIView beginAnimations:@"removeSettings" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    
    settings.view.frame = CGRectMake(0, 0, 320, 480);
    
    [UIView commitAnimations];

    
    [settings.view removeFromSuperview];
    [settings release];
    self->settings = nil;
}


- (void)setLocationType:(LocationType)type
{
    locationType = type;
}
- (LocationType)locationType { return locationType; }


- (void)setTempType: (TempType)theTempType
{
    tempType = theTempType;
}
- (TempType)tempType { return tempType; }

- (void)toggleFramesPaused
{
    SlickTimeAppDelegate *del = APP_DELEGATE;

    if ( framesPaused )
    {
        //[del.centralCon resetFrameTimer:[del.centralCon farmViewCon] repeats:YES];
        [del.centralCon startWeatherTimer];
        framesPaused = NO;
    }
    
    else
    {
        //[del.centralCon stopFrameTimer];
        [del.centralCon removeWeatherTimer];
        framesPaused = YES;
    }
}






- (void)dealloc
{
    if ( fetch != nil )
    {
        [fetch release];
        self->fetch = nil;
    }
    
    if ( settings != nil )
    {
        [settings.view removeFromSuperview];
        [settings release];
        self->settings = nil;
    }
    
    if ( weatherIcons != nil )
    {
        [weatherIcons removeFromSuperview];
        [weatherIcons release];
        self->weatherIcons = nil;
    }

    if ( writtenWeather != nil )
    {
        [writtenWeather removeFromSuperview];
        [writtenWeather release];
        self->writtenWeather = nil;
    }

    if ( degrees != nil )
    {
        [degrees removeFromSuperview];
        [degrees release];
        self->degrees = nil;
    }

    if ( weatherButton != nil )
    {
        [weatherButton removeFromSuperview];
        [weatherButton release];
        self->weatherButton = nil;
    }
    
    if ( fileName != nil )
    {
        [fileName release];
        self->fileName = nil;
    }


    [super dealloc];
}




@end
