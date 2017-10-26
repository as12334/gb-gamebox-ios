//
//  CLScrollTriggerView.m
//  CoreLib
//
//  Created by jinguihua on 2017/1/19.
//  Copyright © 2017年 GIGA. All rights reserved.
//

#import "CLScrollTriggerView.h"
#import "help.h"
#import "MacroDef.h"

#define defaultMinTriggerDistance 50.f

@implementation CLScrollTriggerView
{
    BOOL _ignoreChange;
    UIEdgeInsets _originalContentInset;
}

#pragma mark - life circle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"CLScrollTriggerView不能通过initWithCoder:方法进行初始化"
                                 userInfo:nil];
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithLocation:CLScrollTriggerViewLocationTop minTriggerDistance:defaultMinTriggerDistance];
}

- (id)initWithLocation:(CLScrollTriggerViewLocation)location {
    return [self initWithLocation:location minTriggerDistance:defaultMinTriggerDistance];
}

- (id)initWithLocation:(CLScrollTriggerViewLocation)location minTriggerDistance:(CGFloat)minTriggerDistance
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        super.frame               = CGRectZero;
        _location                 = location;
        _minTriggerDistance       = minTriggerDistance;
        _locationOffset           = CGPointZero;
        _minTriggerDistanceOffset = 0.f;
        _status                   = CLScrollTriggerViewStatusNormal;
        _originalContentInset     = UIEdgeInsetsZero;
        _animationrDuration       = 0.4f;
        _alphaChangeWithScroll    = YES;
        _invalidate               = YES;

    }

    return self;
}


#pragma mark -

- (void)setFrame:(CGRect)frame{
    [self _updateFrame];
}

- (void)setBounds:(CGRect)bounds{
    [self _updateFrame];
}

- (void)setCenter:(CGPoint)center{
    [self _updateFrame];
}

- (void)setMinTriggerDistanceOffset:(CGFloat)minTriggerDistanceOffset
{
    if (_minTriggerDistanceOffset != minTriggerDistanceOffset) {
        _minTriggerDistanceOffset = minTriggerDistanceOffset;
        [self invalidate];
    }
}

- (void)setLocationOffset:(CGPoint)locationOffset
{
    if (!CGPointEqualToPoint(locationOffset, _locationOffset)) {
        _locationOffset = locationOffset;
        [self invalidate];

        //更新位置
        [self _updateFrame];
    }
}

- (void)setMode:(CLScrollTriggerViewTriggerMode)mode
{
    if (_mode != mode) {
        _mode = mode;
        [self invalidate];
    }
}

- (void)setEnabled:(BOOL)enabled
{
    if (self.isEnabled != enabled) {

        if (!enabled) {
            [self invalidate];
        }

        [super setEnabled:enabled];
    }
}

- (void)setHidden:(BOOL)hidden
{
    if (self.isHidden != hidden) {

        if (hidden) {
            [self invalidate];
        }

        [super setHidden:hidden];
    }
}

- (void)setAlphaChangeWithScroll:(BOOL)alphaChangeWithScroll
{
    if (_alphaChangeWithScroll != alphaChangeWithScroll) {
        _alphaChangeWithScroll = alphaChangeWithScroll;

        if (self.state != CLScrollTriggerViewStatusTriggering) {
            [self invalidate];
        }
    }
}

#pragma mark -

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {

        if (![newSuperview isKindOfClass:[UIScrollView class]]) {
            @throw  [[NSException alloc] initWithName:NSInternalInconsistencyException
                                               reason:@"必须为UIScrollView的子视图"
                                             userInfo:nil];
        }

    }

    if (self.superview) {

        //状态失效
        [self invalidate];

        //取消观察
        [self _unregisterKVO];
    }
}

- (void)didMoveToSuperview
{
    if (self.superview) {

        //设置失效进行初始化更新
        [self invalidate];

        _ignoreChange = NO;
        _invalidate = NO;

        //记录初始的inset
        _originalContentInset = [self scrollView].contentInset;

        //更新位置
        [self _updateFrame];

        //注册观察
        [self _registerKVO];
    }
}

- (UIScrollView *)scrollView {
    return (UIScrollView *)self.superview;
}

#pragma mark -

