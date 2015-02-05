//
//  ApiRoute.m
//  RestKitTester
//
//  Created by Steve Caine on 12/26/14.
//  Copyright (c) 2014 Steve Caine. All rights reserved.
//

#import "ApiRoutes.h"

#import "ApiStops.h"

#import "ServiceMBTA_strings.h"

// ----------------------------------------------------------------------

@implementation ApiRouteDirection

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass([self class]), self];
	[result appendFormat:@"\n\tid = '%@', name = '%@'", self.ID, self.name];
	if ([self.stops count]) {
		int index = 0;
		for (ApiStop *stop in self.stops) {
			NSString *stop_order = ([stop.order isKindOfClass:[NSNumber class]]	? [NSString stringWithFormat:@"%2li", (long)[stop.order integerValue]] : [stop.order description]);
			[result appendFormat:@"\n\t%2i: %@: stop %@ (%@) is at %f, %f (lat/lon)", index++, stop_order, stop.ID, stop.name, [stop location].latitude, [stop location].longitude];
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------

@implementation ApiRoute

- (void)addStops_success:(void(^)(ApiRoute *route))success
				 failure:(void(^)(NSError *error))failure {
	NSDictionary *params = @{ param_route : self.ID };
	
	[ApiData get_array:verb_stopsbyroute params:params success:^(NSArray *array) {
		if (success) {
			// TODO: validate that returned items ARE ApiRouteDirections
			self.directions = array;
			success(self);
		}
	} failure:^(NSError *error) {
		NSLog(@"%s API call failed: %@", __FUNCTION__, [error localizedDescription]);
	}];
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass([self class]), self];
	
	BOOL numericID = ([self.ID integerValue] != 0);
	NSString *strID = (numericID ? [NSString stringWithFormat:@"#%@", self.ID] : [NSString stringWithFormat:@"'%@'",self.ID]);
	
	[result appendFormat:@"\n\t\t id = '%@', name = '%@'", strID, self.name];
	if ([self.directions count]) {
		int index = 0;
		for (ApiRouteDirection *direction in self.directions) {
			[result appendFormat:@"\n\t%2i: direction '%@' has %lu stops", index++, direction.name, (unsigned long)[direction.stops count]];
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------

@implementation ApiRouteMode

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass([self class]), self];
	[result appendFormat:@"\n\ttype = '%@', name = '%@'", self.type, self.name];
	if ([self.routes count]) {
		int index = 0;
		for (ApiRoute *route in self.routes) {
			
			BOOL numericID = ([route.ID integerValue] != 0);
			NSString *strID = (numericID ? [NSString stringWithFormat:@"#%@", route.ID] : [NSString stringWithFormat:@"'%@'",route.ID]);
			
			[result appendFormat:@"\n\t%2i: route %@ (%@)", index++, strID, route.name];
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------

@implementation ApiRoutes

+ (void)get_success:(void(^)(ApiRoutes *data))success
			failure:(void(^)(NSError *error))failure {
	[ApiData get_item:verb_routes params:nil success:^(ApiData *item) {
		// TODO: validate that returned item IS ApiRoutes
		if (success)
			success((ApiRoutes *)item);
	} failure:^(NSError *error) {
		if (failure)
			failure(error);
		else
			NSLog(@"%s API call failed: %@", __FUNCTION__, [error localizedDescription]);
	}];
}

- (ApiRoute *)routeByID:(NSString *)routeID {
	ApiRoute *result = nil;
	for (ApiRouteMode * mode in self.modes) {
		for (ApiRoute *route in mode.routes) {
			if ([route.ID isEqualToString:routeID]) {
				result = route;
				break;
			}
			if (result)
				break;
		}
	}
	return result;
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass([self class]), self];
	if ([self.modes count]) {
		int index = 0;
		for (ApiRouteMode *mode in self.modes) {
			[result appendFormat:@"\n%2i: %@", index++, mode];
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------

@implementation ApiRoutesByStop

+ (void)get4stopID:(NSString *)stopID
		   success:(void(^)(ApiRoutesByStop *data))success
		   failure:(void(^)(NSError *error))failure {
	NSDictionary *params = @{ param_stop : stopID };
	
	[ApiData get_item:verb_routesbystop params:params success:^(ApiData *item) {
		// TODO: validate that returned item IS ApiRoutesByStop
		if (success)
			success((ApiRoutesByStop *)item);
	} failure:^(NSError *error) {
		if (failure)
			failure(error);
		else
			NSLog(@"%s API call failed: %@", __FUNCTION__, [error localizedDescription]);
	}];
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass([self class]), self];
	[result appendFormat:@"\n\tstop = '%@', name = '%@'", self.stopID, self.stopName];
	if ([self.modes count]) {
		int index = 0;
		for (ApiRouteMode *mode in self.modes) {
			[result appendFormat:@"\n%2i: %@", index++, mode];
		}
	}
	return result;
}

@end


// ----------------------------------------------------------------------






