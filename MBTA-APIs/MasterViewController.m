//
//	MasterViewController.m
//	MBTA-APIs
//
//	Created by Steve Caine on 01/05/15.
//	Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import "ApiRoutes.h"
#import "ApiStops.h"
#import "ApiTime.h"

#import "ServiceMBTA.h"
#import "ServiceMBTA+RestKit.h"
#import "RKXMLReaderSerialization.h"

#import "ServiceMBTA_strings.h"

#import <RestKit/RestKit.h>

// for sake of completeness, use weak/strong-self pattern inside blocks
#import "EXTScope.h"

static NSString *str_sequeID_DetailViewController = @"showDetail";
//static NSString *str_sequeID_DetailViewController = @"showResponse";

static NSString * const		  test_routeID   = @"71";
static NSString * const		  test_stopID    = @"2021";
static CLLocationCoordinate2D test_location  = { +42.373600, -71.118962 };

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@interface MasterViewController ()
@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation MasterViewController

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

//	http://realtime.mbta.com/developer/api/v2/servertime?api_key=<myKey>&format=[json/xml]
- (void)get_servertime {
	@weakify(self)
	[ApiTime get_success:^(ApiTime *servertime) {
		NSLog(@"\n\n%s servertime = %@\n\n", __FUNCTION__, servertime);
		@strongify(self)
		[self show_success:servertime verb:verb_servertime];
	} failure:^(NSError *error) {
		NSLog(@"\n\n%s API call failed: %@", __FUNCTION__, [error localizedDescription]);
		@strongify(self)
		[self show_failure_verb:verb_servertime];
	}];
}

//	http://realtime.mbta.com/developer/api/v2/routes?api_key=<myKey>&format=[json/xml]
- (void)get_routes {
	@weakify(self)
	[ApiRoutes get_success:^(ApiRoutes *routes) {
		@strongify(self)
		NSLog(@"\n\n%s routes = %@\n\n", __FUNCTION__, routes);
		[self show_success:routes verb:verb_routes];
	} failure:^(NSError *error) {
		@strongify(self)
		NSLog(@"\n\n%s API call failed: %@", __FUNCTION__, [error localizedDescription]);
		[self show_failure_verb:verb_routes];
	}];
}

//	http://realtime.mbta.com/developer/api/v2/routesbystop?stop=<stop_id>&api_key=<myKey>&format=[json/xml]
- (void)get_routesbystop {
	NSString *stopID = test_stopID;
	@weakify(self)
	[ApiRoutesByStop get4stopID:stopID success:^(ApiRoutesByStop *routes) {
		@strongify(self)
		NSLog(@"\n\n%s routes = %@\n\n", __FUNCTION__, routes);
		[self show_success:routes verb:verb_routesbystop];
	} failure:^(NSError *error) {
		@strongify(self)
		NSLog(@"\n\n%s API call failed: %@", __FUNCTION__, [error localizedDescription]);
		[self show_failure_verb:verb_routesbystop];
	}];
}

