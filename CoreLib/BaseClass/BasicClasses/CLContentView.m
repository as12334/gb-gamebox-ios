//
//  CLContentView.m
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "CLContentView.h"

@implementation CLContentView
{
    BOOL _needUpdateViewWhenMovetToWindow;
}

- (void)setNeedUpdateView
{
    if (self.window) {
        [self updateView];
    }else {
        _needUpdateViewWhenMovetToWindow = YES;
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];

    if (newWindow) {
        [self updateViewIfNeeded];
    }
}

- (BOOL)updateViewIfNeeded
{
    if (_needUpdateViewWhenMovetToWindow) {
        _needUpdateViewWhenMovetToWindow = NO;
        [self updateView];
        return YES;
    }

    return NO;
}

- (void)updateView {
    //do nothing
}


@end
