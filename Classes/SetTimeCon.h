//
//  SetTimeCon.h
//  SlickTime
//
//  Created by Miles Alden on 5/5/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParentSettingsCon.h"

@class SetAlarmViewCon;
@interface SetTimeCon : ParentSettingsCon {
	IBOutlet UIDatePicker *datePicker;

}

@property (nonatomic, assign) SetAlarmViewCon *vcParent;

- (void)slidePickerUp;
- (void)slidePickerDown;
- (void)didSlidePickerDown;
- (void)markTime;
- (IBAction)buttonResponse: (id)sender;



@end
