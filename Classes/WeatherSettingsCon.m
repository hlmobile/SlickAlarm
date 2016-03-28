//
//  WeatherSettingsCon.m
//  SlickTime
//
//  Created by Miles Alden on 6/13/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "WeatherSettingsCon.h"
#import "SlickTimeAppDelegate.h"
#import "CentralControl.h"
#import "WeatherSetting.h"
#import "LocationSearchController.h"

@implementation WeatherSettingsCon
@synthesize tblWeather;

#pragma mark - Dealloc

- (void)dealloc
{
    [tblWeather release];
    [super dealloc];
}

#pragma mark - Initialize
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tblWeather.backgroundColor = [UIColor clearColor];
    tblWeather.opaque = NO;
    tblWeather.clearsContextBeforeDrawing = NO;
    tblWeather.editing = YES;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    if (section == 2)
        return 1;
    
    return [WeatherSetting countOfPlaces];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Local Weather
    if (indexPath.section == 0)
    {
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"Weather";
        
        UISwitch *switchView = [[[UISwitch alloc] initWithFrame:CGRectMake(230, 10, 100, 40)] autorelease];
        [switchView setOn:[WeatherSetting isWeatherEnabled]];
        [switchView addTarget:self action:@selector(localWeatherSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        //[cell addSubview:switchView];
        cell.accessoryView = switchView;
        return cell;
    }
    else if (indexPath.section == 2)
    {
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        
        
        NSArray *items = [NSArray arrayWithObjects:@"°C", @"°F", nil];
        UISegmentedControl *segment = [[[UISegmentedControl alloc] initWithItems:items] autorelease];
        segment.frame = CGRectMake(10, 0, 300, 44);
        [cell addSubview:segment];
        
        int selectedIndex = [WeatherSetting isCelcius] ? 0 : 1;
        [segment setSelectedSegmentIndex:selectedIndex];
        [segment addTarget:self action:@selector(temperatureFormatChanged:) forControlEvents:UIControlEventValueChanged];
        
        return cell;
    }
    
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setShowsReorderControl:YES];
    NSLog(@"%d", cell.showsReorderControl);
    Place *place = [WeatherSetting placeAtIndex:indexPath.row];
    cell.textLabel.text = place.name;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
        return UITableViewCellEditingStyleDelete;
    return UITableViewCellEditingStyleNone;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section)
        return sourceIndexPath;
    return proposedDestinationIndexPath;
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
        return YES;
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
        return YES;
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && editingStyle == UITableViewCellEditingStyleDelete)
    {
        [WeatherSetting removePlaceAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath.section != 1)
        return;
    [WeatherSetting movePlaceFromIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - IBActions

- (IBAction)addButtonPressed:(id)sender
{
    if ([WeatherSetting countOfPlaces] >= 10)
    {
        UIAlertView *alert = [[[UIAlertView alloc] 
                              initWithTitle:@"nil" 
                              message:@"You can't add more cities" 
                              delegate:nil 
                              cancelButtonTitle:@"OK" 
                               otherButtonTitles:nil] autorelease];
        [alert show];
        return;
    }
    LocationSearchController *controller = [[[LocationSearchController alloc] initWithNibName:@"LocationSearchController" bundle:nil] autorelease];
    controller.delegate = self;
    [self presentModalViewController:controller animated:YES];
}
- (IBAction)doneButtonPressed:(id)sender
{
    SlickTimeAppDelegate *del = (SlickTimeAppDelegate *)APP_DELEGATE;
    [del.centralCon finishWeatherSetting];
}

- (void)localWeatherSwitchChanged:(id)sender
{
    UISwitch *switchView = (UISwitch*)sender;
    [WeatherSetting setWeatherEnabled:switchView.isOn];
}
- (void)temperatureFormatChanged:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    if (segment.selectedSegmentIndex == 0)
        [WeatherSetting setIsCelcius:YES];
    else
        [WeatherSetting setIsCelcius:NO];
}



#pragma mark - LocationSearchControllerDelegate

- (void)didSelectPlaceItem:(Place *)placeItem
{
    [WeatherSetting addPlace:placeItem];
    [tblWeather reloadData];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didCancelLocationSearch
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
