//
//  SetAlarmViewCon.h
//  SlickTime
//
//  Created by Miles Alden on 5/4/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParentSettingsCon.h"

@class SetTimeCon, SetRepeatCon, SetSnoozeCon,
		SetMusicCon, SetLabelCon, SetSleepModeCon,
		SetAutolockCon, InfoScreenCon;


@interface SetAlarmViewCon : ParentSettingsCon {
	
	SetTimeCon *setTimeCon;
	SetRepeatCon *setRepeatCon;
	SetSnoozeCon *setSnoozeCon;
	SetMusicCon *setMusicCon;
	SetLabelCon *setLabelCon;
	SetSleepModeCon *setSleepModeCon;
	SetAutolockCon *setAutoLockCon;

	
}

//- (void)replaceObjectAtIndex: (int)index array:(int)array object:(id)object;
- (void)refreshData;
- (void)loadDetailLabels;
- (void)loadControllers;
- (IBAction)action;
- (void)saveAlarm;
- (void)backButtonPressed;
- (void)showAlert ;


@end
