//
//  Parser.h
//  SlickTime
//
//  Created by Jin Bei on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Weather, Place;
@interface Parser : NSObject

+ (NSArray *)parsePlaces:(NSData *)data;
+ (Place *)parsePlace:(NSData *)data;
+ (Weather *)parseWeather:(NSData *)data;

@end
