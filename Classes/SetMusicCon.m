//
//  SetMusicCon.m
//  SlickTime
//
//  Created by Jin Bei on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SetMusicCon.h"
#import "SlickTimeAppDelegate.h"

#import "Alarm.h"
#import "Cells.h"
#import "SetAlarmViewCon.h"
#import "SettingsRootViewCon.h"
@implementation SetMusicCon
@synthesize vcParent;
@synthesize audioPlayer;
@synthesize sgmMusic;
@synthesize editButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        Alarm *currentAlarm = [Alarm currentAlarmBeingEdited];
        selectedRow = currentAlarm.alarmSound;
    }
    return self;
}


- (void)viewDidLoad {
	
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor clearColor];
	[self loadArrayData:NO];
	self.title = @"Alarm Music";
    
    UIButton *backButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 35)] autorelease];
    [backButton setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnBack = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease]; 
    
    self.navigationItem.leftBarButtonItem = btnBack;
    
    
    
    self.editButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 33)] autorelease];
    [editButton setImage:[UIImage imageNamed:@"done@2x~iphone"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnEdit = [[[UIBarButtonItem alloc] initWithCustomView:editButton] autorelease]; 
    self.navigationItem.rightBarButtonItem = btnEdit;
    isEditing = YES;
    
    [self.tableView setEditing:YES];
    [self.tableView setAllowsSelectionDuringEditing:YES];
    
    Alarm *currentAlarm = [Alarm currentAlarmBeingEdited];
    if (currentAlarm.playFromLibrary)
    {
        [sgmMusic setSelectedSegmentIndex:1];
        self.tableView.editing = YES;
        editButton.hidden = NO;        
    }
    else
    {
        [sgmMusic setSelectedSegmentIndex:0];
        self.tableView.editing = NO;
        editButton.hidden = YES;
    }
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
		self->tableList_0 = [[NSMutableArray alloc] initWithObjects:ALARM_SOUND_LIST, nil];
	}
	
}


- (void)buttonResponse {}


#pragma mark -
#pragma mark TableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Alarm *currentAlarm = [Alarm currentAlarmBeingEdited];
    if (currentAlarm.playFromLibrary)
    {
        if (isEditing)
            return [currentAlarm.musicList count] + 1;
        return [currentAlarm.musicList count];
    }
	return [tableList_0 count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    
    static NSString *CellIdentifier = @"Cell";
    
    Alarm *currentAlarm = [Alarm currentAlarmBeingEdited];
    if (currentAlarm.playFromLibrary)
    {
        UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        if (isEditing)
        {
            if (indexPath.row == 0)
            {
                cell.textLabel.text = @"Add song";
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }
            else
            {
                NSDictionary *musicInfo = [currentAlarm.musicList objectAtIndex:indexPath.row - 1];
                NSString *musicTitle = [musicInfo objectForKey:@"title"];
                cell.textLabel.text =  musicTitle;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.showsReorderControl = NO;
        }
        else
        {
            NSDictionary *musicInfo = [currentAlarm.musicList objectAtIndex:indexPath.row];
            NSString *musicTitle = [musicInfo objectForKey:@"title"];
            cell.textLabel.text =  musicTitle;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.showsReorderControl = YES;
        }
        cell.showsReorderControl = YES;
        
        NSLog(@"showReorderControl %d", cell.showsReorderControl);
        // Configure the cell...
        
        return cell;
    }
    else
    {
        
        static NSString *setAutolockString = @"SetAutolockString";
        UITableViewCell *cell;
        NSUInteger row = [indexPath row];
        
        
        cell = [tableView1 dequeueReusableCellWithIdentifier:setAutolockString];
        
        
        NSString *text = ( row < [tableList_0 count] ) ? [tableList_0 objectAtIndex:row] : nil;
        
        if (cell == nil) 
            cell = [Cells cellZeroWithIdentifier:setAutolockString text:text buttonTarget:self selector:@selector(buttonResponse) buttonTag:row];
        
        cell.textLabel.text = text;
        if (row == selectedRow)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;

        return cell;	
    }
}








#pragma mark -
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView1 deselectRowAtIndexPath:indexPath animated:YES];
	
    Alarm *currentAlarm = [Alarm currentAlarmBeingEdited];
    if (currentAlarm.playFromLibrary)
    {
        if (isEditing)
        {
            if (indexPath.row == 0)
            {
                MPMediaPickerController * picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAny];
                if (picker != nil)
                {
                    picker.delegate = self;
                    picker.allowsPickingMultipleItems = YES;
                    picker.prompt = @"Select musics to play";
                    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    [self presentModalViewController:picker animated:YES];
                    [picker release];
                    
                }
            }
        }
    }
    else
    {
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
	
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView_ editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Alarm *currentAlarm = [Alarm currentAlarmBeingEdited];
    if (currentAlarm.playFromLibrary)
    {
        [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
        if (isEditing)
        {
            if (indexPath.row == 0)
                return UITableViewCellEditingStyleInsert;
            return UITableViewCellEditingStyleDelete;
            NSLog(@"Editing Style");
        }
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Alarm *currentAlarm = [Alarm currentAlarmBeingEdited];
    if (currentAlarm.playFromLibrary)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            [currentAlarm.musicList removeObjectAtIndex:(indexPath.row - 1)];
            [self.tableView reloadData];
            
        }
        else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            MPMediaPickerController * picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
            if (picker != nil)
            {
                picker.delegate = self;
                picker.allowsPickingMultipleItems = YES;
                picker.prompt = @"Select musics to play";
                picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                [self presentModalViewController:picker animated:YES];
                [picker release];
                
            }
            
        }   
    }
}

