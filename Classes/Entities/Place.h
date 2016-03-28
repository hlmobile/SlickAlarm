//
//  Place.h
//  SlickTime
//
//  Created by Jin Bei on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Weather;
@interface Place : NSObject <NSCoding>
{
    NSString *woeID;
    NSString *name;
    NSString *fullName;
    NSString *latitudeCenter;
    NSString *longitudeCenter;
    NSString *timeZone;
    Weather *weather;
}

@property (nonatomic, retain) NSString *woeID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *fullName;
@property (nonatomic, retain) NSString *latitudeCenter;
@property (nonatomic, retain) NSString *longitudeCenter;
@property (nonatomic, retain) NSString *timeZone;

@property (nonatomic, retain) Weather *weather;
@end
