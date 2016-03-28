//
//  SetSleepModeCon.m
//  SlickTime
//
//  Created by Miles Alden on 5/5/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "SetSleepModeCon.h"
#import "SlickTimeAppDelegate.h"
#import "SetAlarmViewCon.h"
#import "SetSleepModeCon.h"
#import "SetSleepMusicCon.h"
#import "SetWhiteNoiseCon.h"
#import "CentralControl.h"
#import "Cells.h"
#import "Alarm.h"
#import "SleepSetting.h"
#import "SleepControl.h"
#import "SettingsRootViewCon.h"
#import "SetWhiteNoiseCon.h"

@implementation SetSleepModeCon


- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor clearColor];
	
    self.title = @"Sleep Settings";
	[self loadControllers];
	[self loadArrayData:NO];


    oldRow = [SleepSetting sharedSleepSetting].sleepMode;
    //[self.navigationController setDelegate:self];
    [self.tableView reloadData];
    
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
- (void)loadControllers {

	if ( self->setSleepMusicCon == nil ) 
        self->setSleepMusicCon = [[SetSleepMusicCon alloc] initWithNibName:@"SetSleepMusic" bundle:nil];
	if ( self->setWhiteNoiseCon == nil ) 
        self->setWhiteNoiseCon = [[SetWhiteNoiseCon alloc] initWithNibName:@"SetWhiteNoise" bundle:nil];

	[controllers addObject:setSleepMusicCon];
	[controllers addObject:setWhiteNoiseCon];
	
}


- (void)loadArrayData:(BOOL)hasAlarms {
	
	[super loadArrayData:NO];
	
	
	[sections addObject:controllers];
	[sections addObject:@"String"];
	
	
	if ( tableList_0 ) {
		[tableList_0 release];
		self->tableList_0 = nil;
		self->tableList_0 = [[NSMutableArray alloc] initWithObjects:@"Music", @"White Noise", nil];
	}	
	
	
	if ( tableList_1 ) {
		[tableList_1 release];
		self->tableList_1 = nil;
		self->tableList_1 = [[NSMutableArray alloc] initWithObjects:SET_SLEEP_MODE_CON_LIST, nil];
	}
	
}






- (void)buttonResponse: (id)sender {
	
	UISwitch *switch_ = (UISwitch *)sender;
	
	int num = ( switch_.tag == 0 ) ? 1 : 0;

	
	NSIndexPath *index = [NSIndexPath indexPathForRow:num inSection:0];
	UITableViewCell *cell =  [self.tableView cellForRowAtIndexPath:index];
	UISwitch *switch0 = (UISwitch *)cell.accessoryView;

	if ( switch_.on ) 
		[switch0 setOn:NO animated:YES]; 

}

- (void)switchButtonPressed: (id)sender
{
    UISwitch *btnSwitch = (UISwitch *)sender;
    //Sleep
    if (btnSwitch.tag == 100)
    {
        [SleepSetting sharedSleepSetting].musicOn = btnSwitch.isOn;
        [SleepSetting sharedSleepSetting].noiseOn = !btnSwitch.isOn;
        UISwitch *btnOtherSwitch = (UISwitch *)[self.tableView viewWithTag:101];
        [btnOtherSwitch setOn:(!btnSwitch.isOn) animated:YES];
        
    }
    //Sleep
    else if (btnSwitch.tag == 101)
    {
        [SleepSetting sharedSleepSetting].noiseOn = btnSwitch.isOn;
        [SleepSetting sharedSleepSetting].musicOn = !btnSwitch.isOn;
        UISwitch *btnOtherSwitch = (UISwitch *)[self.tableView viewWithTag:100];
        [btnOtherSwitch setOn:(!btnSwitch.isOn) animated:YES];
        
    }
}








#pragma mark -
#pragma mark TableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [sections count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ( section == 1 ) ? [tableList_1 count] : [tableList_0 count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	static NSString *setSleepModeString = @"SetSleepModeString";
	static NSString *switchCellString = @"SwitchCellString";
	UITableViewCell *cell;
	NSUInteger row = [indexPath row];
	
	
	//Set resuse identifier based on section
	cell = [tableView dequeueReusableCellWithIdentifier:(indexPath.section == 1) ? setSleepModeString : switchCellString];
	
	
	
	//Set text strings based on section
	NSString *text;
	if ( indexPath.section == 1 )
		text = ( row < [tableList_1 count] ) ? [tableList_1 objectAtIndex:row] : nil;
	else 
		text = ( row < [tableList_0 count] ) ? [tableList_0 objectAtIndex:row] : nil;

	
	
	//Set cell type based on section
	if (cell == nil) 
	{
        if (indexPath.section == 0)
        {
            
            BOOL switchOn = NO;
            if (row == 0)
                switchOn = [SleepSetting sharedSleepSetting].musicOn;
            else if (row == 1)
                switchOn = [SleepSetting sharedSleepSetting].noiseOn;
            cell = [Cells cellFourWithIdentifier:switchCellString text:text buttonTarget:self selector:@selector(switchButtonPressed:) switchStartsOn:switchOn buttonTag:(row + 100)];
        }
        else 
        {

            cell = [Cells cellZeroWithIdentifier:setSleepModeString text:text buttonTarget:self selector:@selector(buttonResponse:) buttonTag:row];
        }
		
	}
    
    if (indexPath.section == 1)
    {
        if (oldRow == indexPath.row)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.textColor = [UIColor blackColor];
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
    }
    else
        cell.textLabel.textColor = [UIColor blackColor];

        
	
	return cell;	
}








#pragma mark -
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView1 deselectRowAtIndexPath:indexPath animated:YES];
	
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            SetSleepMusicCon *con = [[[SetSleepMusicCon alloc] initWithNibName:@"SetSleepMusic" bundle:nil] autorelease];
            [self.navigationController pushViewController:con animated:YES];
        }
        else if (indexPath.row == 1)
        {
            SetWhiteNoiseCon *con = [[[SetWhiteNoiseCon alloc] initWithNibName:@"SetWhiteNoise" bundle:nil] autorelease];
            [self.navigationController pushViewController:con animated:YES];
        }
    }
    else
    {
            
        int newRow = [indexPath row];
        
        if (newRow != oldRow)
        {
            UITableViewCell *newCell = [tableView1 cellForRowAtIndexPath:indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            newCell.textLabel.textColor = [UIColor blackColor];
            
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:oldRow inSection:1];
            UITableViewCell *oldCell = [tableView1 cellForRowAtIndexPath: lastIndexPath]; 
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            oldCell.textLabel.textColor = [UIColor lightGrayColor];
            oldRow = newRow;
            [SleepSetting sharedSleepSetting].sleepMode = newRow;
        }
	}
    
    
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController != self) 
    {
        [navigationController setDelegate:(id<UINavigationControllerDelegate>)viewController];
        if ([viewController class] == [SettingsRootViewCon class])
            [SleepSetting saveSleepSetting];
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {}





@end
