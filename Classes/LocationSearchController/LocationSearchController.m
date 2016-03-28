//
//  LocationSearchController.m
//  AlarmAndClock
//
//  Created by Jin Bei on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationSearchController.h"
#import "WeatherSetting.h"
#import "HttpClientPool.h"
#import "Place.h"
#import "MBProgressHUD.h"

@implementation LocationSearchController
@synthesize placeArray, tblSearch, delegate, client, searchBar, hudProgress, locationManager, clientTimezone;
@synthesize selectedPlace;
@synthesize vwIndicator;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}



- (void)doneAction:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.placeArray = [NSMutableArray arrayWithCapacity:100];
	self.client = [[[HttpClient alloc] init] autorelease];
	self.client.delegate = self;
	self.clientTimezone = [[[HttpClient alloc] init] autorelease];
    self.clientTimezone.delegate = self;
    
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
	
    self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release]; 
    [searchBar becomeFirstResponder];
	self.navigationItem.title = @"Settings";
}


- (void) viewWillDisappear:(BOOL)animated {
	[self.client cancelDelegate];
	[self.clientTimezone cancelDelegate];
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1 {
    /*
	[self.client cancel];
	[self.client reqSearchPlaceByTerm:searchBar1.text];
	[self.searchBar resignFirstResponder];
     */
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.client cancel];
	[self.client reqSearchPlaceByTerm:searchText];
    [vwIndicator setHidden:NO];
	
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (delegate)
        [delegate didCancelLocationSearch];
}
#pragma mark DDHttpClientDelegate
- (void)HttpClientSucceeded:(HttpClient*)sender
{
    [vwIndicator setHidden:YES];
	if (sender.requestType == SEARCHLOCATION_REQUEST)
    {
        self.placeArray = [NSMutableArray arrayWithArray:(NSArray *)sender.result];
        [tblSearch reloadData];
    }
    else if (sender.requestType == GEONAME_REQUEST)
    {
        if (self.selectedPlace)
        {
            Place *place = (Place *)sender.result;
            selectedPlace.timeZone =place.timeZone; 
            [delegate didSelectPlaceItem:selectedPlace];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
	
}
	
- (void)HttpClientFailed:(HttpClient*)sender {
    [vwIndicator setHidden:YES];
    if (sender.requestType == GEONAME_REQUEST)
    {
        selectedPlace.timeZone = [[[NSCalendar currentCalendar] timeZone] name];
        [delegate didSelectPlaceItem:selectedPlace];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark UITableViewDelegate

-(void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	self.selectedPlace = [placeArray objectAtIndex:indexPath.row];
    [self.clientTimezone cancel];
	[self.clientTimezone reqPlaceByLocation:[NSString stringWithFormat:@"%@,%@", selectedPlace.latitudeCenter, selectedPlace.longitudeCenter]];
    [vwIndicator setHidden:NO];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.placeArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

	}
	Place *item = [placeArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item.fullName;
	
	return cell;
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[locationManager stopUpdatingLocation];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    
    [clientTimezone release];
    [client release];
    [selectedPlace release];
    if (locationManager)
        [locationManager stopUpdatingLocation];
	[locationManager release];
	[placeArray release];
	[tblSearch release];
	[searchBar release];
    [vwIndicator release];
    [super dealloc];
}


@end
