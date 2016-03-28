//
//  WeatherSetting.h
//  SlickTime
//
//  Created by Jin Bei on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Place.h"
@interface WeatherSetting : NSObject


+ (NSMutableArray *)listOfPlace;

+ (BOOL)isCelcius;
+ (void)setIsCelcius:(BOOL)val;
+ (BOOL)isWeatherEnabled;
+ (void)setWeatherEnabled:(BOOL)val;
+ (BOOL)isLocalPlaceEnabled;
+ (void)setLocalPlaceEnabled:(BOOL)val;

+ (void)saveWeatherSetting;

+ (void)loadPlaces;

+ (Place *)placeAtIndex:(int)index;

+ (Place *)localPlace;

+ (void)setLocalPlace:(Place *)place;

+ (int)countOfPlaces;

+ (void)addPlace:(Place *)place;

+ (void)removePlace:(Place *)place;

+ (void)removePlaceAtIndex:(int)index;

+ (void)movePlaceFromIndex:(int)fromIndex toIndex:(int)toIndex;
@end
