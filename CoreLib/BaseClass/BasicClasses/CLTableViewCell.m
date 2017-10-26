//
//  CLTableViewCell.m
//  CoreLib
//
//  Created by jinguihua on 2016/11/28.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "CLTableViewCell.h"
#import "MacroDef.h"

//----------------------------------------------------------

@interface CLTableViewCell ()

@property(nonatomic,strong,readonly) CALayer * selectionLayer;
@property(nonatomic,strong) CALayer * separatorLineLayer;

@end

//----------------------------------------------------------

@implementation CLTableViewCell
{
    BOOL _needUpdateCellWhenShowInWindow;
    BOOL _needUpdateSeparatorLineWhenShowInWindow;

}

@synthesize selectionLayer = _selectionLayer;
@synthesize separatorLineColor = _separatorLineColor;
@synthesize selectionOption = _selectionOption;
@synthesize selectionColor = _selectionColor;
@synthesize selectionColorAlpha = _selectionColorAlpha;
@synthesize highlightedObjects = _highlightedObjects;
@synthesize animatedSelectionForHidden = _animatedSelectionForHidden;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        [self _initTableViewCell];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initTableViewCell];
    }

    return self;
}

- (void)_initTableViewCell
{
    _separatorLineWidth = PixelToPoint(1.f);
    _selectionColorAlpha = 1.f;

    //默认的高亮对象
    NSMutableArray * highlightedObjects = [[NSMutableArray alloc] initWithCapacity:3];
    if (self.textLabel) {
        [highlightedObjects addObject:self.textLabel];
    }
    if (self.detailTextLabel) {
        [highlightedObjects addObject:self.detailTextLabel];
    }
    if (self.imageView) {
        [highlightedObjects addObject:self.imageView];
    }
    self.highlightedObjects = highlightedObjects;
    self.selectionStyle = UITableViewCellSelectionStyleNone ;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self _updateSeparatorLineFrame];
    //    if (_selectionLayer) {
    //         _selectionLayer.frame = [self showSelectionView].bounds;
    //    }
}

#pragma mark - Separator Line

- (void)_updateSeparatorLineFrame
{
    if (!self.separatorLineLayer) {
        return;
    }

    CGRect separatorLineRect = CGRectZero;
    separatorLineRect.origin.x = _mySeparatorLineInset.left;
    separatorLineRect.origin.y = CGRectGetHeight(self.bounds) - self.separatorLineWidth;
    separatorLineRect.size.width = CGRectGetWidth(self.bounds) - _mySeparatorLineInset.left - _mySeparatorLineInset.right;
    separatorLineRect.size.width = MAX(0.f, separatorLineRect.size.width);
    separatorLineRect.size.height = MAX(0.f, self.separatorLineWidth);

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.separatorLineLayer.frame = separatorLineRect;
    [CATransaction commit];
}

- (void)_setNeedUpdateSeparatorLine
{
    if (self.window) {
        [self _updateSeparatorLine];
    }else {
        _needUpdateSeparatorLineWhenShowInWindow = YES;
    }
}

- (void)_updateSeparatorLine
{
    [self.separatorLineLayer removeFromSuperlayer];
    self.separatorLineLayer = nil;

    if (self.separatorLineStyle != CLTableViewCellSeparatorLineStyleNone) {

        if (self.separatorLineStyle == CLTableViewCellSeparatorLineStyleLine) {

            CALayer * layer = [CALayer layer];
            layer.backgroundColor = self.separatorLineColor.CGColor;
            self.separatorLineLayer = layer;

        }else {

            CAGradientLayer * gradientLayer = [CAGradientLayer layer];
            gradientLayer.startPoint = CGPointMake(0.f, 0.5f);
            gradientLayer.endPoint = CGPointMake(1.f, 0.5f);

            //设置颜色
            UIColor * separatorLineColor = self.separatorLineColor;
            gradientLayer.colors = @[(__bridge id)[separatorLineColor colorWithAlphaComponent:0.01f].CGColor,
                                     (__bridge id)separatorLineColor.CGColor,
                                     (__bridge id)[separatorLineColor colorWithAlphaComponent:0.01f].CGColor];

            self.separatorLineLayer = gradientLayer;
        }

        [self.layer addSublayer:self.separatorLineLayer];
        [self setNeedsLayout];
    }
}

- (void)setSeparatorLineStyle:(CLTableViewCellSeparatorLineStyle)separatorLineStyle
{
    if (_separatorLineStyle != separatorLineStyle) {
        _separatorLineStyle = separatorLineStyle;
        [self _setNeedUpdateSeparatorLine];
    }
}

- (void)setSeparatorInset:(UIEdgeInsets)separatorInset
{
    super.separatorInset = separatorInset;

    if (self.separatorLineStyle != CLTableViewCellSeparatorLineStyleNone) {
        self.mySeparatorLineInset = separatorInset;
    }
}

