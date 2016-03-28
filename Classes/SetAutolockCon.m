//
//  SetAutolockCon.m
//  SlickTime
//
//  Created by Miles Alden on 5/5/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "SetAutolockCon.h"
#import "SlickTimeAppDelegate.h"
#import "CentralControl.h"
#import "SleepSetting.h"
#import "Alarm.h"
#import "Cells.h"
#import "SetAlarmViewCon.h"
#import "SettingsRootViewCon.h"
@implementation SetAutolockCon


- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor clearColor];
	[self loadArrayData:NO];
	
    self.title = @"Auto Lock";
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
- (void)viewDidAppear:(BOOL)animated
{
    selectedRow = [SleepSetting sharedSleepSetting].autoLockMode;
    [self.tableView reloadData];
}
- (void)loadArrayData:(BOOL)hasAlarms {
	
	[super loadArrayData:NO];
	
	[controllers addObject:@"String"];
	[sections addObject:controllers];
	if ( tableList_0 ) {
		[tableList_0 release];
		self->tableList_0 = nil;
		self->tableList_0 = [[NSMutableArray alloc] initWithObjects:SET_AUTOLOCK_CON_LIST, nil];
	}
	
}


- (void)buttonResponse {}

- (void)backButtonPressed: (id)sender
{
    [SleepSetting sharedSleepSetting].autoLockMode = selectedRow;
}


#pragma mark -
#pragma mark TableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [sections count] + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return [tableList_0 count];
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 44;
    return 280;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (indexPath.section == 1)
    {
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        cell.textLabel.text = @"In order to prevent the battery from going empty your iPhone has an Autolock function."
                                "This function turns the iPhone screen off after the time set in Autolock (see Settings General).\n"
                                "This app has an Autolock override which adds the following time to the native Autolock.\n"
                                "Leave it set to ''Never' if you want music to play when the Alarm sounds.\n"
                                "When battery is below 20% and the phone is not plugged in, this Autolock override will not activate and the app will turn off.";
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
	
	static NSString *setAutolockString = @"SetAutolockString";
	UITableViewCell *cell;
	NSUInteger row = [indexPath row];
	
	
	cell = [tableView1 dequeueReusableCellWithIdentifier:setAutolockString];
	
	
	NSString *text = ( row < [tableList_0 count] ) ? [tableList_0 objectAtIndex:row] : nil;
	
	if (cell == nil) 
		cell = [Cells cellZeroWithIdentifier:setAutolockString text:text buttonTarget:self selector:@selector(buttonResponse) buttonTag:row];
	
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
	
    if (indexPath.section == 1)
        return;
    
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
        [SleepSetting sharedSleepSetting].autoLockMode = newRow;
        [SleepSetting saveSleepSetting];
	}
	
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {}




#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController != self) 
    {
        [navigationController setDelegate:(id<UINavigationControllerDelegate>)viewController];
    }
}





@end
