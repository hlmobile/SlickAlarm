//
//  LocationSearchController.h
//  AlarmAndClock
//
//  Created by Jin Bei on 11/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HttpClient.h"

@class HttpClient, MBProgressHUD, Place;
@protocol LocationSearchControllerDelegate
- (void)didSelectPlaceItem:(Place *)placeItem;
- (void)didCancelLocationSearch;
@end

@interface LocationSearchController : UIViewController
<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, DDHttpClientDelegate, CLLocationManagerDelegate>{

}
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *vwIndicator;
@property (nonatomic, retain) IBOutlet UITableView *tblSearch;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSMutableArray *placeArray;
@property (nonatomic, retain) HttpClient *client;
@property (nonatomic, retain) HttpClient *clientTimezone;
@property (nonatomic, retain) MBProgressHUD *hudProgress;
@property (nonatomic, retain) Place *selectedPlace;
@property (nonatomic, assign) id<LocationSearchControllerDelegate> delegate;
@property (nonatomic, retain) CLLocationManager *locationManager;
- (void)doneAction:(id)sender;
@end
