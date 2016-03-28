//
//  Parser.m
//  SlickTime
//
//  Created by Jin Bei on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Parser.h"
#import "Place.h"
#import "Common.h"
#import "GDataXMLNode.h"
#import "Weather.h"

@implementation Parser

+ (NSArray *)parsePlaces:(NSData *)data
{
    NSMutableArray *result = [NSMutableArray array];
    NSError *error;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    GDataXMLElement *elRoot = [doc rootElement];
    GDataXMLElement *elError = [elRoot firstElementForName:@"Error"];
    
    //Check Error
    if ([elError.stringValue intValue] != 0)
    {
        NSLog(@"Error in reading place xml data");
        NSLog(@"%@", [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding]);
        return result;
    }
    NSArray *lstPlaceElement = [elRoot elementsForName:@"place"];
    
    for (GDataXMLElement *elPlace in lstPlaceElement)
    {
        Place *item = [[[Place alloc] init] autorelease];
        NSString *locality1 = nil, *admin1 = nil, *country = nil;
        item.woeID = [elPlace firstElementForName:@"woeid"].stringValue;
        
        //Place name
        locality1 = [elPlace firstElementForName:@"locality1"].stringValue;
        if (locality1 == nil || locality1.length == 0)
            continue;
        admin1 = [elPlace firstElementForName:@"admin1"].stringValue;
        country = [elPlace firstElementForName:@"country"].stringValue;
        
        item.name = locality1;
        item.fullName = [NSString stringWithFormat:@"%@, %@, %@", locality1, admin1, country];
        
        item.latitudeCenter = [[elPlace firstElementForName:@"centroid"] firstElementForName:@"latitude"].stringValue;
        item.longitudeCenter = [[elPlace firstElementForName:@"centroid"] firstElementForName:@"longitude"].stringValue;

        [result addObject:item];
    }
    return result;
}

+ (Place *)parsePlace:(NSData *)data
{
    NSMutableArray *result = [NSMutableArray array];
    NSError *error;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    GDataXMLElement *elRoot = [doc rootElement];
    GDataXMLElement *elError = [elRoot firstElementForName:@"Error"];
    
    //Check Error
    if ([elError.stringValue intValue] != 0)
    {
        NSLog(@"Error in reading place xml data");
        NSLog(@"%@", [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding]);
        return result;
    }
    
    GDataXMLElement *elResult = [elRoot firstElementForName:@"Result"];
    Place *item = [[[Place alloc] init] autorelease];
    
    item.woeID = [elResult firstElementForName:@"woeid"].stringValue;
    item.name = [elResult firstElementForName:@"city"].stringValue;
    NSString *country = [elResult firstElementForName:@"country"].stringValue;
    item.fullName = [NSString stringWithFormat:@"%@, %@", item.name, country];
    item.latitudeCenter = [elResult firstElementForName:@"latitude"].stringValue;
    item.longitudeCenter = [elResult firstElementForName:@"longitude"].stringValue;
    item.timeZone = [elResult firstElementForName:@"timezone"].stringValue;

    return item;
}

+ (Weather *)parseWeather:(NSData *)data
{
    NSError *error;
    
    NSString *strData = [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding];
    NSLog(@"%@", strData);
    
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if (error)
    {
        NSLog(@"Error in parsing %@", error.localizedDescription);
    }
    GDataXMLElement *elRoot = [doc rootElement];
    GDataXMLElement *elChannel = [elRoot firstElementForName:@"channel"];
    GDataXMLElement *elTitle = [elChannel firstElementForName:@"title"];
    
    //Check Error
    if ([elTitle.stringValue isEqualToString:@"Yahoo! Weather - Error"])
        return nil;
    
    Weather *weather = [[[Weather alloc] init] autorelease];
    
    GDataXMLElement *elItem = [elChannel firstElementForName:@"item"];
    GDataXMLElement *elCondition = [elItem firstElementForName:@"yweather:condition"];
    
    weather.condition = [elCondition attributeForName:@"text"].stringValue;
    weather.temperature = [[elCondition attributeForName:@"temp"].stringValue intValue];
    weather.code= [[elCondition attributeForName:@"code"].stringValue intValue];
    weather.type = weatherTypeFromCode(weather.code);
    
    return weather;
}
@end
