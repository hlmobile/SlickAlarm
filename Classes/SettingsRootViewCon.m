//
//  SettingsRootViewCon.m
//  SlickTime
//
//  Created by Miles Alden on 5/4/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "SettingsRootViewCon.h"
#import "SetAlarmViewCon.h"
#import "Cells.h"
#import "SleepSetting.h"
#import "SetSleepModeCon.h"
#import "SetAutolockCon.h"
#import "SleepControl.h"
#import "SlickTimeAppDelegate.h"
#import "CentralControl.h"
#import "Button.h"
#import "HowToScreenCon.h"
#import "Common.h"

@implementation SettingsRootViewCon
@synthesize alarmList, autolockButton, helpButton;
@synthesize editButton;
@synthesize sleepSwitch;
- (id) init
{
	if ((self = [super initWithNibName:@"PlainTableView" bundle:nil])) {
		self.view.backgroundColor = [UIColor clearColor]; 
        isEditing = NO;
	}

	return self;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    
    UIButton *saveButon = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 35)] autorelease];
    [saveButon setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [saveButon addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSave = [[[UIBarButtonItem alloc] initWithCustomView:saveButon] autorelease]; 

    self.navigationItem.leftBarButtonItem = btnSave;
    
    self.editButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 33)] autorelease];
    [editButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnEdit = [[[UIBarButtonItem alloc] initWithCustomView:editButton] autorelease]; 
    self.navigationItem.rightBarButtonItem = btnEdit;
    
    self.tableView.frame = CGRectMake(0, 0, 320, 416);
    isEditing = NO;
    /*
    self.autolockButton = [Button autolockButton:[UIImage imageNamed:@"autolock_off"] target:self method:@selector(setScreenlock) tag:0];
    [autolockButton setCenter:CGPointMake(44, 380)];
    [autolockButton setAlpha:0.75];
    */
    if ([SleepSetting sharedSleepSetting].autoLockEnabled)
        [autolockButton setImage:[UIImage imageNamed:@"autolock_on"] forState:UIControlStateNormal];
    [self.view addSubview:autolockButton];
    
    
    self.helpButton = [Button bellButton:[UIImage imageNamed:@"help"] target:self method:@selector(helpButtonPressed) tag:1];
    [helpButton setCenter:CGPointMake(295, 380)];
    [self.view addSubview:helpButton];
    
    self.title = @"Alarms";
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sleepDidFinish) name:kNotificationSleepDidFinish object:nil];
    
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationSleepDidFinish object:nil];
}

- (void)sleepDidFinish
{
    [self.sleepSwitch setOn:NO];
}

    


- (void)loadArrayData:(BOOL)hasAlarms {
	//Super goes at the top of this
	[super loadArrayData:NO];
		
	
	//The first cell will always be to set a new alarm	
	SetAlarmViewCon *setAlarmViewCon = [[[SetAlarmViewCon alloc] initWithNibName:@"SetAlarmView" bundle:nil] autorelease];
	setAlarmViewCon.title = @"Alarms";
	
	[tableList_0 addObject:@"New Alarm"];
	
	[controllers addObject:setAlarmViewCon];
	[sections addObject:controllers];
	
	
    self.alarmList = nil;
	
	if ( [Alarm numOfAlarms] > 0 ) 
		[self addAlarmViewCons];
	
}

- (void)addAlarmViewCons {

    if ( sections.count < 2 ) [sections addObject:tableList_1];

	
	self.alarmList = [Alarm allAlarms];
	int num = [alarmList count];
    [tableList_1 removeAllObjects];
	
	for (int i = 0; i < num; i++) {
        Alarm *tmp = (Alarm *)[alarmList objectAtIndex: i];
        NSString *str = (NSString *)[tmp alarmTimeString];
        if (str == nil)
            str = @"";
		[tableList_1 addObject: str];
	}
	
}


- (void)disableAutoLock
{
    [autolockButton setImage:[UIImage imageNamed:@"autolock_off"] forState:UIControlStateNormal];
}

