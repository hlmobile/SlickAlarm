//
//  SetSnoozeCon.m
//  SlickTime
//
//  Created by Miles Alden on 5/5/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "SetSnoozeCon.h"
#import "SetAlarmViewCon.h"
#import "SlickTimeAppDelegate.h"
#import "CentralControl.h"
#import "Alarm.h"


@implementation SetSnoozeCon
@synthesize vcParent;

- (void)viewDidLoad {
	
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor clearColor];
	[self loadArrayData:NO];
	
    Alarm *tmp = [Alarm currentAlarmBeingEdited];
    selectedRow = tmp.snoozeSettings;
    [self.tableView reloadData];
    self.title = @"Snooze";
    UIButton *backButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 35)] autorelease];
    [backButton setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnBack = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease]; 
    
    self.navigationItem.leftBarButtonItem = btnBack;
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadArrayData:(BOOL)hasAlarms {
	
	[super loadArrayData:NO];
	
	[sections addObject:controllers];
	
	if ( tableList_0 ) {
		[tableList_0 release];
		self->tableList_0 = nil;
		self->tableList_0 = [[NSMutableArray alloc] initWithObjects:SET_SNOOZE_CON_LIST, nil];
	}
	
}


- (void)buttonResponse {}



#pragma mark -
#pragma mark TableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [sections count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [tableList_0 count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	static NSString *setSnoozeString = @"SetSnoozeString";
	UITableViewCell *cell;
	NSUInteger row = [indexPath row];
	
	
	cell = [tableView1 dequeueReusableCellWithIdentifier:setSnoozeString];
	
	
	NSString *text = ( row < [tableList_0 count] ) ? [tableList_0 objectAtIndex:row] : nil;
	
	if (cell == nil) 
		cell = [Cells cellZeroWithIdentifier:setSnoozeString text:text buttonTarget:self selector:@selector(buttonResponse) buttonTag:row];
	
	if (row == selectedRow)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
	return cell;	
}








#pragma mark -
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView1 deselectRowAtIndexPath:indexPath animated:YES];
	
	int newRow = [indexPath row];
	
	if (newRow != selectedRow)
	{
		UITableViewCell *newCell = [tableView1 cellForRowAtIndexPath:indexPath];
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        newCell.textLabel.textColor = [UIColor blackColor];
        
		UITableViewCell *oldCell = [tableView1 cellForRowAtIndexPath: [NSIndexPath indexPathForRow:selectedRow inSection:0]]; 
		oldCell.accessoryType = UITableViewCellAccessoryNone;
        oldCell.textLabel.textColor = [UIColor lightGrayColor];
        
		selectedRow = newRow;
	}
	
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {}







#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController != self) 
    {
        [[Alarm currentAlarmBeingEdited] setSnoozeSettings:selectedRow];
        [vcParent refreshData];
        [navigationController setDelegate:(id<UINavigationControllerDelegate>)viewController];
    }
}







@end
