//
//  UIClickableScrollView.m
//  refundoBank
//
//  Created by Jin Bei on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JBClickableScrollView.h"

@implementation JBClickableScrollView

@synthesize shouldIgnoreSubviews, movable;
@synthesize jbClickableScrollViewDelegate, subView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        shouldIgnoreSubviews = NO;
        movable = NO;
        subView = nil;
    }
    return self;
}


- (void)setMovable:(BOOL)b
{
    self.scrollEnabled = b;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging)
        [jbClickableScrollViewDelegate clickableViewDidClick:self];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{

    
    BOOL myArea = NO;
    CGPoint p = [self convertPoint:point toView:subView];

    if ([subView  pointInside:p withEvent:event]) 
    {
        myArea = YES;
    }
    
    if (myArea)
    {
        if (!shouldIgnoreSubviews)
            return [super hitTest:point withEvent:event];
        return self;
    }
    
    return nil;
}

- (void)dealloc
{
    
    [super dealloc];
}


@end
