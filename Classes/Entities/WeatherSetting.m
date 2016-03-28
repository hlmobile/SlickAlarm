//
//  WeatherSetting.m
//  SlickTime
//
//  Created by Jin Bei on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeatherSetting.h"
#import "Common.h"

@implementation WeatherSetting
#pragma mark - Static
NSMutableArray *lstPlace = nil;
Place *localPlace = nil;
BOOL isCelcius = NO;
BOOL isLocalPlaceEnabled = NO;
BOOL isWeatherEnabled = YES;



+ (NSMutableArray *)listOfPlace
{
    if (lstPlace == nil)
    {
        lstPlace = [[NSMutableArray alloc] init];
    }
    return lstPlace;
}

+ (BOOL)isCelcius
{
    return isCelcius;
}

+ (void)setIsCelcius:(BOOL)val
{
    isCelcius = val;
}

+ (BOOL)isWeatherEnabled
{
    return isWeatherEnabled;
}

+ (void)setWeatherEnabled:(BOOL)val
{
    isWeatherEnabled = val;
}

+ (BOOL)isLocalPlaceEnabled
{
    return isLocalPlaceEnabled;
}

+ (void)setLocalPlaceEnabled:(BOOL)val
{
    isLocalPlaceEnabled = val;
}

+ (void)saveWeatherSetting 
{
    
	// if there is no listOfAlarms, then create one an empty dictionary
	NSMutableArray *placeList = [WeatherSetting listOfPlace];
    
    NSDictionary *saveData = [NSDictionary dictionaryWithObjectsAndKeys:placeList, @"placelist", 
                              localPlace, @"localplace",
                              [NSNumber numberWithBool:isCelcius], @"celcius",
                              [NSNumber numberWithBool:isWeatherEnabled], @"weather",
                              [NSNumber numberWithBool:isLocalPlaceEnabled], @"localplaceenabled",
                              nil];
    
	[NSKeyedArchiver archiveRootObject: saveData toFile: weatherSettingFileName()];
    
}

+ (void)loadPlaces 
{
    NSMutableArray *placeList = [WeatherSetting listOfPlace];
    [placeList removeAllObjects];
    NSDictionary *loadData = [NSKeyedUnarchiver unarchiveObjectWithFile:weatherSettingFileName()];
    if (loadData == nil)
    {
        localPlace = [[Place alloc] init];
        return;
    }

    isCelcius = [[loadData objectForKey:@"celcius"] boolValue];
    isWeatherEnabled = [[loadData objectForKey:@"weather"] boolValue];
    isLocalPlaceEnabled = NO;// [[loadData objectForKey:@"localplaceenabled"] boolValue];
    localPlace = [[loadData objectForKey:@"localplace"] retain];
    
    NSArray *loadeList = [loadData objectForKey:@"placelist"];
    
    for (Place *place in loadeList)
        [placeList addObject:place];
}

+ (Place *)placeAtIndex:(int)index
{
    NSMutableArray *placeList = [WeatherSetting listOfPlace];
    return  [placeList objectAtIndex:index];
}


+ (Place *)localPlace
{
    return localPlace;
}

+ (void)setLocalPlace:(Place *)place
{
    if (localPlace)
        [localPlace release];
    localPlace = [place retain];
}

+ (int)countOfPlaces
{
    NSMutableArray *placeList = [WeatherSetting listOfPlace];
    return  placeList.count;
}

+ (void)addPlace:(Place *)place
{
    NSMutableArray *placeList = [WeatherSetting listOfPlace];
    [placeList addObject:place];
}

+ (void)removePlace:(Place *)place
{
    NSMutableArray *placeList = [WeatherSetting listOfPlace];
    [placeList removeObject:place];
}

+ (void)removePlaceAtIndex:(int)index
{
    NSMutableArray *placeList = [WeatherSetting listOfPlace];
    [placeList removeObjectAtIndex:index];
}

+ (void)movePlaceFromIndex:(int)fromIndex toIndex:(int)toIndex
{
    NSMutableArray *placeList = [WeatherSetting listOfPlace];
    Place *place = [[placeList objectAtIndex:fromIndex] retain];
    [placeList removeObjectAtIndex:fromIndex];
    [placeList insertObject:place atIndex:toIndex];
    [place release];
}

@end
