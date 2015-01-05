//
//  ApiStops.m
//  RestKitTester
//
//  Created by Steve Caine on 12/26/14.
//  Copyright (c) 2014 Steve Caine. All rights reserved.
//

#import "ApiStops.h"

#import "ApiRoutes.h"

#import "ServiceMBTA_strings.h"

// ----------------------------------------------------------------------

@interface ApiStop ()
@property (  copy, nonatomic) NSString *latitude;
@property (  copy, nonatomic) NSString *longitude;
@end

@implementation ApiStop
- (CLLocationCoordinate2D) location {
	CLLocationCoordinate2D result = {0,0};
	if ([self.latitude length] && [self.longitude length]) {
		result.latitude  = [self.latitude  doubleValue];
		result.longitude = [self.longitude doubleValue];
	}
	return result;
}
- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass([self class]), self];
	
	BOOL numericID = ([self.ID integerValue] != 0);
	NSString *strID = (numericID ? [NSString stringWithFormat:@"#%@", self.ID] : [NSString stringWithFormat:@"'%@'",self.ID]);
	
	[result appendFormat:@"Stop %@ ('%@') is at %f, %f (lat,lon)", strID, self.name, self.location.latitude, self.location.longitude];
	return result;
}
@end

// ----------------------------------------------------------------------

@implementation ApiStopsByRoute


+ (void)get4route:(NSString *)routeID
		  success:(void(^)(ApiStopsByRoute *data))success
		  failure:(void(^)(NSError *error))failure {
	NSDictionary *params = @{ param_route : routeID };
	
	[ApiData get_item:verb_stopsbyroute params:params success:^(ApiData *item) {
		if (success) {
			ApiStopsByRoute *stopsbyroute = (ApiStopsByRoute *)item;
			stopsbyroute.routeID = routeID;
			success(stopsbyroute);
		}
	} failure:^(NSError *error) {
		if (failure)
			failure(error);
		else
			NSLog(@"%s API call failed: %@", __FUNCTION__, [error localizedDescription]);
	}];
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass([self class]), self];
	if ([self.directions count]) {
		int index = 0;
		for (ApiRouteDirection *direction in self.directions) {
			[result appendFormat:@"\n%2i: %@", index++, direction];
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------

@implementation ApiStopsByLocation

+ (void)get4location:(CLLocationCoordinate2D)location
			 success:(void(^)(ApiStopsByLocation *data))success
			 failure:(void(^)(NSError *error))failure {
	NSDictionary *params = @{
							 param_lat : [NSNumber numberWithFloat:location.latitude],
							 param_lon : [NSNumber numberWithFloat:location.longitude]
							};
	
	[ApiData get_item:verb_stopsbylocation params:params success:^(ApiData *item) {
		if (success) {
			ApiStopsByLocation *stopsbylocation = (ApiStopsByLocation *)item;
			success(stopsbylocation);
		}
	} failure:^(NSError *error) {
		if (failure)
			failure(error);
		else
			NSLog(@"%s API call failed: %@", __FUNCTION__, [error localizedDescription]);
	}];
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass([self class]), self];
	if ([self.stops count]) {
		int index = 0;
		for (ApiStop *stop in self.stops) {
			[result appendFormat:@"\n%2i: %@", index++, stop];
		}
	}
	return result;
}

// ----------------------------------------------------------------------

@end