- (void)setScreenlock {
    
    NSString *message = @"This button allows you to disable or enable the default screen lock while Good Morning! Alarm Clock is being used. By \"unlocking\" this feature, Good Morning!Alarm Clock will not allow the screen to turn off while it's being used.\n\n CAUTION:it is recommended that you charge your device while this feature is being used, because constant screen brightness will deplete the battery faster than usual.";
    
    float batteryLevel = getBatteryLevel();
    NSLog(@"Battery Level %g", batteryLevel);
    
    if ( [SleepSetting sharedSleepSetting].autoLockEnabled == YES ) {
        

        [autolockButton setImage:[UIImage imageNamed:@"autolock_off"] forState:UIControlStateNormal];
        [SleepSetting sharedSleepSetting].autoLockEnabled = NO;
         
    }
    else {
        
        if (0 <= batteryLevel && batteryLevel <= 0.25)
        {
            message = @"Your battery is under safe level.";
            //        [autolockButton setTitle: @"Unlocked" forState:UIControlStateNormal];
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Screen Auto-Lock"
                                                             message:message 
                                                            delegate:nil 
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil] autorelease];
            
            [alert show];
            return;
        }
        else if (batteryLevel > 0)
        {
            message = @"Your battery is unplugged. The autolock setting will be canceled when the battery becomes under 25%";
            //        [autolockButton setTitle: @"Unlocked" forState:UIControlStateNormal];
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Screen Auto-Lock"
                                                             message:message 
                                                            delegate:nil 
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil] autorelease];
            
            [alert show];
        }
        
        [autolockButton setImage:[UIImage imageNamed:@"autolock_on"] forState:UIControlStateNormal];
        [SleepSetting sharedSleepSetting].autoLockEnabled = YES;
    }
        
}

- (void)onTapAddAlarmButton
{
    SetAlarmViewCon *nextController = (SetAlarmViewCon *)[controllers objectAtIndex:0];
    
    // Create a new alarm (using newAlarm so it's inserted in the list of Alarms) and edit it:
    Alarm *alarm = [Alarm newAlarm];
    [alarm setDefaultValues];
    [alarm startEditing];
    
    //Push
    [self.navigationController pushViewController:nextController animated:YES]; 
    [nextController refreshData];
}

- (void)buttonResponse 
{
}

- (void)alarmOnButtonPressed:(id)sender
{
    if (isEditing)
        return;
    UISwitch *alarmSwitch = (UISwitch *)sender;
    int index = alarmSwitch.tag;
    Alarm *tmp = (Alarm *)[alarmList objectAtIndex: (index - 1)];
    tmp.alarmOn = alarmSwitch.isOn;
}

- (void)sleepSwitchChanged:(id)sender
{
    UISwitch *switchButton = (UISwitch *)sender;
    SleepSetting *setting = [SleepSetting sharedSleepSetting];
    setting.sleepOn= switchButton.isOn;
    if (switchButton.isOn)
    {
        if (setting.musicList.count == 0 && setting.musicOn)
            [switchButton setOn:NO animated:YES];
        else
            [SleepControl startSleepMusic];

    }
    else
        [SleepControl stopSleepMusic];
}

- (void)pushNextController: (id)sender {

//	[UIView beginAnimations:@"boop" context:nil];
//	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//	[UIView setAnimationDuration:0.15];
//	[UIView setAnimationDelegate:self];
//	[UIView setAnimationDidStopSelector:@selector(reverse) ];
//	
//	self.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
//	
//	[UIView commitAnimations];
	
}

- (void)reverse {
	
//	[UIView beginAnimations:@"boop" context:nil];
//	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//	[UIView setAnimationDuration:0.15];
//	
//	self.view.transform = CGAffineTransformIdentity;
//	
//	[UIView commitAnimations];
	
}














