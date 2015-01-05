//
//  ServiceMBTA.h
//  CoffeeKit
//
//	Partial implementation of MBTA v2 API to demonstrate use of RestKit
//
//	Supports these five calls:
//	http://realtime.mbta.com/developer/api/v2/servertime?api_key=<myKey>&format=[json/xml]
//	http://realtime.mbta.com/developer/api/v2/routes?api_key=<myKey>&format=[json/xml]
//	http://realtime.mbta.com/developer/api/v2/routesbystop?stop=<stop_id>&api_key=<myKey>&format=[json/xml]
//	http://realtime.mbta.com/developer/api/v2/stopsbyroute?route=<route_id>&api_key=<myKey>&format=[json/xml]
//	http://realtime.mbta.com/developer/api/v2/stopsbylocation?lat=<latitude>&lon=<longitude>&api_key=<myKey>&format=[json/xml]
//
//  Created by Steve Caine on 12/30/14.
//  Copyright (c) 2014 Steve Caine. All rights reserved.
//

#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------
extern NSString * const str_BaseURL;
extern NSString * const key_API;

// ----------------------------------------------------------------------

@interface ServiceMBTA : NSObject

+ (NSUInteger)verbCount;
+ (NSString *)verbForIndex:(NSUInteger)index;
//+ (NSUInteger)indexForVerb:(NSString *)verb;

// ----------------------------------------------------------------------

+ (NSString *)replyForVerb:(NSString *)verb;

// ----------------------------------------------------------------------

+ (NSDictionary *)default_params;

@end
