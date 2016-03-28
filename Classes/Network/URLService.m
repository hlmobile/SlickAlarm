//
//  URLService.m
//  eNews
//
//  Created by kgi on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "URLService.h"

@implementation URLService

static URLService *Instance = nil;

+ (URLService *) instance
{
	if (!Instance)
	{
		Instance = [URLService new];
	}
	
	return Instance;	
}

+ (void) deinit
{
	[Instance release];
	Instance = nil;
}

+ (NSString *) reqSearchPlaceUrlByQuery:(NSString *)query {
	NSString *url = [NSString stringWithFormat:@"http://where.yahooapis.com/v1/places.q('%@');count=20?appid=XeRpoVfV34GZe5V.WFipy3BxlwUq52DTevJW9oUJwkYMqKhCJDOqeC8Oog8YGFnE", query];
	
	return url;
}


+ (NSString *) reqPlaceForLocationUrlByQuery:(NSString *)query {
	NSString *url = [NSString stringWithFormat:@"http://where.yahooapis.com/geocode?q=%@&flags=T&gflags=RC&appid=XeRpoVfV34GZe5V.WFipy3BxlwUq52DTevJW9oUJwkYMqKhCJDOqeC8Oog8YGFnE", query];
	
	return url;
}
+ (NSString *) reqWeatherUrlByWoeID:(NSString *)woeID andUnit:(NSString *)unit {
	NSString *url = [NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%@&u=%@", woeID, unit];
	return url; 
}


- (id) init
{
    if (self = [super init])
    {
	}
	return self;
}

- (void) dealloc
{
    [super dealloc];
}

@end

URLService * Url()
{
	return [URLService instance];
}
