//
//  InfoScreenCon.m
//  SlickTime
//
//  Created by Miles Alden on 5/5/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "HowToScreenCon.h"
#import "SlickTimeAppDelegate.h"
#import "CentralControl.h"

@implementation HowToScreenCon
@synthesize vwScroll;
@synthesize shouldClose;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Info";
    [vwScroll setFrame:CGRectMake(0, 0, 320, 416)];
    [vwScroll setContentSize:CGSizeMake(0, 400)];
    
    UIButton *backButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 35)] autorelease];
    [backButton setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnBack = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease]; 
    
    self.navigationItem.leftBarButtonItem = btnBack;
}

- (void)onBack
{
    if (shouldClose)
    {
        SlickTimeAppDelegate *appDelegate = (SlickTimeAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.centralCon flipView];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc
{
    [vwScroll release];
    [super dealloc];
}
@end
