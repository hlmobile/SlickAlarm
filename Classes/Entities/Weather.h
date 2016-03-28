//
//  Weather.h
//  SlickTime
//
//  Created by Jin Bei on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
@interface Weather : NSObject
{
    NSString *condition;
    int code;
    WeatherType type;
    int temperature;
}

@property (nonatomic, retain) NSString *condition;
@property (nonatomic, assign) int code;
@property (nonatomic, assign) WeatherType type;
@property (nonatomic, assign) int temperature;

@end
