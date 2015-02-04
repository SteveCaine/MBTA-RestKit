//
//  ApiTime.h
//  RestKitTester
//
//  Created by Steve Caine on 12/26/14.
//  Copyright (c) 2014 Steve Caine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

#import "ApiData.h"

// ----------------------------------------------------------------------

@interface ApiTime : ApiData

+ (void)get_success:(void(^)(ApiTime *data))success
			failure:(void(^)(NSError *error))failure;

- (NSDate *)time;

@end

// ----------------------------------------------------------------------
