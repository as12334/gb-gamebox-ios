//
//  CLBasicDeclineMenuContentView.m
//  TaskTracking
//
//  Created by apple pro on 2017/2/21.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

//----------------------------------------------------------

#import "CLBasicDeclineMenuContentView.h"
#import "CLDeclineMenuContainerView.h"
#import "NSObject+IntervalAnimation.h"

//----------------------------------------------------------

NSString * const MyDeclineMenuContentViewSizeInvalidateNotification = @"MyDeclineMenuContentViewSizeInvalidateNotification";

//----------------------------------------------------------

@implementation CLBasicDeclineMenuContentView

#pragma mark -

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup_CLBasicDeclineMenuContentView];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setup_CLBasicDeclineMenuContentView];
    }

    return self;
}

- (void)_setup_CLBasicDeclineMenuContentView
{
    self.needAnimatedWhenShow = YES;
    self.showAnimtedMoveDirection = CLMoveAnimtedDirectionLeft;
}

#pragma mark -

- (CGFloat)heightForViewWithContainerSize:(CGSize)containerSize {
    return containerSize.height * 0.6f;
}

- (void)sizeInvalidate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MyDeclineMenuContentViewSizeInvalidateNotification
                                                        object:self];
}

#pragma mark -

- (void)viewWillShow:(BOOL)animated duration:(NSTimeInterval)duration
{
    if (self.needAnimatedWhenShow) {
        [self startShowAnimatedWithDelay:animated ? duration * 0.6f : 0.f];
    }
}

- (void)startShowAnimatedWithDelay:(NSTimeInterval)delay
{
    [self startCommitIntervalAnimatedWithDirection:self.showAnimtedMoveDirection
                                          duration:1.3f
                                             delay:delay
                                           forShow:YES
                                           context:nil
                                    completedBlock:nil];
}


- (void)viewDidShow:(BOOL)animated {
    //do nothing
}

- (void)viewWillHide:(BOOL)animated duration:(NSTimeInterval)duration {
    //do nothing
}

-(void)viewDidHide:(BOOL)animated {
    //do nothing
}

#pragma mark -

- (BOOL)shouldTapHiddenInContainerView:(CLDeclineMenuContainerView *)containerView {
    return YES;
}

- (BOOL)shouldBeginSwipeHiddenInContainerView:(CLDeclineMenuContainerView *)containerView {
    return YES;
}

- (BOOL)shouldSwipeHiddenInContainerView:(CLDeclineMenuContainerView *)containerView {
    return YES;
}


@end