#pragma mark -
#pragma mark TableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (isEditing)
        return 1;
    return 3;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isEditing)
    {
        return [tableList_1 count];
    }
    if (section == 0)
        return (tableList_1.count + 1);
    if (section == 1)
        return 2;
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UITableViewCell *cell = nil;
	static NSString *rootLevelAString = @"RootLevelAString";
	static NSString *rootLevelBString = @"RootLevelBString";
    static NSString *rootLevelCString = @"RootLevelCString";
    static NSString *rootLevelDString = @"RootLevelDString";
	static NSString *rootLevelEditString = @"RootLevelEditString";
	NSUInteger row = [indexPath row];
	
    //For Editing
    if (isEditing)
    {
        NSString *text = [tableList_1 objectAtIndex:row];
		
		cell = [tableView1 dequeueReusableCellWithIdentifier:rootLevelEditString];
		
		if (cell == nil) 
			cell = [Cells cellOneBWithIdentifier:rootLevelBString text:text buttonTarget:self selector:@selector(buttonResponse) buttonTag:row];
        [cell.textLabel setText:text];
        return cell;
    }
    
	if (indexPath.section == 0) {
	
		NSUInteger row = [indexPath row];
        if (row == 0)
        {
            NSString *text = [tableList_0 objectAtIndex:row];

        
            cell = [tableView1 dequeueReusableCellWithIdentifier:rootLevelAString];
        
            if (cell == nil) 
                cell = [Cells cellOneAWithIdentifier:rootLevelAString text:text buttonTarget:self selector:@selector(onTapAddAlarmButton) buttonTag:row];
            [cell.textLabel setText:text];
        }
        else
        {
            NSString *text = [tableList_1 objectAtIndex:(row - 1)];
            
            
            Alarm *tmp = (Alarm *)[alarmList objectAtIndex: (row - 1)];
            
            cell = [tableView1 dequeueReusableCellWithIdentifier:rootLevelBString];
            
            if (cell == nil) 
                cell = [Cells cellFourWithIdentifier:rootLevelEditString text:text buttonTarget:self selector:@selector(alarmOnButtonPressed:) switchStartsOn:tmp.alarmOn buttonTag:row];
            [cell.textLabel setText:text];
            [((UISwitch*)cell.accessoryView) setOn:tmp.alarmOn];
            [((UISwitch*)cell.accessoryView) addTarget:self action:@selector(alarmOnButtonPressed:) forControlEvents:UIControlEventValueChanged];
        }

	}
    else if (indexPath.section == 1)
    {
        NSUInteger row = [indexPath row];
        //SleepMode
        if (row == 0)
        {

            cell = [Cells cellFourWithIdentifier:rootLevelEditString text:@"Sleep Mode" buttonTarget:self selector:@selector(sleepSwitchChanged:) switchStartsOn:[SleepSetting sharedSleepSetting].sleepOn buttonTag:row];
            self.sleepSwitch = (UISwitch *)cell.accessoryView;
        }
        else if (row == 1)
        {
            cell = [tableView1 dequeueReusableCellWithIdentifier:rootLevelCString];
            
            NSString *text = @"";
            switch ([SleepSetting sharedSleepSetting].sleepMode) {
                case SleepModeOptionOneMinute:
                    text = @"Play 1 Minute";
                    break;
                case SleepModeOptionThreeMinutes:
                    text = @"Play 3 Minutes";
                    break;
                case SleepModeOptionTenMinutes:
                    text = @"Play 10 Minutes";
                    break;
                case SleepModeOptionThirtyMinutes:
                    text = @"Play 30 Minutes";
                    break;
                case SleepModeOptionOneHour:
                    text = @"Play 1 Hour";
                    break;
                case SleepModeOptionUntilAlarm:
                    text = @"Play Until Alarm";
                    break;
                default:
                    text = @"Off";
                    break;
            }
            if (cell == nil) 
                cell = [Cells cellOneBWithIdentifier:rootLevelCString text:text buttonTarget:self selector:@selector(buttonResponse) buttonTag:row];
            
            cell.textLabel.textColor = SLICK_TIME_BLUE_COLOR;
            cell.textLabel.font = SLICK_TIME_DETAIL_LABEL_FONT;
            cell.textLabel.text = text;
        }
    }
    else if (indexPath.section == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:rootLevelCString];
        
        NSString *text = @"";
        //Auto Lock mode
        
        switch ([SleepSetting sharedSleepSetting].autoLockMode) {
            case AutoLockOptionFiveMinutes:
                text = @"5 Minutes";
                break;
            case AutoLockOptionTenMinutes:
                text = @"10 Minutes";
                break;
            case AutoLockOptionFifteenMinutes:
                text = @"15 Minutes";
                break;
            case AutoLockOptionThirtyMinutes:
                text = @"30 Minutes";
                break;
            case AutoLockOptionOneHour:
                text = @"One Hour";
                break;
            default:
                text = @"Never";
                break;
        }
        
        if (cell == nil) 
            cell = [Cells cellTwoWithIdentifier:rootLevelDString text:@"Auto Lock" buttonTarget:self selector:@selector(buttonResponse) detailLabelText:text buttonTag: row];
        cell.detailTextLabel.text = text;
        cell.detailTextLabel.font = SLICK_TIME_DETAIL_LABEL_FONT;
        cell.detailTextLabel.textColor = SLICK_TIME_BLUE_COLOR;
        
    }
		
	return cell;	
}














