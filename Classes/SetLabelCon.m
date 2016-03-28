//
//  SetLabelCon.m
//  SlickTime
//
//  Created by Miles Alden on 5/5/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "SetLabelCon.h"
#import "SetAlarmViewCon.h"
#import "SlickTimeAppDelegate.h"
#import "CentralControl.h"
#import "Alarm.h"

@implementation SetLabelCon
@synthesize vcParent;
@synthesize aLabel;


- (void)dealloc
{
    [aLabel release];
    [super dealloc];
}




#pragma mark - Initi
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 35)] autorelease];
    [backButton setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnBack = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease]; 
    
    self.navigationItem.leftBarButtonItem = btnBack;
    aLabel.text = [Alarm currentAlarmBeingEdited].theLabel;
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark -
#pragma mark TextField Delegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField { return YES; }
- (void)textFieldDidBeginEditing:(UITextField *)textField { [textField becomeFirstResponder]; }
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{	
	printf("\nreturn key mark\n");
	[textField resignFirstResponder];
	return YES;	
    
}















- (BOOL)canBecomeFirstResponder {return YES;}
- (BOOL)canResignFirstResponder {return YES;}



#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController != self) 
    {
        [[Alarm currentAlarmBeingEdited] assignTheLabel:aLabel.text];
        [vcParent refreshData];
        [navigationController setDelegate:(id<UINavigationControllerDelegate>)viewController];
    }
}



@end
