//
//  Delegates.m
//  SlickTime
//
//  Created by Miles Alden on 6/23/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "Delegates.h"
#import "SlickTimeAppDelegate.h"
#import "CentralControl.h"


@implementation Delegates


- (id)init
{
    self = [super init];
    if ( self != nil )
    {
        addXMLtoDict = NO;
    }
    return self;
}

- (void)setOwner:(id)object
{
    owner = object;
}
- (void)setRequest:(NSURLRequest *)theRequest
{
    self->request = [theRequest retain];
}
- (NSURLRequest *)request
{
    return request;
}

- (NSMutableString *)xmlResultString
{
    return xmlResultString;
}

- (NSMutableDictionary *)resultDict
{
    return resultDict;
}













#pragma mark -
#pragma mark Location Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    if ( manager != nil )
    {        
        // NOT SURE WHAT MILES INTENDED HERE, BUT THIS APPEARS TO BE AN INCOMPLETE
		// CONVERSION FROM WHAT WAS WORKING ON 14 JUNE, TO WHATEVER NEW SCHEME MILES
		// WAS CONTEMPLATING.  THE FOLLOWING LINE IS INVALID:
		
		// [self formURLRequest: manager.location];
        
		[manager stopUpdatingLocation];
        [owner performSelector:@selector(discardLocationManager) withObject:nil afterDelay:1.0];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    printf("\n locationManager failed.\n");
    if ( manager != nil )
    {
        [manager stopUpdatingLocation];
        [owner performSelector:@selector(discardLocationManager) withObject:nil afterDelay:1.0];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
}



@end
