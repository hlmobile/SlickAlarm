//
//  InfoScreenCon.m
//  SlickTime
//
//  Created by Optiplex790 on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoScreenCon.h"
#import "SlickTimeAppDelegate.h"
#import "CentralControl.h"

@interface InfoScreenCon ()

@end

@implementation InfoScreenCon

@synthesize vwScroll;

- (void)dealloc
{
    [vwScroll release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	CGRect frame = self.vwScroll.frame;
    vwScroll.contentSize = CGSizeMake(frame.size.width, frame.size.height);
    frame.size.height = self.view.frame.size.height - frame.origin.y;
    vwScroll.frame = frame;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)onTapBackButton:(id)sender
{
    SlickTimeAppDelegate *del = (SlickTimeAppDelegate *)APP_DELEGATE;
    [del.centralCon dismissInfoScreen];

}

@end
