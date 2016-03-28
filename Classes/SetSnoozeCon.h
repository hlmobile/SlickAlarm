//
//  SetSnoozeCon.h
//  SlickTime
//
//  Created by Miles Alden on 5/5/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParentSettingsCon.h"

@class SetAlarmViewCon;
@interface SetSnoozeCon : ParentSettingsCon {

    int selectedRow;
}


@property (nonatomic, assign) SetAlarmViewCon *vcParent;
@end