#pragma mark MPMediaPickerControllerDelegate
- (void) mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    Alarm *currentAlarm = [Alarm currentAlarmBeingEdited];
    if (currentAlarm.playFromLibrary)
    {
        [mediaPicker dismissModalViewControllerAnimated:YES];
        NSLog (@"Picker count %d", [mediaItemCollection count]);
        NSArray *items = [mediaItemCollection items];
        for (MPMediaItem *item in items) {
            NSNumber *persistentId = [item valueForProperty:MPMediaItemPropertyPersistentID];
            NSString *musicTitle = [item valueForProperty:MPMediaItemPropertyTitle];
            NSDictionary *musicInfo = [NSDictionary dictionaryWithObjectsAndKeys:persistentId, @"pid", musicTitle, @"title", nil];
            [currentAlarm.musicList addObject:musicInfo];
            
            NSLog(@"%@, %@", [item valueForProperty:MPMediaItemPropertyPersistentID], [item valueForProperty:MPMediaItemPropertyTitle]);
        }
        [self.tableView reloadData];
    }
    
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [mediaPicker dismissModalViewControllerAnimated:YES];
}



- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    Alarm *currentAlarm = [Alarm currentAlarmBeingEdited];
    if (currentAlarm.playFromLibrary)
    {
        if (isEditing)
            return NO;
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    Alarm *currentAlarm = [Alarm currentAlarmBeingEdited];
    if (currentAlarm.playFromLibrary)
    {
        NSLog(@"Moving source:%d , destination:%d", sourceIndexPath.row, destinationIndexPath.row);
        if (sourceIndexPath.row < 0 || sourceIndexPath.row >= [currentAlarm.musicList count])
            return;
        if (destinationIndexPath.row < 0 || destinationIndexPath.row >= [currentAlarm.musicList count])
            return;
        if (destinationIndexPath.row == sourceIndexPath.row)
            return;
        NSDictionary *musicInfo = [[currentAlarm.musicList objectAtIndex:sourceIndexPath.row] retain];
        [currentAlarm.musicList removeObjectAtIndex:sourceIndexPath.row];
        [currentAlarm.musicList insertObject:musicInfo atIndex:destinationIndexPath.row];
        [musicInfo release];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


#pragma mark - Actions
- (void)editButtonPressed:(id)sender
{
    
    isEditing = !isEditing;
    if (isEditing)
    {
        [editButton setImage:[UIImage imageNamed:@"done@2x~iphone"] forState:UIControlStateNormal];
        
    }
    else
    {
        [editButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController != self) 
    {
        Alarm *currentAlarm = [Alarm currentAlarmBeingEdited];
        currentAlarm.alarmSound = selectedRow;
        [vcParent refreshData];
        if (audioPlayer)
        {
            [audioPlayer stop];
            [audioPlayer release];
            audioPlayer = nil;
        }
        
        [navigationController setDelegate:(id<UINavigationControllerDelegate>)viewController];
    }
}

#pragma mark - IBAction
- (IBAction)segmentButtonPressed:(id)sender
{
    Alarm *currentAlarm = [Alarm currentAlarmBeingEdited];
    if (sgmMusic.selectedSegmentIndex == 0)
    {
        currentAlarm.playFromLibrary = NO;
        self.tableView.editing = NO;
        editButton.hidden = YES;
    }
    else
    {
        currentAlarm.playFromLibrary = YES;
        self.tableView.editing = YES;
        editButton.hidden = NO;
        if (self.audioPlayer != nil)
            [self.audioPlayer stop];
    }
    [self.tableView reloadData];
}

#pragma mark - Dealloc
- (void)dealloc
{
    [audioPlayer release];
    [sgmMusic release];
    [super dealloc];
}


@end