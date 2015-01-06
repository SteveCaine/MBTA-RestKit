//
//  ApiData.h
//  MBTA-APIs
//
//  Created by Steve Caine on 12/31/14.
//  Copyright (c) 2014 Steve Caine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiData : NSObject

+ (void)get_item:(NSString *)verb
		  params:(NSDictionary *)params
		  success:(void(^)(ApiData *item))success
		  failure:(void(^)(NSError *error))failure;

+ (void)get_array:(NSString *)verb
		   params:(NSDictionary *)params
		  success:(void(^)(NSArray *array))success
		  failure:(void(^)(NSError *error))failure;

@end
