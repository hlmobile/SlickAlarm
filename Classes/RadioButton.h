//
//  RadioButton.h
//  SlickTime
//
//  Created by Miles Alden on 6/3/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RadioButton : UIButton {
    
    BOOL on;
    
}


- (void)toggleOnOff;
- (void)setOn: (BOOL)val;
- (BOOL)isOn;



@end
