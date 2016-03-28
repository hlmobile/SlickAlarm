//
//  RadioButton.m
//  SlickTime
//
//  Created by Miles Alden on 6/3/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import "RadioButton.h"


@implementation RadioButton


- (NSString *)description
{
    NSString *original = [super description];
    return [NSString stringWithFormat:@"%@; isOn: %@", original, ( [self isOn] ) ? @"ON" : @"OFF"];
}


- (void)toggleOnOff {
    
    printf("\ntoggleRadio\n");    
    if ( [self isOn] ) {
        [self setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
        [self setOn:NO];
    }
    
    else {
        [self setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];
        [self setOn:YES];
    }

}

- (void)setOn: (BOOL)val {
    on = val;
}
- (BOOL)isOn {
    return on;
}

@end
