//
//  ApiData.m
//  MBTA-APIs
//
//  Created by Steve Caine on 12/31/14.
//  Copyright (c) 2014 Steve Caine. All rights reserved.
//

#import "ApiData.h"

#import "ServiceMBTA+RestKit.h"

@implementation ApiData
// ----------------------------------------------------------------------

+ (void)get_item:(NSString *)verb
		  params:(NSDictionary *)params
		 success:(void(^)(ApiData *item))success
		 failure:(void(^)(NSError *error))failure {
	
	[ApiData request:verb params:params success:^(NSArray *data) {
		// TODO: validate return count == 1 and that item is ApiData
		if ([data count]) {
			if (success)
				success(data[0]);
		}
		else {
			NSError *error = [ServiceMBTA error_RestKit_unknown];
			if (failure)
				failure(error);
			else
				NSLog(@"%s ERROR: %@", __FUNCTION__, [error localizedDescription]);
		}
	} failure:^(NSError *error) {
		if (failure)
			failure(error);
		else
			NSLog(@"%s API call failed: %@", __FUNCTION__, [error localizedDescription]);
	}];
}

// ----------------------------------------------------------------------

+ (void)get_array:(NSString *)verb
		   params:(NSDictionary *)params
		  success:(void(^)(NSArray *array))success
		  failure:(void(^)(NSError *error))failure {
	
	[ApiData request:verb params:params success:^(NSArray *data) {
		// TODO: validate that returned item(s) are all ApiData
		if ([data count]) {
			if (success)
				success(data);
		}
		else {
			NSError *error = [ServiceMBTA error_RestKit_unknown];
			if (failure)
				failure(error);
			else
				NSLog(@"%s ERROR: %@", __FUNCTION__, [error localizedDescription]);
		}
	} failure:^(NSError *error) {
		if (failure)
			failure(error);
		else
			NSLog(@"%s API call failed: %@", __FUNCTION__, [error localizedDescription]);
	}];
}

// ----------------------------------------------------------------------
#pragma mark - locals
// ----------------------------------------------------------------------

+ (void)request:(NSString *)verb
		 params:(NSDictionary *)params
		success:(void(^)(NSArray *data))success
		failure:(void(^)(NSError *error))failure {
	
	// add apiKey and format=[json/xml]
	NSMutableDictionary *params_internal = [[ServiceMBTA default_params] mutableCopy];
	if ([params count])
		[params_internal addEntriesFromDictionary:params];
	
	[ServiceMBTA request:verb
				  params:params_internal
				 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
					 if (success) {
						 success(mappingResult.array);
					 }
				 }
				 failure:^(RKObjectRequestOperation *operation, NSError *error) {
					 if (failure)
						 failure(error);
					 else
						 NSLog(@"%s API call failed: %@", __FUNCTION__, [error localizedDescription]);
				 }];
}

// ----------------------------------------------------------------------
@end
