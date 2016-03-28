//
//  HttpClient.h
//  eNews
//
//  Created by kgi on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TIMEOUT_SEC		20.0

typedef enum _tagHTTPClientRequestType {
	SEARCHLOCATION_REQUEST,
	GEONAME_REQUEST,
	WEATHER_REQUEST
	
} HTTPClientRequestType;

@class HttpClient;
@protocol DDHttpClientDelegate
- (void)HttpClientSucceeded:(HttpClient*)sender;
- (void)HttpClientFailed:(HttpClient*)sender;
@end

@interface HttpClient : NSObject {
	NSURLConnection		*connection;
	NSMutableData		*receivedData;
	int					statusCode;
	BOOL				contentTypeIsXml;
	
	NSObject		*result;
	int					totalCount;
	
	NSString			*identifier;
	HTTPClientRequestType		requestType;
	id<DDHttpClientDelegate>	delegate;
	
	NSString*			reqUrl;
}

@property (retain) NSMutableData *receivedData;
@property (readonly) int statusCode;
@property (assign) id<DDHttpClientDelegate> delegate;
@property (retain) 	NSObject* result;
@property (assign) 	int totalCount;
@property (copy) 	NSString*	identifier;
@property (assign) HTTPClientRequestType requestType;
@property (nonatomic, retain) NSString *tag;

- (void)requestGET:(NSString*)url;
- (void)requestPOST:(NSString*)url body:(NSString*)body;
- (void)requestGET:(NSString*)url username:(NSString*)username password:(NSString*)password;
- (void)requestPOST:(NSString*)url body:(NSString*)body username:(NSString*)username password:(NSString*)password;

- (void)cancel;
- (void)cancelDelegate;
- (void)requestSucceeded;
- (void)requestFailed:(NSError*)error;
- (void)reset;
// Custom functions
- (void) reqSearchPlaceByTerm:(NSString *)term;
- (void)reqPlaceByLocation:(NSString*)location;
- (void)reqWeatherByWoeID:(NSString*)woeID;


@end