- (void)setMySeparatorLineInset:(UIEdgeInsets)mySeparatorLineInset
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_mySeparatorLineInset, mySeparatorLineInset)) {
        _mySeparatorLineInset = mySeparatorLineInset;
        if (self.separatorLineStyle != CLTableViewCellSeparatorLineStyleNone) {
            [self setNeedsLayout];
        }
    }
}

- (void)setSeparatorLineWidth:(CGFloat)separatorLineWidth
{
    if (_separatorLineWidth != separatorLineWidth) {
        _separatorLineWidth = separatorLineWidth;
        if (self.separatorLineStyle != CLTableViewCellSeparatorLineStyleNone) {
            [self setNeedsLayout];
        }
    }
}

- (UIColor *)separatorLineColor {
    return _separatorLineColor ?: [UIColor grayColor];
}

- (void)setSeparatorLineColor:(UIColor *)separatorLineColor
{
    if (_separatorLineColor != separatorLineColor) {
        _separatorLineColor = separatorLineColor;
        [self _setNeedUpdateSeparatorLine];
    }
}

#pragma mark - section

- (UIView *)showSelectionView {
    return self;
}

- (UIColor *)selectionColor {
    return _selectionColor ?: [self tintColor];
}

- (void)setSelectionColor:(UIColor *)selectionColor
{
    if(_selectionColor != selectionColor){
        _selectionColor = selectionColor;
        [self selectionColorDidChange];
    }
}

- (void)setSelectionColorAlpha:(CGFloat)selectionColorAlpha
{
    if (_selectionColorAlpha != selectionColorAlpha) {
        _selectionColorAlpha = selectionColorAlpha;
        [self selectionColorDidChange];
    }
}

- (void)tintColorDidChange
{
    [super tintColorDidChange];

    if (!_selectionColor) {
        [self selectionColorDidChange];
    }
}


- (UIColor *)showingSelectionColor {
    return [self.selectionColor colorWithAlphaComponent:self.selectionColorAlpha];
}

- (void)selectionColorDidChange {
    [self _updateSelectionColor];
}

- (void)_updateSelectionColor
{
    if (!_selectionLayer) {
        return;
    }

    _selectionLayer.backgroundColor = [self showingSelectionColor].CGColor;
}

- (void)setSelectionOption:(CLSelectionOption)selectionOption
{
    if (_selectionOption != selectionOption) {
        _selectionOption= selectionOption;

        if (_selectionOption == CLSelectionOptionNone) {
            [_selectionLayer removeFromSuperlayer];
            _selectionLayer = nil;
        }else{
            [self _updateSelectionViewWithAnimated:NO];
            //            self.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (self.isHighlighted != highlighted) {
        [super setHighlighted:highlighted animated:animated];
        [self _updateSelectionViewWithAnimated:animated];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.isSelected != selected) {
        [super setSelected:selected animated:animated];
        [self _updateSelectionViewWithAnimated:animated];
    }
}


- (BOOL)isShowingSelection {
    return _selectionLayer && !_selectionLayer.hidden;
}

- (CALayer *)selectionLayer
{
    if (!_selectionLayer) {
        _selectionLayer = [[CALayer alloc] init];
        _selectionLayer.actions = @{@"position":[NSNull null],
                                    @"bounds":[NSNull null],
                                    @"backgroundColor":[NSNull null]};
        //        _selectionLayer.frame = [self showSelectionView].bounds;
        [self _updateSelectionColor];
    }

    return _selectionLayer;
}

- (void)_updateSelectionViewWithAnimated:(BOOL)animated
{
    BOOL show = NO;
    if (self.selectionOption & CLSelectionOptionSelected) {
        if(self.selectionOption & CLSelectionOptionHighlighted){
            show = self.isSelected || self.isHighlighted;
        }else{
            show = self.isSelected;
        }
    }else if (self.selectionOption & CLSelectionOptionHighlighted) {
        show = self.isHighlighted;
    }

    [self _showSelectionView:show animated:animated || (!show && self.animatedSelectionForHidden)];
}

- (void)_showSelectionView:(BOOL)show animated:(BOOL)animated
{
    //正在显示
    if ([self isShowingSelection] == show) {
        return;
    }

    for (NSObject * object in self.highlightedObjects) {
        if([object respondsToSelector:@selector(setHighlighted:)]){
            [(id)object setHighlighted:show];
        }
    }

    if (show) {
        [[self showSelectionView].layer insertSublayer:self.selectionLayer atIndex:0];
        self.selectionLayer.frame = [self showSelectionView].bounds;

        [CATransaction begin];
        [CATransaction setDisableActions:!animated];
        _selectionLayer.hidden = NO;
        [CATransaction commit];

    }else{

        [CATransaction begin];
        [CATransaction setDisableActions:!animated];
        _selectionLayer.hidden = YES;
        [CATransaction commit];
    }
}

#pragma mark -

- (void)prepareForReuse
{
    [super prepareForReuse];
    _needUpdateCellWhenShowInWindow = NO;
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

        if (_needUpdateSeparatorLineWhenShowInWindow) {
            _needUpdateCellWhenShowInWindow = NO;
            [self _updateSeparatorLine];
        }
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
