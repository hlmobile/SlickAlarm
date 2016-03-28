//
//  SettingsViewCon.m
//  SlickTime
//
//  Created by Miles Alden on 5/3/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "SettingsViewCon.h"
#import "CentralControl.h"
#import "SlickTimeAppDelegate.h"
#import "Alarm.h"

@implementation SettingsViewCon


- (IBAction)buttonPressed {
	
	SlickTimeAppDelegate *del = (SlickTimeAppDelegate *)APP_DELEGATE;
	[del.centralCon flipView];
	[Alarm cleanUnusedAlarm];
}

@end

@interface CustomNavigationBar : UINavigationBar

@end

@implementation CustomNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    UIColor *color = [UIColor colorWithRed:0.0 green:0.655 blue:0.91 alpha:1.0];
    
    UIImage *img  = [UIImage imageNamed: @"title_bar@2x~iphone.png"];	
    [img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.tintColor = color;
    
}


@end

#pragma mark === Nav Bar ===
#pragma mark -

@implementation UINavigationBar (UINavigationBarCategory)
+ (Class)class {
    return NSClassFromString(@"CustomNavigationBar");
}
- (void)drawRect:(CGRect)rect {
	
	
}


@end