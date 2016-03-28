//
//  SettingsRootViewCon.h
//  SlickTime
//
//  Created by Miles Alden on 5/4/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParentSettingsCon.h"

@class SetAlarmViewCon, Button;

@interface SettingsRootViewCon : ParentSettingsCon {

	NSArray *alarmList;
	BOOL isEditing;
    BOOL isFirst;
}

@property (nonatomic, retain) NSArray *alarmList;
@property (nonatomic, retain) UIButton *autolockButton;
@property (nonatomic, retain) UIButton *helpButton;
@property (nonatomic, retain) UIButton *editButton;
@property (nonatomic, assign) UISwitch *sleepSwitch;
- (void)addAlarmViewCons;
- (void)buttonResponse;
- (void)setScreenlock;



- (void)saveButtonPressed;
- (void)editButtonPressed;
- (void)helpButtonPressed;
- (void)disableAutoLock;

- (void)showHelp;
@end
