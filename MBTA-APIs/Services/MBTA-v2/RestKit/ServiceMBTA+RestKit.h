//
//  ServiceMBTA+RestKit.h
//  CoffeeKit
//
//  Created by Steve Caine on 12/30/14.
//  Copyright (c) 2014 Steve Caine. All rights reserved.
//

#import "ServiceMBTA.h"

#import <RestKit/RestKit.h>

// ----------------------------------------------------------------------
@interface ServiceMBTA (RestKit)

+ (NSError *)error_RestKit_unknown;
+ (NSError *)error_RestKit_notApiData;
+ (NSError *)error_RestKit_tooManyItems;

// ----------------------------------------------------------------------
// (generic)
+ (void)request:(NSString *)verb
		 params:(NSDictionary *)params
		success:(void(^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
		failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure;

// ----------------------------------------------------------------------

+ (void)configurRestKit;

@end
// ----------------------------------------------------------------------