#pragma mark -
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	[tableView1 deselectRowAtIndexPath:indexPath animated:YES];

    if (isEditing)
        return;
    int row = indexPath.row, section = indexPath.section;
	//Alarm Setting
	if ( section == 0 )
	{
        //Add New Aalrm
        if (row == 0)
        {
            SetAlarmViewCon *nextController = (SetAlarmViewCon *)[controllers objectAtIndex:indexPath.row];
            
            // Create a new alarm (using newAlarm so it's inserted in the list of Alarms) and edit it:
            Alarm *alarm = [Alarm newAlarm];
            [alarm setDefaultValues];
            [alarm startEditing];
            
            //Push
            [self.navigationController pushViewController:nextController animated:YES]; 
            [nextController refreshData];
        }
        else
            
        {
            SetAlarmViewCon *nextController = (SetAlarmViewCon *)[controllers objectAtIndex:0]; //Always the same viewCon, but it populates itself based
                  
            //on "alarmBeingEdited"
            
            [Alarm cleanUnusedAlarm];
            Alarm *tmp = [alarmList objectAtIndex: (row - 1)];
            [tmp startEditing];
            
            [self.navigationController pushViewController:nextController animated:YES]; 
            [nextController refreshData];

        }
	}
    else if (section == 1)
    {
        SetSleepModeCon *con = [[[SetSleepModeCon alloc] initWithNibName:@"SetSleepMode" bundle:nil] autorelease];
        [self.navigationController pushViewController:con animated:YES];
        [con viewDidAppear:YES];
    }
    else if (section == 2)
    {
        SetAutolockCon *con = [[[SetAutolockCon alloc] initWithNibName:@"SetAutolock" bundle:nil] autorelease];
        [self.navigationController pushViewController:con animated:YES];
        [con viewDidAppear:YES];
    }

}
- (void)tableView:(UITableView *)tableView1 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        int row = indexPath.row;
        Alarm *tmp = [alarmList objectAtIndex:row];
        [tableList_1 removeObjectAtIndex:row];

        [tableView1 deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [Alarm deleteAlarm:tmp];
        self.alarmList = [Alarm allAlarms];
        
    }
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEditing)
        return YES;
    return NO;
}


- (void)saveButtonPressed
{
    [Alarm saveAlarms];
    [Alarm scheduleAll];
    SlickTimeAppDelegate *del = (SlickTimeAppDelegate *)APP_DELEGATE;
    [SleepSetting saveSleepSetting];
    [del.centralCon flipView];

}
- (void)editButtonPressed
{
    isEditing = !isEditing;
    [tableView reloadData];
    if (isEditing)
    {
        [editButton setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
        self.title = @"Edit Alarms";
        [tableView setEditing:YES];
    }
    else
    {
        [editButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
        self.title = @"Alarms";
        [tableView setEditing:NO];
    }
    
    
}

- (void)helpButtonPressed
{
    if ([self.navigationController isMovingToParentViewController])
        return;
    UIViewController * controller = [[HowToScreenCon alloc] initWithNibName:@"HowToScreen" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];

    [controller release];
}

- (void)showHelp
{
    HowToScreenCon * controller = [[HowToScreenCon alloc] initWithNibName:@"HowToScreen" bundle:nil];
    [self.navigationController pushViewController:controller animated:NO];
    controller.shouldClose = YES;
    [controller release];
}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController != self) 
    {
        [navigationController setDelegate:(id<UINavigationControllerDelegate>)viewController];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self)
    {
        self.alarmList = [Alarm allAlarms];
        int num = [alarmList count];
        [tableList_1 removeAllObjects];
        for (int i = 0; i < num; i++) {
            Alarm *tmp = (Alarm *)[alarmList objectAtIndex: i];
            NSString *str = (NSString *)[tmp alarmTimeString];
            if (str == nil)
                str = @"";
            [tableList_1 addObject: str];
        }
        
        [self.tableView reloadData];
        
    }
}

#pragma mark - Dealloc

- (void) dealloc
{
	[autolockButton release];
    [alarmList release];
    [helpButton release];
    [editButton release];
	[super dealloc];
}



@end
