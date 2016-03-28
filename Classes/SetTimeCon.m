//
//  SetTimeCon.m
//  SlickTime
//
//  Created by Miles Alden on 5/5/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "SetTimeCon.h"
#import "Cells.h"
#import "SlickTimeAppDelegate.h"
#import "SetAlarmViewCon.h"
#import "Alarm.h"
#import "Button.h"

@implementation SetTimeCon
@synthesize vcParent;

- (void)viewDidLoad {

    [super viewDidLoad];
	self.title = @"Set Alarm Time";
	[self loadArrayData:NO];
	
	self.view.backgroundColor = [UIColor clearColor];
	
	datePicker.frame = DATE_PICKER_FRAME_OFF;
if ( datePicker == nil ) 
	{
		self->datePicker = [[UIDatePicker alloc] init];
		[datePicker setDatePickerMode:UIDatePickerModeTime];
	}
    
	
	//Add to view
	[self.view addSubview:datePicker];
    NSDate *time = [Alarm currentAlarmBeingEdited].alarmTime;
    if (time)
        [datePicker setDate:time];
    else
        [datePicker setDate:[NSDate date]];
	
	[self.tableView reloadData];
    
    
    UIButton *cancelButton = [Button cancelButton:nil target:self method:@selector(buttonResponse:) tag:1];
    UIBarButtonItem *btnCancel = [[[UIBarButtonItem alloc] initWithCustomView:cancelButton] autorelease]; 
    
    self.navigationItem.leftBarButtonItem = btnCancel;
    
    UIButton *doneButton = [Button doneButton:nil target:self method:@selector(buttonResponse:) tag:2];
    UIBarButtonItem *btnDone = [[[UIBarButtonItem alloc] initWithCustomView:doneButton] autorelease]; 
    self.navigationItem.rightBarButtonItem = btnDone;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)slidePickerUp {

	
	//Set frames as off-screen bottom in portrait (Created with IB)
	

	
	
	datePicker.frame = DATE_PICKER_FRAME_OFF;
	
	//Animate
	[UIView beginAnimations:@"pickerSlideUp" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4];
	
	datePicker.frame = DATE_PICKER_FRAME;
	
	[UIView commitAnimations];
}


- (void)slidePickerDown {

	//Animate
	[UIView beginAnimations:@"pickerSlideUp" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.1];

	
	datePicker.frame = DATE_PICKER_FRAME_OFF;
	
	[UIView commitAnimations];
	
}

- (void)didSlidePickerDown {

	
	if ( datePicker ) {
		[datePicker removeFromSuperview];
		[datePicker release];
		self->datePicker = nil;
	}
	
}


- (void)loadArrayData:(BOOL)hasAlarms {

	[super loadArrayData:NO];
    
	[controllers addObject:@"String"];
	[sections addObject:controllers];
	
	[tableList_0 addObject:@"Time"];
	
    Alarm *currentAlarm = [Alarm currentAlarmBeingEdited];
	if (currentAlarm.alarmTime != nil )
		[tableList_1 addObject:[currentAlarm alarmTimeString]];
}





- (IBAction)buttonResponse: (id)sender {

	
	//If done button
	if ( [(UIButton *)sender tag] == 2 )
		[self markTime];
	
	[self.navigationController popViewControllerAnimated:YES];

}

- (void)markTime {

	Alarm *currentAlarm = [Alarm currentAlarmBeingEdited];

	if ( currentAlarm ) {
		[currentAlarm setAlarmTime:datePicker.date];
		NSString *timeString = [currentAlarm alarmTimeString];
		if ( tableList_1.count > 0 )
			[tableList_1 replaceObjectAtIndex:0 withObject: timeString];
		else [tableList_1 addObject: timeString];
	}
}





















#pragma mark -
#pragma mark TableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [sections count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [controllers count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	static NSString *setTimeString = @"SetTimeString";
	UITableViewCell *cell;
	NSUInteger row = [indexPath row];
	
	
	cell = [tableView1 dequeueReusableCellWithIdentifier:setTimeString];
	
	
	NSString *text = ( row < [tableList_0 count] ) ? [tableList_0 objectAtIndex:row] : nil;
	NSString *detail = ( row < [tableList_1 count] ) ? [tableList_1 objectAtIndex:row] : @"None";
	//row < [tableList_1 count] )
	
	if (cell == nil) 
		cell = [Cells cellThreeWithIdentifier:setTimeString text:text buttonTarget:self selector:@selector(buttonResponse) detailLabelText:detail buttonTag:row];

	NSLog(@"\n detail: %@\n", detail);
	cell.detailTextLabel.text = detail;
	
	
	return cell;	
}















#pragma mark -
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView1 deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {}





#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController != self) 
    {
        [vcParent refreshData];
        [self slidePickerDown];
        [navigationController setDelegate:(id<UINavigationControllerDelegate>)viewController];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self)
    {
        NSDate *time = [Alarm currentAlarmBeingEdited].alarmTime;
        if (time)
            [datePicker setDate:time];
        else
            [datePicker setDate:[NSDate date]];
        [self slidePickerUp];
    }
}

- (void)dealloc {
	

	
	if ( datePicker ) {
		[datePicker release];
		self->datePicker = nil;
	}

	[super dealloc];
}

@end
