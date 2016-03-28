//
//  WeatherViewCon.h
//  SlickTime
//
//  Created by Miles Alden on 6/13/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeatherFetch, WeatherSettingsCon;

typedef enum
{
    NumWeatherImagesSunny = 0,
    NumWeatherImagesPartlyCloudy = 1,
    NumWeatherImagesRainy = 2,
    NumWeatherImagesSnowy = 3,
    NumWeatherImagesThunderstorm = 4
} NumWeatherImages;

typedef enum
{
    TempTypeFarenheit = 0,
    TempTypeCelsius = 1
}TempType;

typedef enum
{
    LocationTypeGeolocation = 0,
    LocationTypeCity = 1,
    LocationTypeZip = 2
}LocationType;

@interface WeatherViewCon : UIViewController {
    
    BOOL framesPaused;
    
    NSString *fileName;
    int frCounter, weather, lastCount, tempType, locationType;
    CFTimeInterval frZeroTime;
    
    IBOutlet UIImageView *weatherIcons;
    IBOutlet UILabel *writtenWeather, *degrees;
    IBOutlet UIButton *weatherButton;
    
    WeatherFetch *fetch;
    WeatherSettingsCon *settings;
}

- (void)setupForWeatherType: (int)weatherType;
- (IBAction)pressedWeatherButton;
- (void)animateWeather;

- (NSString *)nameOfFile;
- (void)toggleFramesPaused;
- (void)updateWeatherValues;
- (int)weatherType: (NSString *)string;


- (void)setLocationType:(LocationType)type;
- (void)setTempType: (TempType)theTempType;
- (LocationType)locationType;
- (TempType)tempType;

- (void)doneWithSettings;
- (WeatherFetch *)fetch;


@end
