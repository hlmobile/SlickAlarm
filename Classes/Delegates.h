//
//  Delegates.h
//  SlickTime
//
//  Created by Miles Alden on 6/23/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Delegates : NSObject <CLLocationManagerDelegate, NSXMLParserDelegate> {
    BOOL addXMLtoDict;
    NSMutableString *xmlResultString;
    id owner;
    NSURLRequest *request;
    NSMutableDictionary *resultDict;

}

- (void)setOwner:(id)object;
- (void)setRequest:(NSURLRequest *)theRequest;
- (NSURLRequest *)request;
- (NSMutableString *)xmlResultString;
- (NSMutableDictionary *)resultDict;


@end
