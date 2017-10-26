//
//  RH_NavigationBarButton.m
//  TaskTracking
//
//  Created by jinguihua on 2017/4/17.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_NavigationBarButton.h"

@implementation RH_NavigationBarButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self _init_ED_NavigationBarButton];
    }

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self _init_ED_NavigationBarButton];
}


- (void)_init_ED_NavigationBarButton
{
    self.showsTouchWhenHighlighted = NO;
    self.adjustsImageWhenHighlighted = NO;

    self.buttonDidChangeTouchStateBlock = ^(CLButton * button, BOOL isTouch) {
        button.alpha = isTouch ? 0.3f : 1.f;
    };
}


@end
