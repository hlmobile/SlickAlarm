//
//  SetRepeatCon.m
//  SlickTime
//
//  Created by Miles Alden on 5/5/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "SetRepeatCon.h"
#import "ParentSettingsCon.h"
#import "SetAlarmViewCon.h"
#import "SlickTimeAppDelegate.h"
#import "CentralControl.h"
#import "Alarm.h"

@implementation SetRepeatCon
@synthesize vcParent;

- (void)viewDidLoad {

    [super viewDidLoad];
	self.view.backgroundColor = [UIColor clearColor];
	[self loadArrayData:NO];

    Alarm *tmp = [Alarm currentAlarmBeingEdited];
    repeatSetting = tmp.repeatSettings;
    [self.tableView reloadData];
    
    self.title = @"Repeat";
    
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
	
	[controllers addObject:@"String"];
	[sections addObject:controllers];
	
	if ( tableList_0 ) {
		[tableList_0 release];
		self->tableList_0 = nil;
		self->tableList_0 = [[NSMutableArray alloc] initWithObjects:SET_REPEAT_CON_LABELS_LIST, nil];
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
	
	
	static NSString *setRepeatString = @"SetRepeatString";
	UITableViewCell *cell;
	NSUInteger row = [indexPath row];
	
	
	cell = [tableView1 dequeueReusableCellWithIdentifier:setRepeatString];
	
	
	NSString *text = ( row < [tableList_0 count] ) ? [tableList_0 objectAtIndex:row] : nil;
	
	if (cell == nil) 
		cell = [Cells cellZeroWithIdentifier:setRepeatString text:text buttonTarget:self selector:@selector(buttonResponse) buttonTag:row];
	
	if (isIncludingWeekday(repeatSetting, row))
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
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	int newRow = [indexPath row];
	UITableViewCell *newCell = [tableView1 cellForRowAtIndexPath:indexPath];
    if (newRow == 0)
    {
        setWeekday(repeatSetting, 0, YES);
        //Deselect all other cells
        for (int i = 1; i <= 7; i ++)
        {
            UITableViewCell *oldCell = [tableView1 cellForRowAtIndexPath: [NSIndexPath indexPathForRow:i inSection:0]]; 
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            oldCell.textLabel.textColor = [UIColor lightGrayColor];
            
        }
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        newCell.textLabel.textColor = [UIColor blackColor];
        repeatSetting = 0;
        return;
    }
    if (newCell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        repeatSetting = setWeekday(repeatSetting, newRow, NO);
        newCell.accessoryType = UITableViewCellAccessoryNone;
        newCell.textLabel.textColor = [UIColor lightGrayColor];
    }
    else
    {
        repeatSetting = setWeekday(repeatSetting, newRow, YES);
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        newCell.textLabel.textColor = [UIColor blackColor];
    }
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:0]]; 
    oldCell.accessoryType = UITableViewCellAccessoryNone;
    oldCell.textLabel.textColor = [UIColor lightGrayColor];
	
	
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {}




#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController != self) 
    {
        [[Alarm currentAlarmBeingEdited] setRepeatSettings:repeatSetting];
        [vcParent refreshData];
        [navigationController setDelegate:(id<UINavigationControllerDelegate>)viewController];
    }
}







@end
