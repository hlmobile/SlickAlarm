//
//  SetAlarmViewCon.m
//  SlickTime
//
//  Created by Miles Alden on 5/4/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "SetAlarmViewCon.h"
#import "SlickTimeAppDelegate.h"
#import "SettingsRootViewCon.h"
#import "CentralControl.h"
#import "Alarm.h"
#import "SetTimeCon.h"
#import "SetRepeatCon.h"
#import "SetSnoozeCon.h"
#import "SetMusicCon.h"
#import "SetLabelCon.h"
#import "SetSleepModeCon.h"
#import "SetAutolockCon.h"
#import "Cells.h"
#import "UIViewController_navDelegate.h"


@implementation SetAlarmViewCon


- (void)viewDidLoad {

    [super viewDidLoad];
	self.view.backgroundColor = [UIColor clearColor];

	[self loadArrayData:NO];
	
	
	
	//Load small, blue detail label strings
	[self loadDetailLabels];
	
	[sections addObject:@"Section"];
    
    UIButton *saveButon = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 35)] autorelease];
    [saveButon setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [saveButon addTarget:self action:@selector(saveAlarm) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSave = [[[UIBarButtonItem alloc] initWithCustomView:saveButon] autorelease]; 
    self.navigationItem.leftBarButtonItem = btnSave;
    
    //UIBarButtonItem *save = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAlarm)] autorelease];
    //[self.navigationItem setRightBarButtonItem: save];
    

	
}



- (void)refreshData
{
    NSString *str = [[Alarm currentAlarmBeingEdited] theLabel];
    if (str.length > 0)
        self.title = str;
    else
        self.title = @"Alarm";
    [self loadDetailLabels];
	[self.tableView reloadData];	
}

- (void)saveAlarm
{
    
    Alarm *tmp = [Alarm currentAlarmBeingEdited];
    
    if ( tmp.alarmTime != nil ) {
		[tmp endEditing];

        [self.navigationController popViewControllerAnimated:YES];
        
        //[del.centralCon flipView];
        
    }
    
    else 
    {
        //[self showAlert];
        [Alarm cleanUnusedAlarm];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)backButtonPressed
{
    
}

- (void)showAlert 
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please enter an alarm time or cancel" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Ok", nil];
    [alert show];
    [alert release];
    
}

















#pragma mark -
#pragma Array Data


- (void)loadArrayData:(BOOL)hasAlarms {
	
	
	//Super allocs this already, but I want to use initWithObjects (plural)
	if ( tableList_0 ) {
		[tableList_0 release];
		tableList_0 = nil;
    }
    self->tableList_0 = [[NSMutableArray alloc] initWithObjects:SET_ALARM_TABLE_LIST, nil];
	
	
}


- (void)loadControllers {

	
    self->controllers = [[NSMutableArray alloc] initWithObjects:SET_ALARM_TABLE_LIST, nil];
    return;
    
	if ( setTimeCon == nil ) self->setTimeCon =		[[SetTimeCon alloc] initWithNibName:@"SetAlarm" bundle:nil];
	if ( setRepeatCon == nil )self->setRepeatCon =	[[SetRepeatCon alloc] initWithNibName:@"SetRepeat" bundle:nil];
	if ( setSnoozeCon == nil )self->setSnoozeCon =	[[SetSnoozeCon alloc] initWithNibName:@"SetSnooze" bundle:nil];
	if ( setMusicCon == nil )self->setMusicCon =		[[SetMusicCon alloc] initWithNibName:@"SetMusic" bundle:nil];
	if ( setLabelCon == nil )self->setLabelCon =		[[SetLabelCon alloc] initWithNibName:@"SetLabel" bundle:nil];
	if ( setSleepModeCon == nil )self->setSleepModeCon = [[SetSleepModeCon alloc] initWithNibName:@"SetSleepMode" bundle:nil];
	if ( setAutoLockCon == nil )self->setAutoLockCon =	[[SetAutolockCon alloc] initWithNibName:@"SetAutolock" bundle:nil];
	
	
	
	//Add to controllers array as a group
	if ( controllers ) {
		[controllers release];
		self->controllers = nil;
		self->controllers = [[NSMutableArray alloc] initWithObjects:SET_ALARM_CONTROLLERS_LIST, nil];
	}
	
	
}

- (UIViewController *)controllerForIndex:(int)index
{
    UIViewController *controller;
    
    //Time
    if (index == 0)
    {
        controller = [[[SetTimeCon alloc] initWithNibName:@"SetAlarm" bundle:nil] autorelease];
    }
    //Repeat
    else if (index == 1)
    {
        controller = [[[SetRepeatCon alloc] initWithNibName:@"SetRepeat" bundle:nil] autorelease];
    }
    //Snooze
    else if (index == 2)
    {
        controller = [[[SetSnoozeCon alloc] initWithNibName:@"SetSnooze" bundle:nil] autorelease];
    }
    //Music
    else if (index == 3)
    {
        controller = [[[SetMusicCon alloc] initWithNibName:@"SetMusic" bundle:nil] autorelease];
    }
    //RoosterCrow
    else if (index == 4)
    {
        controller = nil;
    }
    //Label
    else if (index == 5)
    {
        controller = [[[SetLabelCon alloc] initWithNibName:@"SetLabel" bundle:nil] autorelease];
    }
    return controller;
    
}

