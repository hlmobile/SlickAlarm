//
//  Button.h
//  SlickTime
//
//  Created by Miles Alden on 5/11/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RadioButton;

@interface Button : NSObject {

}


+ (UIButton *)cancelButton:(UIImage *)image target:(id)target method:(SEL)method tag:(int)tag;
+ (UIButton *)doneButton:(UIImage *)image target:(id)target method:(SEL)method tag:(int)tag;
+ (UIBarButtonItem *)editBarButtonItem:(UIImage *)image target:(id)target method:(SEL)method tag:(int)tag;
+ (RadioButton *)radioButtonWithTag:(int)tag;

+ (UIButton *)deleteButton: (UIButton *)originalButton target:(id)target action: (SEL)action;

+ (UIButton *)flashlightButton:(UIImage *)image target:(id)target method:(SEL)method tag:(int)tag;
+ (UIButton *)autolockButton:(UIImage *)image target:(id)target method:(SEL)method tag:(int)tag;
+ (UIButton *)bellButton:(UIImage *)image target:(id)target method:(SEL)method tag:(int)tag;


@end
