//
//  WeatherControl.h
//  SlickTime
//
//  Created by Jin Bei on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
@class Place;
@protocol WeatherControlDelegate <NSObject>
@required
- (void)weatherDataUpdatedForPlace: (Place*)place;
@end

@interface WeatherControl : NSObject <DDHttpClientDelegate>

@property (nonatomic, assign) id<WeatherControlDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *lstRequest;

- (void)cleanRequest;
- (void)sendRequestForPlace:(Place *)place;
- (void)sendRequestForAllPlaces;
- (void)sendRequestForNewPlaces;

+ (WeatherControl *)sharedWeatherControl;
+ (void)requestWeatherWithDelegate:(id<WeatherControlDelegate>)delegate;
+ (void)requestWeatherWithDelegate:(id<WeatherControlDelegate>)delegate forPlace:(Place *)place;
+ (void)requestWeatherForNewPlacesWithDelegate:(id<WeatherControlDelegate>)delegate;
@end
