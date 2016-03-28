//
//  Place.m
//  SlickTime
//
//  Created by Jin Bei on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Place.h"
#import "Weather.h"

@implementation Place

@synthesize woeID, name, fullName, latitudeCenter, longitudeCenter, timeZone;
@synthesize weather;


#pragma mark - Dealloc

- (void)dealloc
{
    [woeID release];
    [name release];
    [fullName release];
    [latitudeCenter release];
    [longitudeCenter release];
    [timeZone release];
    [weather release];
    [super dealloc];
}

#pragma mark -
#pragma mark Coding


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:woeID forKey:@"woeid"];
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:fullName forKey:@"fullname"];
    [aCoder encodeObject:latitudeCenter forKey:@"latitudecenter"];
    [aCoder encodeObject:longitudeCenter forKey:@"longitudecenter"];
    [aCoder encodeObject:timeZone forKey:@"timezone"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    if( (self = [super init]) ) {
        
        self.woeID = [aDecoder decodeObjectForKey: @"woeid"];
        self.name = [aDecoder decodeObjectForKey: @"name"];
        self.fullName = [aDecoder decodeObjectForKey: @"fullname"];
        self.latitudeCenter = [aDecoder decodeObjectForKey: @"latitudecenter"];
        self.longitudeCenter = [aDecoder decodeObjectForKey: @"longitudecenter"];
        self.timeZone = [aDecoder decodeObjectForKey: @"timezone"];
        self.weather = nil;
        
    }
    
    return self;
    
}

- (id)init
{
    
    if( (self = [super init]) ) {
        
        self.woeID = nil;
        self.name = @"";
        self.fullName = @"";
        self.latitudeCenter = @"";
        self.longitudeCenter = @"";
        self.timeZone = @"";
        self.weather = nil;
        
    }
    
    return self;
    
}
@end
