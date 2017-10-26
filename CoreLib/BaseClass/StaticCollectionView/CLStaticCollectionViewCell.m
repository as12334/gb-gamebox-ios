//
//  CLStaticCollectionViewCell.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/10.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLStaticCollectionViewCell.h"

@implementation CLStaticCollectionViewCell
{
    BOOL _needUpdateCellWhenShowInWindow;
}

+ (NSString *)defaultReuseIdentifier {
    return NSStringFromClass(self);
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame reuseIdentifier:nil];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    return [self initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame];

    if (self) {
        [self setupReuseIdentifier:reuseIdentifier];
    }

    return self;
}

- (void)setupReuseIdentifier:(NSString *)reuseIdentifier
{
    if (_reuseIdentifier.length == 0 && reuseIdentifier.length != 0) {
        _reuseIdentifier = reuseIdentifier;
    }
}

#pragma mark -

- (BOOL)touchPointInside:(CGPoint)point {
    return CGRectContainsPoint(self.bounds, point);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark -

- (void)updateCellWithInfo:(NSDictionary *)info context:(id)context {
    //do nothing
}

- (void)prepareForReuse {
    _needUpdateCellWhenShowInWindow = NO;
}

- (void)didAddToReusePool {
    //do nothing
}


- (void)setNeedUpdateCell
{
    if (self.window) {
        [self updateCell];
    }else {
        _needUpdateCellWhenShowInWindow = YES;
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];

    if (newWindow) {
        [self updateCellIfNeeded];
    }
}

- (void)updateCellIfNeeded
{
    if (_needUpdateCellWhenShowInWindow) {
        _needUpdateCellWhenShowInWindow = NO;
        [self updateCell];
    }
}

- (void)updateCell {
    //do  nothing
}

@end
