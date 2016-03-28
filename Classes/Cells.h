//
//  Cells.h
//  SlickTime
//
//  Created by Miles Alden on 5/5/11.
//  Copyright 2011 Santa Cruz Singers. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Cells : NSObject {

}

+ (UITableViewCell *)cellZeroWithIdentifier: (NSString *)identifier text:(NSString *)text buttonTarget: (id)target selector: (SEL)method buttonTag: (NSInteger) tag;
+ (UITableViewCell *)cellOneAWithIdentifier: (NSString *)identifier text:(NSString *)text buttonTarget: (id)target selector: (SEL)method buttonTag: (NSInteger)tag;
+ (UITableViewCell *)cellOneBWithIdentifier: (NSString *)identifier text:(NSString *)text buttonTarget: (id)target selector: (SEL)method buttonTag: (NSInteger)tag;
+ (UITableViewCell *)cellTwoWithIdentifier: (NSString *)identifier text:(NSString *)text buttonTarget: (id)target selector: (SEL)method detailLabelText:(NSString *)detailText buttonTag: (NSInteger)tag;
+ (UITableViewCell *)cellThreeWithIdentifier: (NSString *)identifier text:(NSString *)text buttonTarget: (id)target selector: (SEL)method detailLabelText:(NSString *)detailText buttonTag: (NSInteger)tag;
+ (UITableViewCell *)cellFourWithIdentifier: (NSString *)identifier text:(NSString *)text buttonTarget: (id)target selector: (SEL)method switchStartsOn:(BOOL)switchOn buttonTag: (NSInteger)tag;


@end
