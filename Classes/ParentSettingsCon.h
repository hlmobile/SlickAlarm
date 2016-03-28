//
//  ParentSettingsCon.h
//  SlickTime
//
//  Created by Miles Alden on 5/4/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SlickTimeAppDelegate.h"
#import "CentralControl.h"
#import "Alarm.h"
#import "Cells.h"


@interface ParentSettingsCon : UIViewController < UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate> {

	NSMutableArray *controllers, *sections, *tableList_0, *tableList_1;
    UITableView *tableView;
}

- (void)loadArrayData:(BOOL)hasAlarms;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
