//
//  ServiceMBTA_strings.h
//  MBTA-APIs
//
//  Created by Steve Caine on 12/31/14.
//  Copyright (c) 2014 Steve Caine. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MBTA_APIs_ErrorDomain		@"MBTA_APIs_ErrorDomain"

// ----------------------------------------------------------------------
// VERBS
#define verb_servertime				@"servertime"
#define verb_routes					@"routes"
#define verb_routesbystop			@"routesbystop"
#define verb_stopsbyroute			@"stopsbyroute"
#define verb_stopsbylocation		@"stopsbylocation"
#define schedulebystop				@"schedulebystop"
#define schedulebyroute				@"schedulebyroute"
#define schedulebytrip				@"schedulebytrip"
#define predictionsbyroute			@"predictionsbyroute"
#define predictionsbystop			@"predictionsbystop"
#define predictionsbytrip			@"predictionsbytrip"
#define vehiclesbyroute				@"vehiclesbyroute"
#define vehiclesbytrip				@"vehiclesbytrip"
#define alerts						@"alerts"
#define alertsbyroute				@"alertsbyroute"
#define alertsbystop				@"alertsbystop"
#define alertbyid					@"alertbyid"
#define alertheaders				@"alertheaders"
#define alertheadersbyroute			@"alertheadersbyroute"
#define alertheadersbystop			@"alertheadersbystop"

// ----------------------------------------------------------------------
// REQUESTS
#define request_servertime			@"servertime"
#define request_routes				@"routes"
#define request_routesbystop		@"routesbystop"
#define request_stopsbyroute		@"stopsbyroute"
#define request_stopsbylocation		@"stopsbylocation"
// the rest *TK* when supporting code is implemented

// ----------------------------------------------------------------------
// RESPONSES (XML only)
#define response_servertime			@"server_time"
#define response_routes				@"route_list"
#define response_routesbystop		@"route_list"
#define response_stopsbyroute		@"stop_list"
#define response_stopsbylocation	@"stop_list"
// ditto to note above

// ----------------------------------------------------------------------
// REQUEST KEYS
#define param_stop					@"stop"
#define param_route					@"route"
#define param_lat					@"lat"
#define param_lon					@"lon"

#define param_api_key				@"api_key"
#define param_format				@"format"

// ----------------------------------------------------------------------
// REQUEST PARAM VALUES
#define format_json					@"json"
#define format_xml					@"xml"

// ----------------------------------------------------------------------
// RESPONSE KEYS
#define key_server_dt				@"server_dt"	// seconds since 01 Jan 1970 as integer

#define key_mode					@"mode"
#define key_mode_name				@"mode_name"
#define key_route_type				@"route_type"

#define key_route					@"route"
#define key_route_id				@"route_id"
#define key_route_name				@"route_name"
#define key_route_hide				@"route_hide"

#define key_direction				@"direction"
#define key_direction_id			@"direction_id"
#define key_direction_name			@"direction_name"

#define key_stop					@"stop"
#define key_stop_id					@"stop_id"
#define key_stop_name				@"stop_name"
#define key_stop_order				@"stop_order"
#define key_stop_sequence			@"stop_sequence"
#define key_stop_lat				@"stop_lat"
#define key_stop_lon				@"stop_lon"

#define key_parent_station			@"parent_station"
#define key_parent_station_name		@"parent_station_name"

#define key_distance				@"distance"

// --------------------------------------------------
// map verbs to enums

typedef enum api_verbs {
	e_verb_servertime,
	e_verb_routes,
	e_verb_routesbystop,
	e_verb_stopsbyroute,
	e_verb_stopsbylocation
} api_verb;

// --------------------------------------------------
