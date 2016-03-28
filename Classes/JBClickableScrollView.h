//
//  UIClickableScrollView.h
//  refundoBank
//
//  Created by Jin Bei on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JBClickableScrollView;

@protocol JBClickableScrollViewDelegate <NSObject>

- (void)clickableViewDidClick:(JBClickableScrollView *)view;

@end

@interface JBClickableScrollView : UIScrollView
{
    BOOL movable;
    BOOL shouldIgnoreSubviews;
    UIView *subView;
}

@property (nonatomic, assign) BOOL shouldIgnoreSubviews;
@property (nonatomic, assign) BOOL movable;
@property (nonatomic, assign) IBOutlet UIView *subView;
@property (nonatomic, assign) id<JBClickableScrollViewDelegate> jbClickableScrollViewDelegate;
@end