- (void)_updateFrame
{
    if (self.scrollView == nil) {
        return;
    }

    UIScrollView * scrollView = self.scrollView;
    CGRect frame = CGRectZero;
    CGSize scrollViewSize = scrollView.bounds.size;

    switch (self.location) {
        case CLScrollTriggerViewLocationTop:
            frame = CGRectMake(0.f, - self.minTriggerDistance, scrollViewSize.width, self.minTriggerDistance);
            break;

        case CLScrollTriggerViewLocationLeft:
            frame = CGRectMake(- self.minTriggerDistance, 0, self.minTriggerDistance, scrollViewSize.height);
            break;

        case CLScrollTriggerViewLocationBottom:
        {
            CGSize contentSize = scrollView.contentSize;
            CGFloat canShowHeight = scrollViewSize.height -  _originalContentInset.top - _originalContentInset.bottom;
            frame = CGRectMake(0.f, MAX(canShowHeight, contentSize.height), scrollViewSize.width, self.minTriggerDistance);
        }
            break;

        case CLScrollTriggerViewLocationRight:
        {
            CGSize contentSize = scrollView.contentSize;
            CGFloat canShowWidth= scrollViewSize.width -  _originalContentInset.left - _originalContentInset.right;
            frame = CGRectMake(MAX(canShowWidth, contentSize.width), 0.f, self.minTriggerDistance, scrollViewSize.height);
        }
    }

    super.frame = CGRectOffset(frame, self.locationOffset.x, self.locationOffset.y);

    //如果正在触发则需要更新inset
    if (self.status == CLScrollTriggerViewStatusTriggering) {
        [self _updateContentInsetForTriggering];
    }
}

- (void)_updateContentInsetForTriggering
{
    MyAssert(self.status == CLScrollTriggerViewStatusTriggering);

    UIScrollView * scrollView = self.scrollView;
    UIEdgeInsets contentInset = _originalContentInset;

    switch (self.location) {
        case CLScrollTriggerViewLocationTop:
            contentInset.top += (self.minTriggerDistance + self.minTriggerDistanceOffset);
            break;

        case CLScrollTriggerViewLocationLeft:
            contentInset.left += (self.minTriggerDistance + self.minTriggerDistanceOffset);
            break;

        case CLScrollTriggerViewLocationBottom:
        {
            CGFloat offset = CGRectGetHeight(scrollView.bounds) - _originalContentInset.top - _originalContentInset.bottom - scrollView.contentSize.height;
            contentInset.bottom += (self.minTriggerDistance + self.minTriggerDistanceOffset + MAX(0.f, offset));
        }
            break;

        case CLScrollTriggerViewLocationRight:
        {
            CGFloat offset = CGRectGetWidth(scrollView.bounds) - _originalContentInset.left - _originalContentInset.right - scrollView.contentSize.width;
            contentInset.right += (self.minTriggerDistance + self.minTriggerDistanceOffset + MAX(0.f, offset));
        }
            break;
    }

    if (!UIEdgeInsetsEqualToEdgeInsets(contentInset, scrollView.contentInset)) {
        _ignoreChange = YES;

        //        NSLog(@"\n setContentOffsetForTriggering \n%@ -> %@",NSStringFromUIEdgeInsets(scrollView.contentInset),NSStringFromUIEdgeInsets(contentInset));

        scrollView.contentInset = contentInset;
        _ignoreChange = NO;
    }
}

- (void)_updateContentOffsetForTriggering
{
    MyAssert(self.status == CLScrollTriggerViewStatusTriggering);

    UIScrollView * scrollView = self.scrollView;
    CGPoint contentOffset = scrollView.contentOffset;

    switch (self.location) {
        case CLScrollTriggerViewLocationTop:
            contentOffset.y = - _originalContentInset.top - self.minTriggerDistance -  self.minTriggerDistanceOffset;
            break;

        case CLScrollTriggerViewLocationLeft:
            contentOffset.x = - _originalContentInset.left - self.minTriggerDistance -  self.minTriggerDistanceOffset;
            break;

        case CLScrollTriggerViewLocationBottom:
            contentOffset.y = CGRectGetMaxY(self.frame) - self.locationOffset.y - CGRectGetHeight(scrollView.bounds) + _originalContentInset.bottom + self.minTriggerDistanceOffset;
            break;

        case CLScrollTriggerViewLocationRight:
            contentOffset.x = CGRectGetMaxX(self.frame) - self.locationOffset.x - CGRectGetWidth(scrollView.bounds) + _originalContentInset.right + self.minTriggerDistanceOffset;
            break;
    }

    [scrollView setContentOffset:contentOffset animated:YES];
}

#pragma mark -

- (void)beginTrigger {
    [self beginTrigger_e:YES];
}

