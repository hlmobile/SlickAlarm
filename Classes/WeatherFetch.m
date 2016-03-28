//
//  WeatherFetch.m
//  SlickTime
//
//  Created by Miles Alden on 6/14/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "WeatherFetch.h"
#import "SlickTimeAppDelegate.h"
#import "CentralControl.h"
#import "WeatherViewCon.h"
#import "TimeFaceCon.h"
#import "Delegates.h"


NSString * StringByEncodingForUrl(NSString *old)
{
	return [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,  (__bridge CFStringRef)old,  NULL,  (CFStringRef)@"!*'();:@&amp;=+$,/?%#[]",  kCFStringEncodingUTF8) autorelease];
}



@implementation WeatherFetch

@synthesize curElement;
@synthesize curResponse;
@synthesize curRequest;
@synthesize curConnection;


//http://free.worldweatheronline.com/feed/weather.ashx?q=37.29,121.94&format=xml&num_of_days=2&key=a63e7e35b7165106111406

- (void)fetchDataForCurrentLocation
{
    self->values = [[NSMutableDictionary alloc] init];

    self->myManager = [[CLLocationManager alloc] init];
    
    [myManager setDelegate:self];
    [myManager setDesiredAccuracy: kCLLocationAccuracyKilometer];
    [myManager startUpdatingLocation];
	
}

- (void)fetchDataWithURL: (NSURL *)url
{
	if (curConnection)
		[curConnection cancel];
		
	self.curResponse = nil;
    self.curRequest = [NSURLRequest requestWithURL:url];
    self.curConnection = [NSURLConnection connectionWithRequest: curRequest delegate:self];
}

- (void)fetchDataByLocation: (CLLocation *)location
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://free.worldweatheronline.com/feed/weather.ashx?q=%f,%f&format=xml&num_of_days=2&key=a63e7e35b7165106111406", location.coordinate.latitude, location.coordinate.longitude]];
	[self fetchDataWithURL: url];
}


- (void)fetchDataByCity: (NSString *)city
{
	NSString *encodedCity = StringByEncodingForUrl(city);
	NSLog(@"\"%@\" encoded as: \"%@\"", city, encodedCity);
	
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://free.worldweatheronline.com/feed/weather.ashx?q=%@&format=xml&num_of_days=2&key=a63e7e35b7165106111406", encodedCity]];
    
	[self fetchDataWithURL: url];
}

- (void)fetchDataByZip: (NSString *)zip
{
	NSString *encodedZip = StringByEncodingForUrl(zip);
	NSLog(@"\"%@\" encoded as: \"%@\"", zip, encodedZip);
	
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://free.worldweatheronline.com/feed/weather.ashx?q=%@&format=xml&num_of_days=2&key=a63e7e35b7165106111406", zip]];
    
	[self fetchDataWithURL: url];
}

- (void)fetchDataByIP_Address: (NSString *)ip
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://free.worldweatheronline.com/feed/weather.ashx?q=%@&format=xml&num_of_days=2&key=a63e7e35b7165106111406", ip]];
    
	[self fetchDataWithURL: url];
}



- (NSMutableDictionary *)values
{
    //if ( values == nil ) return nil;
    return values;
}

- (void)setValues: (NSMutableDictionary *)dict
{
    self->values = [dict retain];
}











#pragma mark -
#pragma mark Location Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    
    //[self formURLRequest: manager.location];
    
    [manager stopUpdatingLocation];
	if (manager == myManager) {
		myManager = nil;
		// can't release the location manager until after it has actually stopped
		// updating it's locations, so sechedule the release for a bit later...
		[manager performSelector:@selector(release) withObject: nil afterDelay: 0.2];
	}
	[self fetchDataByLocation: newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //printf("\n locationManager failed.\n");
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
}

