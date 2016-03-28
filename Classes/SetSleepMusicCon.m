//
//  SetSleepMusicCon.m
//  SlickTime
//
//  Created by Miles Alden on 5/13/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "SetSleepMusicCon.h"
#import "SleepSetting.h"

@implementation SetSleepMusicCon

@synthesize musicList;
@synthesize editButton;
#pragma mark - Initialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        isEditing = NO;
        musicList = nil;
        self.musicList = [SleepSetting sharedSleepSetting].musicList;
    }
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIButton *backButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 35)] autorelease];
    [backButton setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSave = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease]; 
    
    self.navigationItem.leftBarButtonItem = btnSave;
    
    self.editButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 33)] autorelease];
    [editButton setImage:[UIImage imageNamed:@"done@2x~iphone"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnEdit = [[[UIBarButtonItem alloc] initWithCustomView:editButton] autorelease]; 
    self.navigationItem.rightBarButtonItem = btnEdit;
    
    [self.tableView setAllowsSelectionDuringEditing:YES];
	self.navigationItem.title = @"Song List";
    isEditing = YES;
    [self.tableView setEditing:YES];

}


- (void)loadArrayData:(BOOL)hasAlarms {
	
	[super loadArrayData:NO];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (isEditing)
        return [musicList count] + 1;
    return [musicList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:CellIdentifier];
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
            NSDictionary *musicInfo = [musicList objectAtIndex:indexPath.row - 1];
            NSString *musicTitle = [musicInfo objectForKey:@"title"];
            cell.textLabel.text =  musicTitle;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.showsReorderControl = NO;
    }
    else
    {
        NSDictionary *musicInfo = [musicList objectAtIndex:indexPath.row];
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
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isEditing)
        return NO;
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSLog(@"Moving source:%d , destination:%d", sourceIndexPath.row, destinationIndexPath.row);
    if (sourceIndexPath.row < 0 || sourceIndexPath.row >= [musicList count])
        return;
    if (destinationIndexPath.row < 0 || destinationIndexPath.row >= [musicList count])
        return;
    if (destinationIndexPath.row == sourceIndexPath.row)
        return;
    NSDictionary *musicInfo = [[musicList objectAtIndex:sourceIndexPath.row] retain];
    [musicList removeObjectAtIndex:sourceIndexPath.row];
    [musicList insertObject:musicInfo atIndex:destinationIndexPath.row];
    [musicInfo release];

}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView_ editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [musicList removeObjectAtIndex:(indexPath.row - 1)];
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
#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected %d", indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)backButtonPressed:(id)sender
{
    [SleepSetting saveSleepSetting];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark MPMediaPickerControllerDelegate
- (void) mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
	[mediaPicker dismissModalViewControllerAnimated:YES];
    NSLog (@"Picker count %d", [mediaItemCollection count]);
    NSArray *items = [mediaItemCollection items];
    for (MPMediaItem *item in items) {
        NSNumber *persistentId = [item valueForProperty:MPMediaItemPropertyPersistentID];
        NSString *musicTitle = [item valueForProperty:MPMediaItemPropertyTitle];
        NSDictionary *musicInfo = [NSDictionary dictionaryWithObjectsAndKeys:persistentId, @"pid", musicTitle, @"title", nil];
        [self.musicList addObject:musicInfo];
        
        NSLog(@"%@, %@", [item valueForProperty:MPMediaItemPropertyPersistentID], [item valueForProperty:MPMediaItemPropertyTitle]);
    }
    [self.tableView reloadData];
    
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [mediaPicker dismissModalViewControllerAnimated:YES];
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
    NSLog(@"Hey here, button pressed%@", self.tableView.isEditing?@"Done":@"Edit");
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController != self) 
    {
        [navigationController setDelegate:(id<UINavigationControllerDelegate>)viewController];
        [SleepSetting saveSleepSetting];
    }
}


#pragma mark NavCon Delegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"a");
}


@end