//	http://realtime.mbta.com/developer/api/v2/stopsbyroute?route=71&api_key=<myKey>&format=[json/xml]
- (void)get_stopsbyroute {
#if CONFIG_stops_update_route
	// we get an ApiRoute object, then update it with its stops
	@weakify(self)
	[ApiRoutes get_success:^(ApiRoutes *routes) {
		@strongify(self)
		if (routes) {
			ApiRoute *route = [routes routeByID:test_routeID];
			if (route) {
				@weakify(self)
				[route addStops_success:^(ApiRoute *route) {
					@strongify(self)
					NSLog(@"\n\n%s %@\n\n", __FUNCTION__, route);
					[self show_success:route verb:verb_stopsbyroute];
				} failure:^(NSError *error) {
					@strongify(self)
					NSLog(@"\n\n%s API call failed: %@", __FUNCTION__, [error localizedDescription]);
					[self show_failure_verb:verb_stopsbyroute];
				}];
			}
		}
	} failure:^(NSError *error) {
		@strongify(self)
		NSLog(@"\n\n%s API call failed: %@", __FUNCTION__, [error localizedDescription]);
		[self show_failure_verb:verb_stopsbyroute];
	}];
#else
	// we get an ApiStopsByRoute object directly
	NSString *routeID = test_routeID;
	@weakify(self)
	[ApiStopsByRoute get4route:routeID success:^(ApiStopsByRoute *data) {
		@strongify(self)
		NSLog(@"\n\n%s success:", __FUNCTION__);
		NSUInteger i = 0;
		for (ApiRouteDirection *direction in data.directions) {
			NSLog(@"%2lu, %@", (unsigned long)i++, direction);
		}
		[self show_success:data verb:verb_stopsbyroute];
	} failure:^(NSError *error) {
		@strongify(self)
		NSLog(@"\n\n%s API call failed: %@", __FUNCTION__, [error localizedDescription]);
		[self show_failure_verb:verb_stopsbyroute];
	}];
#endif
}

//	http://realtime.mbta.com/developer/api/v2/stopsbylocation?lat=<latitude>&lon=<longitude>&api_key=<myKey>&format=[json/xml]
- (void)get_stopsbylocation {
	CLLocationCoordinate2D location = test_location;
	@weakify(self)
	[ApiStopsByLocation get4location:location success:^(ApiStopsByLocation *data) {
		@strongify(self)
		NSLog(@"\n\n%s stops = %@\n\n", __FUNCTION__, data);
		[self show_success:data verb:verb_stopsbylocation];
	} failure:^(NSError *error) {
		@strongify(self)
		NSLog(@"\n\n%s API call failed: %@", __FUNCTION__, [error localizedDescription]);
		[self show_failure_verb:verb_stopsbylocation];
	}];
}

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

- (void)awakeFromNib {
	[super awakeFromNib];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[ServiceMBTA configurRestKit];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)dealloc {
	// cancel any pending 'performSelector' calls as we go away
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
}

// ----------------------------------------------------------------------
#pragma mark - Segues
// ----------------------------------------------------------------------

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	return NO; // for now
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([[segue identifier] isEqualToString:str_sequeID_DetailViewController]) {
//	    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//		NSDate *object = [NSDate date];
//	    [[segue destinationViewController] setDetailItem:object];
	}
}

// ----------------------------------------------------------------------
#pragma mark - UITableViewDataSource
// ----------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [ServiceMBTA verbCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

	NSString *text = nil;
	if (indexPath.row < [ServiceMBTA verbCount])
		text = [ServiceMBTA verbForIndex:indexPath.row];
	else
		text = @"???";
	cell.textLabel.text = text;
	cell.detailTextLabel.text = @"idle";
	
//	if (NO == [ServiceMBTA can_test4index:indexPath.row]) {
//		cell.userInteractionEnabled = NO;
//		cell.textLabel.textColor = [UIColor lightGrayColor];
//	}
	
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	spinner.hidesWhenStopped = YES;
	[cell setAccessoryView:spinner];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}

// ----------------------------------------------------------------------
#pragma mark - UITableViewDelegate
// ----------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	cell.detailTextLabel.text = @"requesting ...";
	
	UIView *accessoryView = cell.accessoryView;
	if ([accessoryView isKindOfClass:[UIActivityIndicatorView class]]) {
		UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)accessoryView;
		[spinner startAnimating];
	}
	
	switch (indexPath.row) {
		// order of items specified by list of verbs from ServiceMBTA
		case e_verb_servertime:
			[self get_servertime];
			break;
		
		case e_verb_routes:
			[self get_routes];
			break;
		
		case e_verb_routesbystop:
			[self get_routesbystop];
			break;
		
		case e_verb_stopsbyroute:
			[self get_stopsbyroute];
			break;
		
		case e_verb_stopsbylocation:
			[self get_stopsbylocation];
			break;
		
		default:
			break;
	}
}