#pragma mark -
#pragma mark URL Connection Delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"didReceiveResponse: called.");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    NSLog(@"\nconnection failed\n");
	
	if (connection == self.curConnection)
		self.curConnection = nil;
    
    SlickTimeAppDelegate *del = (SlickTimeAppDelegate *)APP_DELEGATE;
    [[del.centralCon clockFace] setClockFaceImage:@"time_face@2x~iphone"];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{    
	int len = [data length];
	NSLog(@"didReceiveData: called with %d bytes of data", len);
	
	if (curResponse == nil) {
		self.curResponse = [NSMutableData dataWithData: data];
	} else {
		[curResponse appendData: data];
	}
}	
	

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	int len = [curResponse length];
	
	if (len > 1 && connection == self.curConnection) {
		NSLog(@"\nParsing weather data:");
		NSXMLParser *parser = [[NSXMLParser alloc] initWithData:curResponse];
		
		self.curConnection = nil;
		self.curRequest = nil;
		self.curResponse = nil;
		
		[parser setDelegate:self];
		[parser setShouldProcessNamespaces:YES];
		[parser setShouldReportNamespacePrefixes:YES];
		[parser setShouldResolveExternalEntities:YES];
		[parser parse];
		[parser release];
	}		
}


#pragma mark -
#pragma mark XMLParser Delegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ( [elementName isEqualToString: kTemperatureCelcius] ||
        [elementName isEqualToString: kTemperatureFarenheit] ||
        [elementName isEqualToString: kWeatherDescription] ) {
		
		addXMLtoDict = YES;
		logXMLContent = NO;
		self.curElement = elementName;
		
    } else if ([elementName isEqualToString: kWeatherQueryType] ||
			   [elementName isEqualToString: kWeatherQueryData] ||
			   [elementName isEqualToString: kWeatherQueryMsg] ) { 

		addXMLtoDict = NO;
		logXMLContent = YES;
		self.curElement = elementName;

	} else {
		
		//NSLog(@"Element: %@" , elementName);
		addXMLtoDict = NO;
		logXMLContent = NO;
		self.curElement = elementName;
    
	}
}


- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
	if (values == nil)
		self->values = [[NSMutableDictionary alloc] init];

 	if ( addXMLtoDict ) {
		NSString *string = [[NSString alloc] initWithBytes:[CDATABlock bytes] length:[CDATABlock length] encoding:NSUTF8StringEncoding];
		[values setValue: string forKey: curElement];
        NSLog(@"Adding: Key: %@  Data: %@", curElement, string);
		[string release];
	}  else if (logXMLContent) {
		NSString *string = [[NSString alloc] initWithBytes:[CDATABlock bytes] length:[CDATABlock length] encoding:NSUTF8StringEncoding];
		NSLog(@"Info:   %@: %@", curElement, string);
		[string release];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (values == nil)
		self->values = [[NSMutableDictionary alloc] init];
    
    if ( addXMLtoDict ) {
        NSLog(@"Adding: Key: %@  Data: %@", curElement, string);
        [values setValue: string forKey: curElement];
    } else if (logXMLContent) {
		NSLog(@"Info:   %@: %@", curElement, string);
	}

}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    if ( values != nil )
    {
        [values release];
        self->values = nil;
    }
    
	self->values = [[NSMutableDictionary alloc] init];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	if ([values count] == 0) {
		NSLog(@"No weather data available, not updating.");
	} else {
		SlickTimeAppDelegate *del = APP_DELEGATE;
		NSLog(@"Updating Weather...");
		[[del.centralCon  weatherViewCon] updateWeatherValues];
	}
}




- (void)retryConnection
{
	if (self.curRequest != nil && self.curConnection == nil) {
		self.curConnection = [NSURLConnection connectionWithRequest: curRequest delegate: self];
	}
}


- (void)dealloc
{
    
    if ( myManager != nil )
    {
        [myManager stopUpdatingLocation];
        [myManager stopUpdatingHeading];
        [myManager stopMonitoringSignificantLocationChanges];
		[myManager performSelector:@selector(release) withObject: nil afterDelay: 0.2];
        self->myManager = nil;
    }
    
	if ( curConnection != nil )
	{
		[curConnection cancel];
		self.curConnection = nil;
	}
	self.curRequest = nil;
	self.curResponse = nil;
	self.curElement = nil;
	
    if ( values != nil )
    {
        [values removeAllObjects];
		[values release];
        self->values = nil;
    }
    
	
    [super dealloc];
}
      

@end