- (void)beginTrigger_e:(BOOL)scrollToShow
{
    if (self.status != CLScrollTriggerViewStatusTriggering &&
        !(self.mode & CLScrollTriggerViewTriggerModeMomentary)  &&
        self.enabled && !self.isHidden && [self scrollView]) {

        //更新inset和状态
        _invalidate = NO;
        [self _tryChangeStatus:CLScrollTriggerViewStatusTriggering];

        [self _updateContentInsetForTriggering];

        //不需要滑动到显示则更新一下contentOffset防止inset的导致的tableview的头视图混乱问题
        if (!scrollToShow) {
            [self _contentOffsetDidChange];
        }else {
            [self _updateContentOffsetForTriggering];
        }
    }
}

- (void)endTrigger {
    [self _endTrigger:YES];
}

- (void)_endTrigger:(BOOL)animated
{
    if (self.status == CLScrollTriggerViewStatusTriggering) {

        //        _invalidate = YES;
        [self _tryChangeStatus:CLScrollTriggerViewStatusNormal];

        if (animated) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:self.animationrDuration];
        }

        _ignoreChange = YES;
        self.scrollView.contentInset = _originalContentInset;
        _ignoreChange = NO;

        if (self.alphaChangeWithScroll) {
            super.alpha = 0.f;
        }

        if (animated) {
            [UIView commitAnimations];
        }
    }
}

- (void)invalidate
{
    if (self.status == CLScrollTriggerViewStatusBeginReadyTrigger ||
        self.status == CLScrollTriggerViewStatusReadyToTrigger) {

        //改变到正常状态，并标记为失效
        _invalidate = YES;
        [self _tryChangeStatus:CLScrollTriggerViewStatusNormal];

    }else if(self.state == CLScrollTriggerViewStatusTriggering) {

        //结束刷新
        [self _endTrigger:NO];

    }else {

        [self updateViewForReset];
    }
}


#pragma mark - KVO

- (NSArray *)_observableKeypaths
{
    switch (self.location) {
        case CLScrollTriggerViewLocationTop:
        case CLScrollTriggerViewLocationLeft:
            return @[@"contentInset",
                     @"contentOffset",
                     @"bounds"];
            break;

        default:
            return @[@"contentInset",
                     @"contentOffset",
                     @"contentSize",
                     @"bounds"];
            break;
    }

}

- (void)_registerKVO
{
    for (NSString * keyPath in [self _observableKeypaths]) {
        [[self scrollView] addObserver:self
                            forKeyPath:keyPath
                               options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                               context:nil];
    }
}