- (void)loadDetailLabels {
	
	if ( tableList_1 ) 
	{
		[tableList_1 release];
		self->tableList_1 = nil;
	}

	Alarm *tmp = [Alarm currentAlarmBeingEdited];
	self->tableList_1 = [[NSMutableArray alloc] initWithArray:[tmp allValuesAsStringSet] copyItems:YES];
	
//	NSLog(@"\ntableList_1: %@\n", tableList_1);
}


- (IBAction)action {}















#pragma mark -
#pragma mark Temp Response

- (void)buttonResponse {
	
	[UIView beginAnimations:@"boop" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.15];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(reverse) ];
	
	self.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
	
	[UIView commitAnimations];
	
}

- (void)reverse {
	
	[UIView beginAnimations:@"boop" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.15];
	
	self.view.transform = CGAffineTransformIdentity;
	
	[UIView commitAnimations];
	
}

- (void)switchChanged:(id)sender
{
    UISwitch *roosterSwitch = sender;
    if (roosterSwitch.tag == SetAlarmTableIndexRoosterCrow)
    {
        Alarm *tmp = [Alarm currentAlarmBeingEdited];
        tmp.roosterCrowOn = roosterSwitch.isOn;
    }
}














#pragma mark -
#pragma mark TableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	static NSString *setAlarmString = @"SetAlarmString";
	UITableViewCell *cell;
	NSUInteger row = [indexPath row];

	
	//cell = [tableView dequeueReusableCellWithIdentifier:setAlarmString];
	
	NSString *text = ( row < [tableList_0 count] ) ? [tableList_0 objectAtIndex:row] : nil;
	NSString *detail = ( row < [tableList_1 count] ) ? [tableList_1 objectAtIndex:row] : nil;
    Alarm *tmp = [Alarm currentAlarmBeingEdited];
	/*
	if (cell == nil) 
		cell = [Cells cellTwoWithIdentifier:setAlarmString text:text buttonTarget:self selector:@selector(buttonResponse) detailLabelText:detail buttonTag: row];
	*/
    
    if (row == SetAlarmTableIndexRoosterCrow)
    {
        cell = [Cells cellFourWithIdentifier:setAlarmString text:text buttonTarget:self selector:@selector(switchChanged:) switchStartsOn:tmp.roosterCrowOn buttonTag:row];
        cell.textLabel.text = text;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    else
    {
        
        cell = [Cells cellTwoWithIdentifier:setAlarmString text:text buttonTarget:self selector:@selector(buttonResponse) detailLabelText:detail buttonTag: row];
        cell.textLabel.text = text;
        cell.detailTextLabel.text = detail;
    }
	
    cell.detailTextLabel.textColor = SLICK_TIME_BLUE_COLOR;
    cell.detailTextLabel.font = SLICK_TIME_DETAIL_LABEL_FONT;
	
	
	
	return cell;	
}









#pragma mark -
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView1 deselectRowAtIndexPath:indexPath animated:YES];
	
	//Pressed cells with next view controllers
	if ( indexPath.row != SetAlarmTableIndexRoosterCrow )
	{
		ParentSettingsCon *nextController = (ParentSettingsCon *)[self controllerForIndex:indexPath.row];
		[self.navigationController pushViewController:nextController animated:YES]; 
        if ([nextController respondsToSelector:@selector(setVcParent:)])
            [nextController setVcParent:self];
	}
	/*
	//Pressed an existing alarm cell
	else 
	{
		UIViewController_navDelegate *nextController = (UIViewController_navDelegate *)[controllers objectAtIndex:indexPath.row];
		[self.navigationController pushViewController:nextController animated:YES]; 
		[self.navigationController setDelegate:nextController];
		[nextController viewDidAppear:YES];
	}
	*/
	
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {}






#pragma mark -
#pragma mark Alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 ) {
		// didn't enter a time for this alarm, then hit cancel... So delete the current alarm?
		Alarm *tmp = [Alarm currentAlarmBeingEdited];
		if (tmp) {
			[tmp abortEditing];
			[Alarm deleteAlarm: tmp];
		}
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController != self) 
    {
        
        [navigationController setDelegate:(id<UINavigationControllerDelegate>)viewController];
    }
}




#pragma mark -
#pragma mark Memory

- (void)dealloc {
	
				
	
	if ( setTimeCon ) {
	[setTimeCon release];
		self->setTimeCon = nil;
	}
	
	if ( setRepeatCon ) {
		[setRepeatCon release];
		self->setRepeatCon = nil;
	}

	if ( setMusicCon ) {
		[setMusicCon release];
		self->setMusicCon = nil;
	}

	if ( setLabelCon ) {
		[setLabelCon release];
		self->setLabelCon = nil;
	}

	if ( setSleepModeCon ) {
		[setSleepModeCon release];
		self->setSleepModeCon = nil;
	}

	if ( setAutoLockCon ) {
		[setAutoLockCon release];
		self->setAutoLockCon = nil;
	}

		
	[super dealloc];
	
}





@end
