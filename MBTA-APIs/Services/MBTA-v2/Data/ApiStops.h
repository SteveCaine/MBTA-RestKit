//
//  ApiStops.h
//  RestKitTester
//
//  Created by Steve Caine on 12/26/14.
//  Copyright (c) 2014 Steve Caine. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ApiData.h"
#import "ApiRoutes.h"

// to save us from adding entire CL framework just for this one typedef
// (seems 2nd __has_include() should be FALSE!?)
#if defined(__has_include) && __has_include(<CoreLocation/CoreLocation.h>)
typedef double CLLocationDegrees;
typedef struct { CLLocationDegrees latitude; CLLocationDegrees longitude; } CLLocationCoordinate2D;
#endif

// ----------------------------------------------------------------------

@interface ApiStop : ApiData
@property (  copy, nonatomic) NSNumber *order;
@property (  copy, nonatomic) NSString *ID;
@property (  copy, nonatomic) NSString *name;
@property (  copy, nonatomic) NSString *station;
@property (  copy, nonatomic) NSString *station_name;
// for stopsbylocation - stop's distance in miles
// from location given in original request
@property (  copy, nonatomic) NSNumber *distance;
- (CLLocationCoordinate2D) location;
@end

// ----------------------------------------------------------------------

@interface ApiStopsByRoute : ApiData

@property (  copy, nonatomic) NSString *routeID; // from request
@property (strong, nonatomic) NSArray *directions;

+ (void)get4route:(NSString *)routeID
		  success:(void(^)(ApiStopsByRoute *data))success
		  failure:(void(^)(NSError *error))failure;
@end

// ----------------------------------------------------------------------

@interface ApiStopsByLocation : ApiData
@property (strong, nonatomic) NSArray *stops;

+ (void)get4location:(CLLocationCoordinate2D)location
			 success:(void(^)(ApiStopsByLocation *data))success
			 failure:(void(^)(NSError *error))failure;
@end

// ----------------------------------------------------------------------
