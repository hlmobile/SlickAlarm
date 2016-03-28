//
//  SetLabelCon.h
//  SlickTime
//
//  Created by Miles Alden on 5/5/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController_navDelegate.h"

@class SetAlarmViewCon;
@interface SetLabelCon : UIViewController_navDelegate <UITextFieldDelegate> {

	IBOutlet UITextField *aLabel;
	
}

@property (nonatomic, retain) IBOutlet UITextField *aLabel;
@property (nonatomic, assign) SetAlarmViewCon *vcParent;

@end
