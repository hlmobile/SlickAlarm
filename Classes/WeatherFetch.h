//
//  WeatherFetch.h
//  SlickTime
//
//  Created by Miles Alden on 6/14/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kTemperatureCelcius		@"temp_C"
#define kTemperatureFarenheit	@"temp_F"
#define kWeatherDescription		@"weatherDesc"

#define kWeatherQueryType		@"type"
#define kWeatherQueryData		@"query"
#define kWeatherQueryMsg		@"msg"



@interface WeatherFetch : NSObject <CLLocationManagerDelegate, NSXMLParserDelegate> {

// this should all be private:
    NSMutableDictionary *values;
    CLLocationManager *myManager;
	
	NSURLRequest	*curRequest;
	NSURLConnection *curConnection;
	NSMutableData   *curResponse;
	BOOL logXMLContent;
    BOOL addXMLtoDict;
	NSString *curElement;
}

- (void)fetchDataForCurrentLocation;
- (NSMutableDictionary *)values;

- (void)fetchDataByLocation: (CLLocation *)location;
- (void)fetchDataByCity: (NSString *)city;
- (void)fetchDataByZip: (NSString *)zip;
- (void)fetchDataByIP_Address: (NSString *)ip;

// this should all be private:
@property (nonatomic, retain) NSURLRequest    *curRequest;
@property (nonatomic, retain) NSURLConnection *curConnection;
@property (nonatomic, retain) NSMutableData   *curResponse;
@property (nonatomic, retain) NSString        *curElement;

//- (void)dictionaryFromXMLData: (NSMutableString *)stringFromXMLBytes;

@end

/*
@class Delegates;

@interface WeatherFetch : NSObject <CLLocationManagerDelegate, NSXMLParserDelegate, UIAlertViewDelegate> {
 
    NSMutableDictionary *values;
    CLLocationManager *theManager;
    CLLocation *myLocation;
    NSMutableString *str;
    NSURLRequest *request;
    Delegates *geoCoorddelegate_, *ipDelegate, *cityDelegate, *zipDelegate;
}

- (void)weatherValuesAsDictionary;
- (NSMutableDictionary *)values;
- (void)setValues: (NSMutableDictionary *)dict;
- (void)fetchData;
- (void)dictionaryFromXMLData: (NSMutableString *)stringFromXMLBytes;

- (void)fetchDataByCity: (NSString *)city;
- (void)fetchDataByZip: (NSString *)zip;
- (void)fetchDataByIP_Address: (NSString *)ip;


- (void)formURLRequestForCity: (NSString *)city;
- (void)formURLRequestForZip: (NSString *)zip;
- (void)formURLRequestForIP_Address: (NSString *)ip;

- (void)retryConnection;

@end
*/