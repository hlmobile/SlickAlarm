//
//  Cells.m
//  SlickTime
//
//  Created by Miles Alden on 5/5/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "Cells.h"


@implementation Cells






//Black cell with no disclosure button
+ (UITableViewCell *)cellZeroWithIdentifier: (NSString *)identifier text:(NSString *)text buttonTarget: (id)target selector: (SEL)method buttonTag: (NSInteger) tag {
	
	
	//Check for nils
	if ( identifier == nil ) identifier = @"resuseIdentifier";
	if ( text == nil ) text = @"";
	if ( target == nil ) return nil;
	if ( method == nil ) return nil;
	
	
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
	
	//Format Cell
	cell.textLabel.text = text;
	
	return cell;
	
}







//Black cell with disclosure button (add button)
+ (UITableViewCell *)cellOneAWithIdentifier: (NSString *)identifier text:(NSString *)text buttonTarget: (id)target selector: (SEL)method buttonTag: (NSInteger) tag {

	
	//Check for nils
	if ( identifier == nil ) identifier = @"resuseIdentifier";
	if ( text == nil ) text = @"";
	if ( target == nil ) return nil;
	if ( method == nil ) return nil;
	
	
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
	
	
	
	//Disclosure button
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	UIImage *img = [UIImage imageNamed:@"add_button@2x.png"];
	[button setImage:img forState:UIControlStateNormal];
	[button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
	CGSize alphaSize = DISCLOSURE_BUTTON_SIZE;
	button.frame = CGRectMake(0, 0, alphaSize.width, alphaSize.height);
	button.tag = tag;
	
	//Accessory view
	UIView *view = [[UIView alloc] initWithFrame:button.frame];
	[view addSubview:button];
	
	
	//Format Cell
	cell.textLabel.text = text;
	cell.accessoryView = view;
	
	
	[view release];
	
	
	
	return cell;

}



+ (UITableViewCell *)cellOneBWithIdentifier: (NSString *)identifier text:(NSString *)text buttonTarget: (id)target selector: (SEL)method buttonTag: (NSInteger)tag
{
	//Check for nils
	if ( identifier == nil ) identifier = @"resuseIdentifier";
	if ( text == nil ) text = @"";
	if ( target == nil ) return nil;
	if ( method == nil ) return nil;
	
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
	
	
	
	//Disclosure button
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	UIImage *img = [UIImage imageNamed:@"forward_button@2x.png"];
	[button setImage:img forState:UIControlStateNormal];
	[button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
	CGSize alphaSize = DISCLOSURE_BUTTON_SIZE;
	button.frame = CGRectMake(0, 0, alphaSize.width, alphaSize.height);
	button.tag = tag;
	
	//Accessory view
	UIView *view = [[UIView alloc] initWithFrame:button.frame];
	[view addSubview:button];
	
	
	//Format Cell
	cell.textLabel.text = text;
	cell.accessoryView = view;
	
	
	[view release];
	
	
	
	return cell;
}	







//Black cell with blue detail text and disclosure arrow
+ (UITableViewCell *)cellTwoWithIdentifier: (NSString *)identifier text:(NSString *)text buttonTarget: (id)target selector: (SEL)method detailLabelText:(NSString *)detailText buttonTag: (NSInteger)tag{
	
	
	
	//Check for nils
	if ( identifier == nil ) identifier = @"resuseTwoIdentifier";
	if ( text == nil ) text = @"";
	if ( target == nil ) return nil;
	if ( method == nil ) return nil;
	if ( detailText == nil ) detailText = @"None";
	
	
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
	
	
	
	//Disclosure button
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	UIImage *img = [UIImage imageNamed:@"forward_button@2x~iphone.png"];
	[button setImage:img forState:UIControlStateNormal];
	[button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
	CGSize alphaSize = DISCLOSURE_BUTTON_SIZE;
	button.frame = CGRectMake(0, 0, alphaSize.width, alphaSize.height);
	button.tag = tag;
	
	
	//Accessory view
	UIView *view = [[UIView alloc] initWithFrame:button.frame];
	[view addSubview:button];
	
	
	
	//Format Cell
	cell.textLabel.text = text;
	cell.detailTextLabel.text = detailText;
	cell.detailTextLabel.font = DETAIL_LABEL_FONT;
	cell.accessoryView = view;
	
	
	[view release];
	
	
	
	return cell;
	
	
}













//Black cell with blue detail text (no disclosure button)
+ (UITableViewCell *)cellThreeWithIdentifier: (NSString *)identifier text:(NSString *)text buttonTarget: (id)target selector: (SEL)method detailLabelText:(NSString *)detailText buttonTag: (NSInteger)tag{

	//Check for nils
	if ( identifier == nil ) identifier = @"resuseTwoIdentifier";
	if ( text == nil ) text = @"";
	if ( target == nil ) return nil;
	if ( method == nil ) return nil;
	if ( detailText == nil ) detailText = @"None";
	
	
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
	
	
	//Format Cell
	cell.textLabel.text = text;
	cell.detailTextLabel.text = detailText;
	cell.detailTextLabel.font = DETAIL_LABEL_FONT;
	
	
	return cell;
	
}





















//Black cell with no detail text and switch accessory
+ (UITableViewCell *)cellFourWithIdentifier: (NSString *)identifier text:(NSString *)text buttonTarget: (id)target selector: (SEL)method switchStartsOn:(BOOL)switchOn buttonTag: (NSInteger)tag{
	
	
	
	//Check for nils
	if ( identifier == nil ) identifier = @"resuseTwoIdentifier";
	if ( text == nil ) text = @"";
	if ( target == nil ) return nil;
	if ( method == nil ) return nil;
	
	
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
	
	
	//Switch
	UISwitch *aSwitch = [[UISwitch alloc] init];
	aSwitch.on = switchOn;
	aSwitch.tag = tag;
	[aSwitch addTarget:target action:method forControlEvents:UIControlEventValueChanged];
	
	
	//Format Cell
	cell.textLabel.text = text;
	cell.accessoryView = aSwitch;
	
	[aSwitch release];
	
	
	return cell;
}



@end
