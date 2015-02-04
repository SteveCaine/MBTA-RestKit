//
//  ServiceMBTA+RestKit.m
//  MBTA-APIs
//
//  Created by Steve Caine on 12/30/14.
//  Copyright (c) 2014 Steve Caine. All rights reserved.
//

#import "ServiceMBTA+RestKit.h"
#import "ServiceMBTA_strings.h"

#import "AppDelegate.h"

#if CONFIG_useXML
#import "RKXMLReaderSerialization.h"
#endif

#import "ApiRoutes.h"
#import "ApiStops.h"
#import "ApiTime.h"

#define error_unknown		@"Service MBTA+RestKit: Request failed, unknown error."
#define error_notApiData	@"Service MBTA+RestKit: Request returned invalid data type(s)."
#define error_tooManyItems	@"Service MBTA+RestKit: Request for single item returned multiple items."

#pragma mark -

@implementation ServiceMBTA (RestKit)

// ----------------------------------------------------------------------

+ (NSError *)error_RestKit_unknown {
	return [[NSError alloc] initWithDomain:MBTA_APIs_ErrorDomain
									  code:-1
								  userInfo:@{ NSLocalizedDescriptionKey : error_unknown }];
}

+ (NSError *)error_RestKit_notApiData {
	return [[NSError alloc] initWithDomain:MBTA_APIs_ErrorDomain
									  code:-1
								  userInfo:@{ NSLocalizedDescriptionKey : error_notApiData }];
}

+ (NSError *)error_RestKit_tooManyItems {
	return [[NSError alloc] initWithDomain:MBTA_APIs_ErrorDomain
									  code:-1
								  userInfo:@{ NSLocalizedDescriptionKey : error_tooManyItems }];
}

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------
//   verb: servertime, routes, routesbystop, stopsbyroute, stopsbylocation
// params: api_key=<key>, format=[json/xml] (always)
//		   stop=<stop_id> for 'routesbystop'
//		   route=<route_id> for 'stopsbyroute'
//		   lat=<latitude>&lon=<longitude> for 'stopsbylocation'

+ (void)request:(NSString *)verb
		 params:(NSDictionary *)params
		success:(void(^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
		failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure {

	[[RKObjectManager sharedManager] getObjectsAtPath:verb
										   parameters:params
											  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
#if DEBUG_logHeadersHTTP
												  NSURLRequest *request  = operation.HTTPRequestOperation.request;
												  
												  NSString *str_request = [request.URL absoluteString];
												  NSLog(@"\n\nrequest = '%@'\n\n", str_request);
												  
												  NSLog(@"\n\n requestHeaders = %@\n\n", [request allHTTPHeaderFields]);
												  
												  NSURLResponse *response = operation.HTTPRequestOperation.response;
												  if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
													  NSDictionary *responseHeaders = [((NSHTTPURLResponse *) response) allHeaderFields];
													  NSLog(@"\n\n responseHeaders = %@\n\n", responseHeaders);
												  }
#endif
												  if (success) {
													  success(operation, mappingResult);
												  }
											  }
											  failure:^(RKObjectRequestOperation *operation, NSError *error) {
												  if (failure)
													  failure(operation, error);
												  else
													  NSLog(@"%s API call failed: %@", __FUNCTION__, [error localizedDescription]);
											  }];
}

// ----------------------------------------------------------------------

+ (void)configurRestKit {
	// initialize AFNetworking HTTPClient
	NSURL *baseURL = [NSURL URLWithString:str_BaseURL];
	AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
	
	// initialize RestKit for entire app, use -sharedManager throughout
	RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
	
#if CONFIG_useXML
	// add support for reading XML responses
	[RKMIMETypeSerialization registerClass:[RKXMLReaderSerialization class] forMIMEType:@"application/xml"];
#endif
	
	// both 'setup object mappings'
	//  and 'define relationship mapping'
	// are done w/in [self responseDescriptors]
	
	// register mappings with the provider using response descriptors
	[objectManager addResponseDescriptorsFromArray:[self responseDescriptors]];
	
	if ([str_key_API length] == 0) {
		NSString *title = @"Missing API Key";
		NSString *message = @"You must provide a valid MBTA API key at the top of “ServiceMBTA.m”!";
		[AppDelegate alertForDelegate:nil title:title message:message];
	}
}

// ----------------------------------------------------------------------
#pragma mark - OBJECT MAPPINGS
// ----------------------------------------------------------------------

+ (RKObjectMapping *)objMapping_ApiTime {
	static RKObjectMapping *result = nil;
	if (result == nil) {
		result = [RKObjectMapping mappingForClass:[ApiTime class]];
		[result addAttributeMappingsFromArray:@[ key_server_dt ]];
	}
	return result;
}

// ----------------------------------------------------------------------

+ (RKObjectMapping *)objMapping_ApiRoute {
	static RKObjectMapping *result = nil;
	if (result == nil) {
		result = [RKObjectMapping mappingForClass:[ApiRoute class]];
		[result addAttributeMappingsFromDictionary:@{
													 key_route_id	: @"ID",
													 key_route_name	: @"name"
													 }];
	}
	return result;
}

