//
//  SetMusicCon.m
//  SlickTime
//
//  Created by Jin Bei on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SetWhiteNoiseCon.h"
#import "SlickTimeAppDelegate.h"

#import "SleepSetting.h"
#import "Cells.h"
#import "SetAlarmViewCon.h"
#import "SettingsRootViewCon.h"
@implementation SetWhiteNoiseCon

@synthesize audioPlayer;

- (void)dealloc
{
    [audioPlayer release];
    [super dealloc];
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor clearColor];
	[self loadArrayData:NO];
    selectedRow = [SleepSetting sharedSleepSetting].sleepSound;
	self.title = @"White Noise";
    
}


- (void)loadArrayData:(BOOL)hasAlarms {
	
	[super loadArrayData:NO];
	
	[controllers addObject:@"String"];
	[sections addObject:controllers];
	if ( tableList_0 ) {
		[tableList_0 release];
		self->tableList_0 = nil;
		self->tableList_0 = [[NSMutableArray alloc] initWithObjects:WHITE_NOISE_LIST, nil];
	}
	
}



- (void)buttonResponse {}


#pragma mark -
#pragma mark TableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [tableList_0 count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell;
    NSUInteger row = [indexPath row];
    
    
    cell = [tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    NSString *text = ( row < [tableList_0 count] ) ? [tableList_0 objectAtIndex:row] : nil;
    
    if (cell == nil) 
        cell = [Cells cellZeroWithIdentifier:CellIdentifier text:text buttonTarget:self selector:@selector(buttonResponse) buttonTag:row];
    
    cell.textLabel.text = text;
    if (row == selectedRow)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
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
        
        UITableViewCell *oldCell = [tableView1 cellForRowAtIndexPath: [NSIndexPath indexPathForRow:selectedRow inSection:0]]; 
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        selectedRow = newRow;
        
        if (self.audioPlayer != nil)
            [self.audioPlayer stop];
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:[tableList_0 objectAtIndex:newRow] ofType:@"mp3"];
        NSURL *soundURL = [[[NSURL alloc] initFileURLWithPath:soundPath] autorelease];
        self.audioPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil] autorelease];
        audioPlayer.numberOfLoops = 1;
        [audioPlayer prepareToPlay];
        [audioPlayer play];

    }
	
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController != self) 
    {
        
        [SleepSetting sharedSleepSetting].sleepSound = selectedRow;
        [SleepSetting saveSleepSetting];
        [navigationController setDelegate:(id<UINavigationControllerDelegate>)viewController];
        
        if (audioPlayer)
        {
            [audioPlayer stop];
            [audioPlayer release];
            audioPlayer = nil;
        }
    }
}

@end