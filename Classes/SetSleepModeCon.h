//
//  SetSleepModeCon.h
//  SlickTime
//
//  Created by Miles Alden on 5/5/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParentSettingsCon.h"

@class SetSleepMusicCon, SetWhiteNoiseCon;

@interface SetSleepModeCon : ParentSettingsCon {

	int oldRow;

	SetSleepMusicCon *setSleepMusicCon;
	SetWhiteNoiseCon *setWhiteNoiseCon;
	
    BOOL isEditing;
}


- (void)loadControllers;
- (void)buttonResponse: (id)sender;
- (void)switchButtonPressed: (id)sender;
@end
