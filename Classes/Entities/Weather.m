//
//  Weather.m
//  SlickTime
//
//  Created by Jin Bei on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Weather.h"

@implementation Weather

@synthesize condition, code, type, temperature;

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)dealloc
{
    [condition release];
    [super dealloc];
}

@end
