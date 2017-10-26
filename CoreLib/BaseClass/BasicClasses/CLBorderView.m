//
//  CLBorderView.m
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "CLBorderView.h"
#import "MacroDef.h"

@implementation CLBorderView
{
    CALayer * _borderLayer;
}

@synthesize borderStyle = _borderStyle;
@synthesize borderMask = _borderMask;
@synthesize borderColor = _borderColor;
@synthesize borderWidth = _borderWidth;
@synthesize borderInset = _borderInset;
@synthesize borderLineInset = _borderLineInset;
@synthesize borderLineScaleInset = _borderLineScaleInset;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self _initBorderView];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self _initBorderView];
    }

    return self;
}

- (void)_initBorderView {
    self.borderWidth = PixelToPoint(1.f);
}

#pragma mark -

#define IMP_MUTATOR(mutator, ctype, member, selector) \
- (void)mutator (ctype)value \
{ \
if(member != value){ \
member = value; \
if(selector){ \
[self performSelector:selector withObject:nil];\
}\
}\
}

IMP_MUTATOR(setBorderMask:, CLBorderMask, _borderMask, @selector(setNeedsLayout))
IMP_MUTATOR(setBorderColor:, UIColor *, _borderColor, @selector(setNeedsLayout))
IMP_MUTATOR(setBorderStyle:, CLLineStyle, _borderStyle, @selector(setNeedsLayout))
IMP_MUTATOR(setBorderWidth:, CGFloat, _borderWidth, @selector(setNeedsLayout))

- (void)setBoderInset:(UIEdgeInsets)borderInset
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_borderInset,borderInset)) {
        _borderInset =borderInset;
        [self setNeedsLayout];
    }
}

- (void)setBoderLineInset:(UIEdgeInsets)borderLineInset
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_borderLineInset,borderLineInset)) {
        _borderLineInset =borderLineInset;
        [self setNeedsLayout];
    }
}

- (void)setBorderLineScaleInset:(UIEdgeInsets)borderLineScaleInset
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_borderLineScaleInset,borderLineScaleInset)) {
        _borderLineScaleInset = borderLineScaleInset;
        [self setNeedsLayout];
    }
}

- (UIColor *)borderColor {
    return _borderColor ?: [UIColor blackColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self _updateBorder_MyBorderView];
}

- (void)_updateBorder_MyBorderView
{
    _borderLayer.sublayers = nil;
    [_borderLayer removeFromSuperlayer];

    if (self.borderMask == CLBorderMarkNone || self.borderWidth <= 0.f) {
        return;
    }

    if (!_borderLayer) {
        _borderLayer = [CALayer layer];
    }

    [self.layer addSublayer:_borderLayer];

    CGRect borderContainerRect = UIEdgeInsetsInsetRect(self.bounds, self.borderInset);
    borderContainerRect.size.width = MAX(0.f, borderContainerRect.size.width);
    borderContainerRect.size.height = MAX(0.f, borderContainerRect.size.height);

    CLBorderMask mask[4] = {
        CLBorderMarkTop,
        CLBorderMarkBottom,
        CLBorderMarkLeft,
        CLBorderMarkRight};

    for (int i = 0; i < 4; ++ i) {

        if (self.borderMask & mask[i]) {

            CGPoint startPoint = CGPointZero;
            CGPoint endPoint = CGPointZero;

            if (mask[i] == CLBorderMarkTop || mask[i] == CLBorderMarkBottom) {

                CGFloat width = CGRectGetWidth(borderContainerRect);
                startPoint.x = CGRectGetMinX(borderContainerRect) + self.borderLineInset.left + self.borderLineScaleInset.left * width;
                endPoint.x = CGRectGetMaxX(borderContainerRect) - self.borderLineInset.right - self.borderLineScaleInset.right * width;

                if (startPoint.x >= endPoint.x) {
                    continue;
                }

                if (mask[i] == CLBorderMarkTop) {
                    startPoint.y = CGRectGetMinY(borderContainerRect) + self.borderWidth * 0.5f;
                }else{
                    startPoint.y  = CGRectGetMaxY(borderContainerRect) - self.borderWidth * 0.5f;
                }

                endPoint.y = startPoint.y;

            }else{

                CGFloat height = CGRectGetHeight(borderContainerRect);
                startPoint.y = CGRectGetMinY(borderContainerRect) + self.borderLineInset.top + self.borderLineScaleInset.top * height;
                endPoint.y = CGRectGetMaxY(borderContainerRect) - self.borderLineInset.bottom - self.borderLineScaleInset.bottom * height;

                if (startPoint.y >= endPoint.y) {
                    continue;
                }

                if (mask[i] == CLBorderMarkLeft) {
                    startPoint.x = CGRectGetMinX(borderContainerRect) + self.borderWidth * 0.5f;
                }else{
                    startPoint.x  = CGRectGetMaxX(borderContainerRect) - self.borderWidth * 0.5f;
                }

                endPoint.x = startPoint.x;
            }

            CLLineLayer * borderLineLayer = [CLLineLayer layer];
            borderLineLayer.lineStyle = self.borderStyle;
            borderLineLayer.lineWidth = self.borderWidth;
            borderLineLayer.lineColor = self.borderColor;
            borderLineLayer.startPoint = startPoint;
            borderLineLayer.endPoint = endPoint;

            [_borderLayer addSublayer:borderLineLayer];

        }
    }
}

@end
