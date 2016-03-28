//
//  WeatherSettingsCon.h
//  SlickTime
//
//  Created by Miles Alden on 6/13/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParentSettingsCon.h"
#import "LocationSearchController.h"

@interface WeatherSettingsCon : UIViewController <UITableViewDelegate, UITableViewDataSource, LocationSearchControllerDelegate> {

}

@property (nonatomic, retain) IBOutlet UITableView *tblWeather;

- (IBAction)addButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

- (void)localWeatherSwitchChanged:(id)sender;
- (void)temperatureFormatChanged:(id)sender;



@end
