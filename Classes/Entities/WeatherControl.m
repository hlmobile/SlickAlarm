//
//  WeatherControl.m
//  SlickTime
//
//  Created by Jin Bei on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeatherControl.h"
#import "Place.h"
#import "WeatherSetting.h"

@implementation WeatherControl
@synthesize delegate, lstRequest;

#pragma mark - static functions
+ (WeatherControl *)sharedWeatherControl
{
    static WeatherControl *instance = nil;
    
    if (instance == nil)
    {
        @synchronized(self)
        {
            if (instance == nil)
                instance = [[WeatherControl alloc] init];
        }
    }
    return instance;
}

+ (void)requestWeatherWithDelegate:(id<WeatherControlDelegate>)delegate
{
    WeatherControl *control = [WeatherControl sharedWeatherControl];
    control.delegate = delegate;
    [control sendRequestForAllPlaces];
}

+ (void)requestWeatherForNewPlacesWithDelegate:(id<WeatherControlDelegate>)delegate
{
    WeatherControl *control = [WeatherControl sharedWeatherControl];
    control.delegate = delegate;
    [control sendRequestForNewPlaces];
}

+ (void)requestWeatherWithDelegate:(id<WeatherControlDelegate>)delegate forPlace:(Place *)place
{
    WeatherControl *control = [WeatherControl sharedWeatherControl];
    control.delegate = delegate;
    [control sendRequestForPlace:place];
}

#pragma mark - Dealloc
- (void)dealloc
{
    [self cleanRequest];
    [lstRequest release];
    [super dealloc];
}

#pragma mark - Initialize
- (id)init
{
    self = [super init];
    if (self)
    {
        self.lstRequest = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Request

- (void)cleanRequest
{
    for (HttpClient *client in lstRequest)
        client.delegate = nil;
    [lstRequest removeAllObjects];
}

- (void)sendRequestForPlace:(Place *)place
{
    if (!place || place.woeID == nil)
        return;
    HttpClient *client = [[[HttpClient alloc] init] autorelease];
    client.delegate = self;
    client.tag = place.woeID;
    [client reqWeatherByWoeID:place.woeID];
    [lstRequest addObject:client];
}

- (void)sendRequestForAllPlaces
{
    [self cleanRequest];
    
    //Local Place
    Place *localPlace = [WeatherSetting localPlace];
    if (localPlace)
    {
        [self sendRequestForPlace:localPlace];
    }
    
    //All Places
    NSArray *placeList = [WeatherSetting listOfPlace];
    for (Place *place in placeList)
    {
        [self sendRequestForPlace:place];
    }
}

- (void)sendRequestForNewPlaces
{
    [self cleanRequest];
    
    //Local Place
    Place *localPlace = [WeatherSetting localPlace];
    if (localPlace)
    {
        if (!localPlace.weather)
            [self sendRequestForPlace:localPlace];
    }
    
    //All Places
    NSArray *placeList = [WeatherSetting listOfPlace];
    for (Place *place in placeList)
    {
        if (!place.weather)
            [self sendRequestForPlace:place];
    }
}

- (NSArray *)findPlacesByWoeid:(NSString *)woeid
{
    NSMutableArray *places = [NSMutableArray array];
    Place *localPlace = [WeatherSetting localPlace];
    if ([localPlace.woeID isEqualToString:woeid])
        [places addObject:localPlace];
    
    //All Places
    NSArray *placeList = [WeatherSetting listOfPlace];
    for (Place *place in placeList)
    {
        if ([place.woeID isEqualToString:woeid])
            [places addObject:place];
    }
    return places;
}

#pragma mark - DDHttpClientDelegate
- (void)HttpClientSucceeded:(HttpClient*)sender
{
    if (sender.requestType != WEATHER_REQUEST)
        return;
    
    NSString *woeid = sender.tag;
    Weather *weather = (Weather *)sender.result;
    if (weather == nil)
        return;
    NSArray *places = [self findPlacesByWoeid:woeid];
    for (Place *place in places)
    {
        place.weather = weather;
        [delegate weatherDataUpdatedForPlace:place];
    }
    
}

- (void)HttpClientFailed:(HttpClient*)sender
{
    
}

@end

