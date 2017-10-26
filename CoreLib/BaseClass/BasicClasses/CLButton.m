//
//  CLButton.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/27.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLButton.h"

@interface CLButton()

@property(nonatomic,readonly,strong) NSMutableDictionary * backgrounpColorDic;

@end

//----------------------------------------------------------


@implementation CLButton
{
    BOOL _isRegistedKVO;
}

@synthesize backgrounpColorDic = _backgrounpColorDic;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setBackgroundColor:self.backgroundColor forState:self.state];
        self.intrinsicSizeExpansionLength = [aDecoder decodeCGSizeForKey:@"intrinsicSizeExpansionLength"];
        self.intrinsicSizeExpansionScale = [aDecoder decodeCGSizeForKey:@"intrinsicSizeExpansionScale"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeCGSize:self.intrinsicSizeExpansionLength forKey:@"intrinsicSizeExpansionLength"];
    [aCoder encodeCGSize:self.intrinsicSizeExpansionLength forKey:@"intrinsicSizeExpansionScale"];
}


- (void)dealloc {
    [self _unregisterKVO_CLButton];
}

#pragma mark -

- (NSMutableDictionary *)backgrounpColorDic
{
    if (!_backgrounpColorDic) {
        _backgrounpColorDic = [NSMutableDictionary dictionary];
    }

    return _backgrounpColorDic;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (self.isHighlighted != highlighted) {
        [super setHighlighted:highlighted];

        [self _updateBackgroundColor];
    }
}

- (void)setEnabled:(BOOL)enabled
{
    if (self.enabled != enabled) {
        [super setEnabled:enabled];

        [self _updateBackgroundColor];
    }
}

- (void)setSelected:(BOOL)selected
{
    if (self.isSelected != selected) {
        [super setSelected:selected];

        [self _updateBackgroundColor];
    }
}

- (void)setAutoAdjustBackgroundColor:(BOOL)autoAdjustBackgroundColor
{
    if (_autoAdjustBackgroundColor != autoAdjustBackgroundColor) {
        _autoAdjustBackgroundColor = autoAdjustBackgroundColor;
        [self _updateBackgroundColor];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [self setBackgroundColor:backgroundColor forState:UIControlStateNormal];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self.backgrounpColorDic setObject: backgroundColor ?: [UIColor clearColor] forKey:@(state)];

    if (state == self.state) {
        [self _updateBackgroundColor];
    }
}

- (UIColor *)backgroundColorForState:(UIControlState)state {
    return [self.backgrounpColorDic objectForKey:@(state)];
}

- (UIColor *)showingBackgroundColorForState:(UIControlState)state
{
    UIColor * backgroundColor = [self backgroundColorForState:state];

    if (!backgroundColor && state != UIControlStateNormal) {

        if (self.autoAdjustBackgroundColor) {

            if (state & UIControlStateDisabled) {
                backgroundColor = [[self showingBackgroundColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5f];
            }else if (state & UIControlStateHighlighted){
                backgroundColor = [[self showingBackgroundColorForState:UIControlStateSelected] colorWithAlphaComponent:0.5f];
            }else{
                backgroundColor = [self backgroundColorForState:UIControlStateNormal];
            }

        }else{
            backgroundColor = [self backgroundColorForState:UIControlStateNormal];
        }
    }

    return backgroundColor ?: [UIColor clearColor];
}

- (void)_updateBackgroundColor {
    [super setBackgroundColor:[self showingBackgroundColorForState:self.state]];
}

#pragma mark -

- (void)setIntrinsicSizeExpansionLength:(CGSize)intrinsicSizeExpansionLength
{
    if (!CGSizeEqualToSize(_intrinsicSizeExpansionLength, intrinsicSizeExpansionLength)) {
        _intrinsicSizeExpansionLength = intrinsicSizeExpansionLength;
        [self invalidateIntrinsicContentSize];
    }
}

- (void)setIntrinsicSizeExpansionScale:(CGSize)intrinsicSizeExpansionScale
{
    if (!CGSizeEqualToSize(_intrinsicSizeExpansionScale, intrinsicSizeExpansionScale)) {
        _intrinsicSizeExpansionScale = intrinsicSizeExpansionScale;
        [self invalidateIntrinsicContentSize];
    }
}

- (CGSize)intrinsicContentSize
{
    CGSize intrinsicContentSize = [super intrinsicContentSize];

    intrinsicContentSize.width *= (1.f + self.intrinsicSizeExpansionScale.width);
    intrinsicContentSize.width += self.intrinsicSizeExpansionLength.width;
    intrinsicContentSize.height *= (1.f + self.intrinsicSizeExpansionScale.width);
    intrinsicContentSize.height += self.intrinsicSizeExpansionLength.height;

    return intrinsicContentSize;

}

#pragma mark -

- (void)setButtonDidChangeTouchStateBlock:(void (^)(CLButton *, BOOL))buttonDidChangeTouchStateBlock
{
    _buttonDidChangeTouchStateBlock = [buttonDidChangeTouchStateBlock copy];

    if (_buttonDidChangeTouchStateBlock) {
        [self _registerKVO_CLButton];
    }else {
        [self _unregisterKVO_CLButton];
    }
}

- (void)_performButtonDidChangeTouchStateBlock
{
    if (self.buttonDidChangeTouchStateBlock) {
        self.buttonDidChangeTouchStateBlock(self,self.isHighlighted);
    }
}

#pragma mark - KVO

- (void)_registerKVO_CLButton
{
    if (!_isRegistedKVO) {
        _isRegistedKVO = YES;

        //注册
        [self addObserver:self
               forKeyPath:@"highlighted"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
    }
}

- (void)_unregisterKVO_CLButton
{
    if (_isRegistedKVO) {
        _isRegistedKVO = NO;

        [self removeObserver:self forKeyPath:@"highlighted"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self && ![change[@"old"] isEqual:change[@"new"]]) {

        if ([NSThread isMainThread]) {
            [self _performButtonDidChangeTouchStateBlock];
        }else {
            [self performSelectorOnMainThread:@selector(_performButtonDidChangeTouchStateBlock)
                                   withObject:nil
                                waitUntilDone:NO];
        }
    }
}


@end
