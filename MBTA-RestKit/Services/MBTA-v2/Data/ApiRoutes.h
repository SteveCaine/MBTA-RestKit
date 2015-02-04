//
//  ApiRoutes.h
//  RestKitTester
//
//  Created by Steve Caine on 12/26/14.
//  Copyright (c) 2014 Steve Caine. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ApiData.h"

// ----------------------------------------------------------------------

@interface ApiRouteDirection : ApiData
@property (  copy, nonatomic) NSNumber *ID;
@property (  copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray  *stops;
@end

// ----------------------------------------------------------------------

@interface ApiRoute : ApiData
@property (  copy, nonatomic) NSString *ID;
@property (  copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray  *directions;
- (void)addStops_success:(void(^)(ApiRoute *route))success
				 failure:(void(^)(NSError *error))failure;
@end

// ----------------------------------------------------------------------

@interface ApiRouteMode : ApiData
@property (  copy, nonatomic) NSNumber *type;
@property (  copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray  *routes;
@end

// ----------------------------------------------------------------------

@interface ApiRoutes : ApiData
@property (strong, nonatomic) NSArray *modes;
+ (void)get_success:(void(^)(ApiRoutes *data))success
			failure:(void(^)(NSError *error))failure;
- (ApiRoute *)routeByID:(NSString *)routeID;
@end

// ----------------------------------------------------------------------

@interface ApiRoutesByStop: ApiData
@property (  copy, nonatomic) NSString *stopID;
@property (  copy, nonatomic) NSString *stopName;
@property (strong, nonatomic) NSArray  *modes;
+ (void)get4stopID:(NSString *)stopID
		  success:(void(^)(ApiRoutesByStop *data))success
		  failure:(void(^)(NSError *error))failure;
@end

// ----------------------------------------------------------------------
