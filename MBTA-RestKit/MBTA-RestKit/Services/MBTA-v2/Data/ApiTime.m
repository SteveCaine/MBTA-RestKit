//
//  ApiTime.m
//  RestKitTester
//
//  Created by Steve Caine on 12/26/14.
//  Copyright (c) 2014 Steve Caine. All rights reserved.
//

#import "ApiTime.h"

#import "ServiceMBTA_strings.h"

// ----------------------------------------------------------------------

@interface ApiTime ()
@property (  copy, nonatomic) NSNumber *server_dt;
@end

// ----------------------------------------------------------------------

@implementation ApiTime

+ (void)get_success:(void(^)(ApiTime *data))success
			failure:(void(^)(NSError *error))failure {
	[ApiData get_item:verb_servertime params:nil success:^(ApiData *item) {
		// TODO: validate that returned item IS ApiTime
		if (success)
			success((ApiTime *)item);
	} failure:^(NSError *error) {
		if (failure)
			failure(error);
		else
			NSLog(@"%s API call failed: %@", __FUNCTION__, [error localizedDescription]);
	}];
}

- (NSDate *)time {
	NSDate *result = nil;
	if (self.server_dt != nil)
		result = [NSDate dateWithTimeIntervalSince1970:[self.server_dt integerValue]];
	return result;
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass([self class]), self];
	[result appendFormat:@" time = %@", [self time]];
	return result;
}

@end

// ----------------------------------------------------------------------
