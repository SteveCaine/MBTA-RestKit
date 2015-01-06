//
//  ServiceMBTA.m
//  MBTA-APIs
//
//  Created by Steve Caine on 12/30/14.
//  Copyright (c) 2014 Steve Caine. All rights reserved.
//

#import "ServiceMBTA.h"

#import "ServiceMBTA_strings.h"

#if 0
	NSString * const str_BaseURL	= @"http://54.81.189.97/developer/api/v2/";		// test API
	#define key_MBTA_v2_API			  @"wX9NwuHnZU2ToO7GmGR9uw";					// test dev key
#else
	NSString * const str_BaseURL	= @"http://realtime.mbta.com/developer/api/v2/";// live API
	// your private key to the MBTA v2 API is in this file
	#import "ServiceMBTA_sensitive.h"
#endif

// --------------------------------------------------
// see "ServiceMBTA_strings.h" for list of #define's for each verb
enum {
	e_servertime,
	e_routes,
	e_routesbystop,
	e_stopsbyroute,
	e_stopsbylocation,
	e_schedulebystop,
	e_schedulebyroute,
	e_schedulebytrip,
	e_predictionsbyroute,
	e_predictionsbystop,
	e_predictionsbytrip,
	e_vehiclesbyroute,
	e_vehiclesbytrip,
	e_alerts,
	e_alertsbyroute,
	e_alertsbystop,
	e_alertbyid,
	e_alertheaders,
	e_alertheadersbyroute,
	e_alertheadersbystop
};

static NSString *verbs[] = {
	@"servertime",			// 0
	@"routes",
	@"routesbystop",
	@"stopsbyroute",
	@"stopsbylocation"
	// rest disabled until we have code to exercise them
/** /
	,
	@"schedulebystop",		// 5
	@"schedulebyroute",
	@"schedulebytrip",
	@"predictionsbyroute",
	@"predictionsbystop",
	@"predictionsbytrip",	// 10
	@"vehiclesbyroute",
	@"vehiclesbytrip",
	@"alerts",
	@"alertsbyroute",
	@"alertsbystop",		// 15
	@"alertbyid",
	@"alertheaders",
	@"alertheadersbyroute",
	@"alertheadersbystop"
/ **/
};
static NSUInteger num_verbs = sizeof(verbs)/sizeof(verbs[0]);

static NSString *json_replys[] = {
	@"",
	@"",
	@"",
#if CONFIG_stops_update_route
	@"direction",
#else
	@"",
#endif
	@""
};
static NSUInteger num_json_replys = sizeof(json_replys)/sizeof(json_replys[0]);

static NSString *xml_replys[] = {
	@"server_time",
	@"route_list",
	@"route_list",
#if CONFIG_stops_update_route
	@"stop_list.direction",
#else
	@"stop_list",
#endif
	@"stop_list"
};
static NSUInteger num_xml_replys = sizeof(xml_replys)/sizeof(xml_replys[0]);
// --------------------------------------------------

@implementation ServiceMBTA

+ (NSUInteger)verbCount {
	// must be a 1-to-1-to-1 mapping of these three lists
	// as each verb must have both a json_reply and an xml_reply
	NSAssert((num_verbs == num_json_replys) && (num_json_replys == num_xml_replys), @"verb-reply count mismatch");
	return num_verbs;
}

+ (NSString *)verbForIndex:(NSUInteger)index {
	if (index < num_verbs)
		return verbs[index];
	return nil;
}

+ (NSUInteger)indexForVerb:(NSString *)verb {
	static NSArray *a_verbs;
	if (a_verbs == nil)
		a_verbs = [NSArray arrayWithObjects:verbs count:num_verbs];
	
	return [a_verbs indexOfObject:verb];
}

// ----------------------------------------------------------------------

+ (NSString *)replyForVerb:(NSString *)verb {
	NSUInteger index = [ServiceMBTA indexForVerb:verb];
#if CONFIG_useXML
	if (index < num_xml_replys)
		return xml_replys[index];
#else
	if (index < num_json_replys)
		return json_replys[index];
#endif
	return nil;
}

// ----------------------------------------------------------------------

+ (NSDictionary *)default_params {
	static NSDictionary *result;
	if (result == nil) {
		result = @{
				   param_api_key: key_MBTA_v2_API,
#if CONFIG_useXML
				   param_format	: @"xml"
#else
				   param_format	: @"json"
#endif
				   };
	}
	// NOTE: Since this code on GitHub does NOT include an API key,
	// but instead users must supply their own PRIVATE key,
	// we check here for the oft-likely case that no key has been provided.
	NSAssert([[result objectForKey:param_api_key] length] != 0, @"Missing/invalid API key.");
	return result;
}

// ----------------------------------------------------------------------

@end

// --------------------------------------------------
