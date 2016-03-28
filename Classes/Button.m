//
//  Button.m
//  SlickTime
//
//  Created by Miles Alden on 5/11/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "Button.h"
#import "RadioButton.h"


@implementation Button


//Cancel button
+ (UIButton *)cancelButton:(UIImage *)image target:(id)target method:(SEL)method tag:(int)tag{
	
	if ( image == nil ) image = [UIImage imageNamed:@"cancel@2x~iphone"];
	if ( target == nil ) return nil;
	if ( method == nil ) return nil;
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:image forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 55, 33)];
	[button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
	[button setTag:tag];
	
	return button;
}

//Done button
+ (UIButton *)doneButton:(UIImage *)image target:(id)target method:(SEL)method tag:(int)tag{
	
	if ( image == nil ) image = [UIImage imageNamed:@"done_black@2x~iphone"];
	if ( target == nil ) return nil;
	if ( method == nil ) return nil;
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:image forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 55, 33)];
	[button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
	[button setTag:tag];
    [button setFrame:DONE_BUTTON_FRAME];
	
	return button;
}



+ (UIButton *)deleteButton: (UIButton *)originalButton target:(id)target action: (SEL)action {
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [originalButton setFrame:CGRectMake(0, 0, 308, 40)];
    [originalButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIImage *img = [UIImage imageNamed:@"delete_button"];
    [originalButton setBackgroundImage:[img stretchableImageWithLeftCapWidth:8.0f
                                                                topCapHeight:0.0f]
                                                                forState:UIControlStateNormal];
    
    [originalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    originalButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    originalButton.titleLabel.shadowColor = [UIColor lightGrayColor];
    originalButton.titleLabel.shadowOffset = CGSizeMake(0, -1);   
    
    
//    UIBarButtonItem *toolbarButton = [[UIBarButtonItem alloc] initWithCustomView:button];                                      //WithTitle:@"Delete" style:       UIBarButtonItemStyleBordered target:target action:action];
//    [toolbarButton setWidth:124];
//    [toolbarButton setEnabled:YES];
    return originalButton;
}


+ (UIButton *)bellButton:(UIImage *)image target:(id)target method:(SEL)method tag:(int)tag{
    
    //	if ( image == nil ) image = [UIImage imageNamed:@"done_black@2x~iphone"];
	if ( target == nil ) return nil;
	if ( method == nil ) return nil;
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:image forState:UIControlStateNormal];
	[button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
	[button setTag:tag];
    [button setFrame:CGRectMake(285, 445, 32, 32)];
	
	return button;

    
}


+ (UIButton *)autolockButton:(UIImage *)image target:(id)target method:(SEL)method tag:(int)tag{
	
//	if ( image == nil ) image = [UIImage imageNamed:@"done_black@2x~iphone"];
	if ( target == nil ) return nil;
	if ( method == nil ) return nil;
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Unlocked" forState:UIControlStateNormal];
	[button setImage:image forState:UIControlStateNormal];
	[button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
	[button setTag:tag];
    [button setFrame:CGRectMake(0, 480 -53, 60, 53)];
	
	return button;
}




+ (UIButton *)flashlightButton:(UIImage *)image target:(id)target method:(SEL)method tag:(int)tag{
	
	if ( image == nil ) image = [UIImage imageNamed:@"done_black@2x~iphone"];
	if ( target == nil ) return nil;
	if ( method == nil ) return nil;
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:image forState:UIControlStateNormal];
	[button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
	[button setTag:tag];
    [button setFrame:DONE_BUTTON_FRAME];
	
	return button;
}





//Edit bar button item
+ (UIBarButtonItem *)editBarButtonItem:(UIImage *)image target:(id)target method:(SEL)method tag:(int)tag {
	
	if ( image == nil ) image = [UIImage imageNamed:@"edit@2x"];
	if ( target == nil ) return nil;
	if ( method == nil ) return nil;
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:image forState:UIControlStateNormal];
	[button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
	[button setTag:tag];
    [button setFrame:DONE_BUTTON_FRAME];
	
	UIBarButtonItem *editBarItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];

	return editBarItem;
}	


+ (RadioButton *)radioButtonWithTag:(int)tag {
    
    RadioButton *button = [RadioButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:button action:@selector(toggleOnOff) forControlEvents:UIControlEventTouchDown];
    [button setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 23, 23)];
    [button setOn: NO];
    [button setTag:tag];
    [button setShowsTouchWhenHighlighted:NO];
    
    return button;
}


@end