// ----------------------------------------------------------------------

+ (RKObjectMapping *)objMapping_ApiRouteMode {
	static RKObjectMapping *result = nil;
	if (result == nil) {
		result = [RKObjectMapping mappingForClass:[ApiRouteMode class]];
		[result addAttributeMappingsFromDictionary:@{
													 key_route_type	: @"type",
													 key_mode_name	: @"name"
													 }];
		[result addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:key_route toKeyPath:@"routes" withMapping:[self objMapping_ApiRoute]]];
	}
	return result;
}

// ----------------------------------------------------------------------

+ (RKObjectMapping *)objMapping_ApiRoutes {
	static RKObjectMapping *result = nil;
	if (result == nil) {
		result = [RKObjectMapping mappingForClass:[ApiRoutes class]];
		[result addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:key_mode toKeyPath:@"modes" withMapping:[self objMapping_ApiRouteMode]]];
	}
	return result;
}

// ----------------------------------------------------------------------

+ (RKObjectMapping *)objMapping_ApiStop {
	static RKObjectMapping *result = nil;
	if (result == nil) {
		result = [RKObjectMapping mappingForClass:[ApiStop class]];
		[result addAttributeMappingsFromDictionary:@{
													 key_stop_order			: @"order",
													 key_stop_id			: @"ID",
													 key_stop_name			: @"name",
													 key_parent_station		: @"station",
													 key_parent_station_name: @"station_name",
													 key_stop_lat			: @"latitude",
													 key_stop_lon			: @"longitude",
													 key_distance			: @"distance"
													 }];
	}
	return result;
}

// ----------------------------------------------------------------------

+ (RKObjectMapping *)objMapping_ApiRouteDirection {
	static RKObjectMapping *result = nil;
	if (result == nil) {
		result = [RKObjectMapping mappingForClass:[ApiRouteDirection class]];
		[result addAttributeMappingsFromDictionary:@{
													 key_direction_id		: @"ID",
													 key_direction_name		: @"name"
													 }];
		[result addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:key_stop toKeyPath:@"stops" withMapping:[self objMapping_ApiStop]]];
	}
	return result;
}

// ----------------------------------------------------------------------

+ (RKObjectMapping *)objMapping_ApiRoutesByStop {
	static RKObjectMapping *result = nil;
	if (result == nil) {
		result = [RKObjectMapping mappingForClass:[ApiRoutesByStop class]];
		[result addAttributeMappingsFromDictionary:@{
													 key_stop_id	: @"stopID",
													 key_stop_name	: @"stopName"
													 }];
		[result addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:key_mode toKeyPath:@"modes" withMapping:[self objMapping_ApiRouteMode]]];
	}
	return result;
}

// ----------------------------------------------------------------------
// NOTE: if 'CONFIG_stops_update_route' is YES, we never create/use the ApiStopsByRoute class
+ (RKObjectMapping *)objMapping_ApiStopsByRoute {
	static RKObjectMapping *result = nil;
	if (result == nil) {
		result = [RKObjectMapping mappingForClass:[ApiStopsByRoute class]];
		[result addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:key_direction toKeyPath:@"directions" withMapping:[self objMapping_ApiRouteDirection]]];
	}
	return result;
}

// ----------------------------------------------------------------------

+ (RKObjectMapping *)objMapping_ApiStopsByLocation {
	static RKObjectMapping *result = nil;
	if (result == nil) {
		result = [RKObjectMapping mappingForClass:[ApiStopsByLocation class]];
		[result addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:key_stop toKeyPath:@"stops" withMapping:[self objMapping_ApiStop]]];
	}
	return result;
}

// ----------------------------------------------------------------------
#pragma mark - RESPONSE DESCRIPTORS
// ----------------------------------------------------------------------

+ (NSArray *)responseDescriptors {
	static NSMutableArray *result;
	if (result == nil) {
		result = [NSMutableArray array];
		
		// root objects for our requests
		NSArray *objMappings = @[
								 [self objMapping_ApiTime],
								 [self objMapping_ApiRoutes],
								 [self objMapping_ApiRoutesByStop],
#if CONFIG_stops_update_route
								 [self objMapping_ApiRouteDirection],	// stopsbyroute updates an existing ApiRoute object
#else
								 [self objMapping_ApiStopsByRoute],		// stopsbyroute creates a new ApiStopsByRoute object
#endif
								 [self objMapping_ApiStopsByLocation]
								 ];
		
		for (NSUInteger index = 0; index < [self verbCount]; ++index) {
			NSString *verb = [self verbForIndex:index];
			NSString *reply = [self replyForVerb:verb];
			RKObjectMapping *objMapping = objMappings[index];

//			NSLog(@"%2i: verb = '%@', reply = '%@', mapping = %@", index, verb, reply, objMapping);

			[result addObject:[RKResponseDescriptor responseDescriptorWithMapping:objMapping
																		   method:RKRequestMethodGET
																	  pathPattern:verb
																		  keyPath:reply
																	  statusCodes:[NSIndexSet indexSetWithIndex:200]]];
		}
	}
	return result;
}

// ----------------------------------------------------------------------
@end