- (void)_unregisterKVO
{
    for (NSString * keyPath in [self _observableKeypaths]) {
        [[self scrollView] removeObserver:self forKeyPath:keyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIScrollView *scrollView = [self scrollView];

    id oldValue = [change objectForKey:@"old"];
    id newValue = [change objectForKey:@"new"];

    //非滑动视图
    if (scrollView != object || [oldValue isEqualToValue:newValue]) {
        return;
    }

    if (([keyPath isEqualToString:@"bounds"] &&
         !CGSizeEqualToSize([oldValue CGRectValue].size, [newValue CGRectValue].size)) ||
        [keyPath isEqualToString:@"contentSize"]){

        [self _updateFrame];

        if (self.status != CLScrollTriggerViewStatusTriggering) {
            [self invalidate];
        }

    }else if ([keyPath isEqualToString:@"contentInset"]) {

        if (_ignoreChange) {
            return;
        }

        UIEdgeInsets contentInset = scrollView.contentInset;

        //刷新状态下使用更改的偏移更新初始化的contentInset
        if (self.status == CLScrollTriggerViewStatusTriggering) {
            UIEdgeInsets old = [oldValue UIEdgeInsetsValue];

            contentInset.top    = _originalContentInset.top    + contentInset.top    - old.top;
            contentInset.bottom = _originalContentInset.bottom + contentInset.bottom - old.bottom;
            contentInset.left   = _originalContentInset.left   + contentInset.left   - old.left;
            contentInset.right  = _originalContentInset.right  + contentInset.right  - old.right;
        }

        //        NSLog(@"change  originalContentInset  \n%@ -> %@",NSStringFromUIEdgeInsets(_originalContentInset),NSStringFromUIEdgeInsets(contentInset));

        _originalContentInset = contentInset;

        [self _updateFrame];

        if (self.status != CLScrollTriggerViewStatusTriggering) {
            [self invalidate];
        }

    } else if ([keyPath isEqualToString:@"contentOffset"]) {

        if (_ignoreChange || !self.enabled || self.isHidden) {
            return;
        }

        [self _contentOffsetDidChange];
    }
}

- (void)_contentOffsetDidChange
{
    UIScrollView *scrollView = [self scrollView];

    //相对偏移量
    CGFloat offset = 0;

    switch (self.location) {
        case CLScrollTriggerViewLocationTop:
            offset = - scrollView.contentOffset.y - _originalContentInset.top;
            break;

        case CLScrollTriggerViewLocationLeft:
            offset = - scrollView.contentOffset.x - _originalContentInset.left;
            break;

        case CLScrollTriggerViewLocationBottom:
        {
            float minYInFrame = CGRectGetMinY(self.frame) - scrollView.contentOffset.y - self.locationOffset.y;
            offset = CGRectGetHeight(scrollView.bounds) - _originalContentInset.bottom - minYInFrame;
        }
            break;

        case CLScrollTriggerViewLocationRight:
        {
            float minXInFrame = CGRectGetMinX(self.frame) - scrollView.contentOffset.x - self.locationOffset.x;
            offset = CGRectGetWidth(scrollView.bounds) - _originalContentInset.right - minXInFrame;
        }
            break;
    }

    offset -= self.minTriggerDistanceOffset;

    if (self.status == CLScrollTriggerViewStatusNormal) {

        if (self.invalidate) {

            if (offset <= 0) {
                _invalidate = NO;
            }

        }else if (offset >= 0) {

            [self _tryChangeStatus:CLScrollTriggerViewStatusBeginReadyTrigger];
        }

    }else if (self.status == CLScrollTriggerViewStatusTriggering) {

        if (self.location == CLScrollTriggerViewLocationTop &&
            [scrollView isKindOfClass:[UITableView class]] &&
            [(UITableView *)scrollView style] == UITableViewStylePlain) {

            UIEdgeInsets contentInset = _originalContentInset;

            if (offset >= self.minTriggerDistance) {
                contentInset.top += (self.minTriggerDistance + self.minTriggerDistanceOffset);
            }else if (offset >= - self.minTriggerDistanceOffset) {
                contentInset.top += (offset + self.minTriggerDistanceOffset);
            }

            if (!UIEdgeInsetsEqualToEdgeInsets(contentInset, scrollView.contentInset)) {
                _ignoreChange = YES;
                scrollView.contentInset = contentInset;
                _ignoreChange = NO;
            }
        }

    }else if (self.status == CLScrollTriggerViewStatusReadyToTrigger && !scrollView.isTracking) {

        //开始触发
        [self _beginTriggerWithScrollView:scrollView];

    }else {

        if (self.status == CLScrollTriggerViewStatusBeginReadyTrigger) {

            if (offset > self.minTriggerDistance) {

                if (scrollView.isTracking) {
                    [self _tryChangeStatus:CLScrollTriggerViewStatusReadyToTrigger];

                    return;
                }

            }else if(offset < 0) {

                [self _tryChangeStatus:CLScrollTriggerViewStatusNormal];
            }

        }else if (offset < self.minTriggerDistance) {

            [self _tryChangeStatus:CLScrollTriggerViewStatusBeginReadyTrigger];
            //            [self updateViewForReadyToTrigger:NO];

        }else {
            return;
        }

        //更新进度
        [self updateViewForTriggerProgress:ChangeInMinToMax(offset / self.minTriggerDistance, 0.f, 1.f)];
    }
}

- (void)_beginTriggerWithScrollView:(UIScrollView *)scrollView
{
    if (self.mode & CLScrollTriggerViewTriggerModeMomentary) {
        [self invalidate];
    }else{

        //记录当前偏移量
        CGPoint contentOffset = scrollView.contentOffset;

        //更新视图和状态
        [self _tryChangeStatus:CLScrollTriggerViewStatusTriggering];
        [self _updateContentInsetForTriggering];

        //恢复到之前偏移量
        _ignoreChange = YES;

        scrollView.contentOffset = contentOffset;

        //        scrollView.scrollEnabled = YES;

        _ignoreChange = NO;
    }

    //发送消息
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


#pragma mark -

- (void)setAlpha:(CGFloat)alpha {
    //do nothing
}

- (void)_tryChangeStatus:(CLScrollTriggerViewStatus)status
{
    if (_status != status) {

        CLScrollTriggerViewStatus oldStatus = self.status;
        _status = status;
        [self statusDidChangeFromStatus:oldStatus];
    }
}

- (void)statusDidChangeFromStatus:(CLScrollTriggerViewStatus)fromStatus
{
    if (!self.alphaChangeWithScroll ||
        (self.status == CLScrollTriggerViewStatusReadyToTrigger ||
         self.status == CLScrollTriggerViewStatusTriggering)) {
            super.alpha = 1.f;
        }
}

- (void)updateViewForReset {
    super.alpha = self.alphaChangeWithScroll ? 0.f : 1.f;
}

- (void)updateViewForTriggerProgress:(float)progress
{
    if (self.alphaChangeWithScroll) {
        super.alpha = progress;
    }
}


@end