// ----------------------------------------------------------------------
#pragma mark - show success/failure
// ----------------------------------------------------------------------

- (void)show_success:(ApiData *)data verb:(NSString *)verb {
	
	NSString *text = nil;
	NSUInteger index = [ServiceMBTA indexForVerb:verb];
	
	switch (index) {
		case e_verb_servertime: {
			ApiTime *servertime = (ApiTime *)data;
			text = [NSString stringWithFormat:@"%@ => %@", verb, [servertime time]];
		}	break;
			
		case e_verb_routes: {
			ApiRoutes *routes = (ApiRoutes *)data;
			text = [NSString stringWithFormat:@"%@ => %@", verb, [self routes_in_modes:routes.modes]];
		}	break;
			
		case e_verb_routesbystop: {
			ApiRoutesByStop *routes = (ApiRoutesByStop *)data;
			text = [NSString stringWithFormat:@"%@ => %@", verb, [self routes_in_modes:routes.modes]];
		}	break;
			
		case e_verb_stopsbyroute: {
#if CONFIG_stops_update_route
			ApiRoute *route = (ApiRoute *)data;
			text = [NSString stringWithFormat:@"%@ => %@", verb, [self stops_in_directions:route.directions]];
#else
			ApiStopsByRoute *stops = (ApiStopsByRoute *)data;
			text = [NSString stringWithFormat:@"%@ => %@", verb, [self stops_in_directions:stops.directions]];
#endif
		}	break;
			
		case e_verb_stopsbylocation: {
			ApiStopsByLocation *stops = (ApiStopsByLocation *)data;
			text = [NSString stringWithFormat:@"%@ => %lu stops", verb, (unsigned long)[stops.stops count]];
		}	break;
		
		default:
			break;
	}
	if (text)
		[self setResponse:text forVerb:verb];
}

- (void)show_failure_verb:(NSString *)verb {
	NSString *text = [NSString stringWithFormat:@"%@ request failed", verb];
	[self setResponse:text forVerb:verb];
}


// ----------------------------------------------------------------------

// returns string "<num> routes in <num> modes"
- (NSString *)routes_in_modes:(NSArray *)modes {
	NSUInteger num_routes = 0;
	for (ApiRouteMode *mode in modes) {
		num_routes += [mode.routes count];
	}
	NSString *result = [NSString stringWithFormat:@"%lu routes in %lu modes", (unsigned long)num_routes, (unsigned long)[modes count]];
	return result;
}

// returns string "<num> routes in <num> modes"
- (NSString *)stops_in_directions:(NSArray *)directions {
	NSUInteger num_stops = 0;
	for (ApiRouteDirection *direction in directions) {
		num_stops += [direction.stops count];
	}
	NSString *result = [NSString stringWithFormat:@"%lu stops in %lu directions", (unsigned long)num_stops, (unsigned long)[directions count]];
	return result;
}

// ----------------------------------------------------------------------

- (void)setResponse:(NSString *)text forVerb:(NSString *)verb {
	if ([verb length]) {
		NSUInteger row = [ServiceMBTA indexForVerb:verb];
		if (row < [ServiceMBTA verbCount]) { // get NSNotFound for unknown verb
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
			
			if ([text length]) {
				cell.detailTextLabel.text = text;
				
				UIView *accessoryView = cell.accessoryView;
				if ([accessoryView isKindOfClass:[UIActivityIndicatorView class]]) {
					UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)accessoryView;
					[spinner stopAnimating];
				}
				// wait awhile, then go back to original state
				[self performSelector:@selector(resetForVerb:) withObject:verb afterDelay:3.0];
			}
		}
	}
}

- (void)resetForVerb:(NSString *)verb {
	NSUInteger row = [ServiceMBTA indexForVerb:verb];
	if (row < [ServiceMBTA verbCount]) { // get NSNotFound for unknown verb
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		cell.detailTextLabel.text = @"idle";
	}
}

// ----------------------------------------------------------------------

@end
