//
//  CLImageTitleStaticCollectionViewCell.m
//  cpLottery
//
//  Created by luis on 2017/11/15.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "CLImageTitleStaticCollectionViewCell.h"
#import "UIImage+Tint.h"

//----------------------------------------------------------

typedef NS_ENUM(NSInteger,_Attributed_Index) {
    _Attributed_Index_AttributedTexts,
    _Attributed_Index_TextColors,
    _Attributed_Index_Texts,
    _Attributed_Index_Images,
    _Attributed_Index_Count
};

//----------------------------------------------------------

@interface CLImageTitleStaticCollectionViewCell ()

@property(nonatomic,strong,readonly) NSMutableArray * attributedes;

@end

//----------------------------------------------------------

@implementation CLImageTitleStaticCollectionViewCell
{
    //内容是否有效
    BOOL _contentVaild;
}

@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;

@synthesize attributedes = _attributedes;

#pragma mark -

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self _setup_MyImageTitleStaticCollectionViewCell];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setup_MyImageTitleStaticCollectionViewCell];
    }
    
    return self;
}

- (void)_setup_MyImageTitleStaticCollectionViewCell
{
    _autoAdjustTextColor = YES;
    _titleImageMargin = 5.f;
    _adjustImageWithTextColor = YES;
    
    [self _registerKVO];
}

- (void)dealloc {
    [self _unregisterKVO];
}

#pragma mark - KVO

- (NSArray *)_observableKeypaths
{
    return @[//@"autoAdjustImage",
             @"adjustImageWithTextColor",
             @"autoAdjustTextColor",
             @"textFont",
             @"layout",
             @"contentLayout",
             @"contentAlign",
             @"titleImageMargin",
             @"contentInset",
             @"titleImageMargin",
             @"contentLayoutBlock"];
}

- (void)_registerKVO
{
    for (NSString * keyPath in [self _observableKeypaths]) {
        [self addObserver:self
               forKeyPath:keyPath
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
    }
}

- (void)_unregisterKVO
{
    for (NSString * keyPath in [self _observableKeypaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self == object && ![change[@"old"] isEqual:change[@"new"]]) {
        
        if ([NSThread isMainThread]) {
            [self _updateUIForKeypath:keyPath];
        }else{
            [self performSelectorOnMainThread:@selector(_updateUIForKeypath:)
                                   withObject:keyPath
                                waitUntilDone:NO];
        }
    }
}

- (void)_updateUIForKeypath:(NSString *)keyPath
{
    if ([keyPath isEqualToString:@"autoAdjustTextColor"] ||
        [keyPath isEqualToString:@"adjustImageWithTextColor"] ||
        [keyPath isEqualToString:@"textFont"]) {
        _contentVaild = NO;
    }else if ([keyPath isEqualToString:@"contentLayout"] ||
              [keyPath isEqualToString:@"contentAlign"]) {
        
        //存在自定义布局忽略
        if (self.contentLayoutBlock) {
            return;
        }
    }
    
    [self setNeedsLayout];
}

#pragma mark -

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    
    return _imageView ;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        [self addSubview:_textLabel];
    }
    
    return _textLabel;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_contentVaild) {
        _contentVaild = YES;
        
        CLImageTitleStaticCollectionViewCellState state = self.state;
        NSAttributedString * attributedText = [self showingAttributedTextForState:state];
        if (attributedText) {
            self.textLabel.attributedText = attributedText;
        }else{
            self.textLabel.font = self.textFont;
            self.textLabel.textColor = [self showingTextColorForState:state];
            self.textLabel.text = [self showingTextForState:state];
        }
        
        self.imageView.image = [self showingImageForState:state];
    }
    
    CGRect containerRect =  UIEdgeInsetsInsetRect(self.bounds, self.contentInset);
    CGRect contentRect   =  CGRectMake(0.f, 0.f, CGRectGetWidth(containerRect), CGRectGetHeight(containerRect));
    CGRect titleRect     =  CGRectZero;
    CGRect imageRect     =  CGRectZero;
    
    if(CGRectGetWidth(contentRect) > 0 && CGRectGetHeight(contentRect) > 0){
        
        //计算大小
        CGSize titleDrawSize = [self.textLabel intrinsicContentSize];
        CGSize imageDrawSize = self.imageView.image.size;
        
        //水平布局
        if (self.layout == CLImageTitleStaticCollectionViewCellLayoutImageLeft ||
            self.layout == CLImageTitleStaticCollectionViewCellLayoutImageRight) {
            
            //计算内容大小
            BOOL hasMargin = (titleDrawSize.width && imageDrawSize.width);
            
            CGSize imageMaxSize = CGSizeZero;
            imageMaxSize.width = CGRectGetWidth(contentRect) - (hasMargin? self.titleImageMargin : 0.f);
            imageMaxSize.width = MAX(0.f, imageMaxSize.width);
            imageMaxSize.height = CGRectGetHeight(contentRect);
            
            //缩小图片到合适大小
            CGSize targetSize = sizeZoomToTagetSize(imageDrawSize, imageMaxSize, CLZoomModeAspectFit);
            if (targetSize.width < imageDrawSize.width) {
                imageDrawSize = targetSize;
            }
            
            //显示不下则缩小
            if (imageMaxSize.width < imageDrawSize.width + titleDrawSize.width){
                titleDrawSize.width = imageMaxSize.width - imageDrawSize.width;
            }
            
            contentRect.size.width = titleDrawSize.width + imageDrawSize.width + (hasMargin ? self.titleImageMargin : 0.f);
            contentRect.size.height = MAX(titleDrawSize.height, imageDrawSize.height);
            
        }else{ //竖直布局
            
            //计算内容大小
            BOOL hasMargin = (titleDrawSize.height && imageDrawSize.height);
            
            CGSize imageMaxSize = CGSizeZero;
            imageMaxSize.height = CGRectGetHeight(contentRect) - (hasMargin? self.titleImageMargin : 0.f);
            imageMaxSize.height = MAX(0.f, imageMaxSize.height);
            imageMaxSize.width = CGRectGetWidth(contentRect);
            
            //缩小图片到合适大小
            CGSize targetSize = sizeZoomToTagetSize(imageDrawSize, imageMaxSize, CLZoomModeAspectFit);
            if (targetSize.height < imageDrawSize.height) {
                imageDrawSize = targetSize;
            }
            
            if (imageMaxSize.height < imageDrawSize.height + titleDrawSize.height){
                titleDrawSize.height = imageMaxSize.height - imageDrawSize.height;
            }
            
            contentRect.size.height = titleDrawSize.height + imageDrawSize.height + (hasMargin ? self.titleImageMargin : 0.f);
            contentRect.size.width = MAX(titleDrawSize.width, imageDrawSize.width);
        }
        
        
        if (self.contentLayoutBlock) { //自定义布局
            
            self.contentLayoutBlock(containerRect,
                                    contentRect.size,
                                    imageDrawSize,
                                    titleDrawSize,
                                    &contentRect,
                                    &imageRect,
                                    &titleRect);
        }else {
            
            //计算布局方式
            
            CLContentLayout imageLayout,titleLayout;
            
            if (self.layout == CLImageTitleStaticCollectionViewCellLayoutImageLeft ||
                self.layout == CLImageTitleStaticCollectionViewCellLayoutImageRight) {
                
                if (self.contentAlign == CLImageTitleStaticCollectionViewCellContentAlignTop) {
                    imageLayout = CLContentLayoutTop;
                }else if (self.contentAlign == CLImageTitleStaticCollectionViewCellContentAlignBottom){
                    imageLayout = CLContentLayoutBottom;
                }else{
                    imageLayout = CLContentLayoutCenter;
                }
                
                titleLayout = imageLayout;
                
                if (self.layout == CLImageTitleStaticCollectionViewCellLayoutImageLeft) { //图左文右
                    imageLayout |= CLContentLayoutLeft;
                    titleLayout |= CLContentLayoutRight;
                }else{ //文左图右
                    imageLayout |= CLContentLayoutRight;
                    titleLayout |= CLContentLayoutLeft;
                }
                
                
            }else {
                
                if (self.contentAlign == CLImageTitleStaticCollectionViewCellContentAlignLeft) {
                    imageLayout = CLContentLayoutLeft;
                }else if (self.contentAlign == CLImageTitleStaticCollectionViewCellContentAlignRight){
                    imageLayout = CLContentLayoutRight;
                }else{
                    imageLayout = CLContentLayoutCenter;
                }
                
                titleLayout = imageLayout;
                
                if (self.layout == CLImageTitleStaticCollectionViewCellLayoutImageTop) { //图上文下
                    imageLayout |= CLContentLayoutTop;
                    titleLayout |= CLContentLayoutBottom;
                }else{ //文上图下
                    imageLayout |= CLContentLayoutBottom;
                    titleLayout |= CLContentLayoutLeft;
                }
            }
            
            //计算内容视图的rect
            contentRect = contentRectForLayout(containerRect, contentRect.size, self.contentLayout);
            contentRect = CGRectOffset(contentRect, self.contentOffset.x, self.contentOffset.y);
            
            //计算文字和图片位置
            titleRect = contentRectForLayout(contentRect, titleDrawSize, titleLayout);
            imageRect = contentRectForLayout(contentRect, imageDrawSize, imageLayout);
        }
    }
    
    self.imageView.frame = imageRect;
    self.textLabel.frame = titleRect;
}

- (CGPoint)_offsetForRect:(CGRect)rect
                     size:(CGSize)size
                   layout:(CLContentLayout)layout
{
    CGPoint offset = CGPointZero;
    
    //水平
    if (layout & CLContentLayoutLeft) {
        offset.x = CGRectGetMinX(rect);
    }else if(layout & CLContentLayoutRight){
        offset.x = CGRectGetMaxX(rect) - size.width;
    }else{
        offset.x = CGRectGetMinX(rect) + (CGRectGetWidth(rect) - size.width) * 0.5f;
    }
    
    //竖直
    if (layout & CLContentLayoutTop) {
        offset.y = CGRectGetMinY(rect);
    }else if(layout & CLContentLayoutBottom){
        offset.y = CGRectGetMaxY(rect) - size.height;
    }else{
        offset.y = CGRectGetMinY(rect) + (CGRectGetHeight(rect) - size.height) * 0.5f;
    }
    
    return offset;
}

- (CGRect)_alignRectForRect:(CGRect)rect
                       size:(CGSize)size
                     layout:(CLContentLayout)layout
{
    CGPoint offset = [self _offsetForRect:rect
                                     size:size
                                   layout:layout];
    
    return CGRectMake(offset.x, offset.y, size.width, size.height);
}


#pragma mark -

- (NSMutableArray *)attributedes
{
    if (!_attributedes) {
        _attributedes = [NSMutableArray arrayWithCapacity:_Attributed_Index_Count];
        for (NSUInteger i = 0; i < _Attributed_Index_Count ; ++ i) {
            [_attributedes addObject:[NSMutableDictionary dictionaryWithCapacity:4]];
        }
    }
    
    return _attributedes;
}

- (void)_setAttributed:(id)attributed
              forState:(CLImageTitleStaticCollectionViewCellState)state
               atIndex:(NSUInteger)index
{
    BOOL neeTryLayout = YES;
    
    if (attributed) {
        [self.attributedes[index] setObject:attributed forKey:@(state)];
    }else if([self _attributedForState:state atIndex:index]){
        [self.attributedes[index] removeObjectForKey:@(state)];
    }else{
        neeTryLayout = NO;
    }
    
    if (neeTryLayout) {
        [self _layoutViewIfNeedWhenPropertyChangeForState:state];
    }
}

- (id)_attributedForState:(CLImageTitleStaticCollectionViewCellState)state atIndex:(NSUInteger)index {
    return [self.attributedes[index] objectForKey:@(state)];
}

- (void)_layoutViewIfNeedWhenPropertyChangeForState:(CLImageTitleStaticCollectionViewCellState)state
{
    if (self.state == state || state == CLImageTitleStaticCollectionViewCellStateNormal) {
        _contentVaild = NO;
        [self setNeedsLayout];
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText
                 forState:(CLImageTitleStaticCollectionViewCellState)state
{
    [self _setAttributed:attributedText forState:state atIndex:_Attributed_Index_AttributedTexts];
}


- (NSAttributedString *)attributedTextForState:(CLImageTitleStaticCollectionViewCellState)state {
    return [self _attributedForState:state atIndex:_Attributed_Index_AttributedTexts];
}

- (NSAttributedString *)showingAttributedTextForState:(CLImageTitleStaticCollectionViewCellState)state
{
    NSAttributedString * attributedTexts = [self attributedTextForState:state];
    if (!attributedTexts && state != CLImageTitleStaticCollectionViewCellStateNormal) {
        attributedTexts = [self attributedTextForState:CLImageTitleStaticCollectionViewCellStateNormal];
    }
    
    return attributedTexts;
}

- (void)setTextColor:(UIColor *)textColor forState:(CLImageTitleStaticCollectionViewCellState)state {
    [self _setAttributed:textColor forState:state atIndex:_Attributed_Index_TextColors];
}

- (UIColor *)textColorForState:(CLImageTitleStaticCollectionViewCellState)state {
    return [self _attributedForState:state atIndex:_Attributed_Index_TextColors];
}

- (UIColor *)showingTextColorForState:(CLImageTitleStaticCollectionViewCellState)state
{
    UIColor * textColor = [self textColorForState:state];
    
    if (!textColor && state !=  CLImageTitleStaticCollectionViewCellStateNormal) {
        if (self.autoAdjustTextColor && (state & CLImageTitleStaticCollectionViewCellStateHighlighted)) {
            textColor = [[self showingTextColorForState:CLImageTitleStaticCollectionViewCellStateSelected] colorWithAlphaComponent:0.5f];
        }else{
            textColor = [self textColorForState:CLImageTitleStaticCollectionViewCellStateNormal];
        }
    }
    
    return textColor ?: [UIColor blackColor];
}

- (void)setText:(NSString *)text forState:(CLImageTitleStaticCollectionViewCellState)state {
    [self _setAttributed:text forState:state atIndex:_Attributed_Index_Texts];
}

- (NSString *)textForState:(CLImageTitleStaticCollectionViewCellState)state {
    return [self _attributedForState:state atIndex:_Attributed_Index_Texts];
}

- (NSString *)showingTextForState:(CLImageTitleStaticCollectionViewCellState)state
{
    NSString * text = [self textForState:state];
    if (!text && state != CLImageTitleStaticCollectionViewCellStateNormal) {
        return [self textForState:CLImageTitleStaticCollectionViewCellStateNormal];
    }
    
    return text;
}

- (UIFont *)textFont {
    return _textFont ?: [UIFont systemFontOfSize:17.f];
}

- (void)setImage:(UIImage *)image forState:(CLImageTitleStaticCollectionViewCellState)state {
    [self _setAttributed:image forState:state atIndex:_Attributed_Index_Images];
}

- (UIImage *)imageForState:(CLImageTitleStaticCollectionViewCellState)state {
    return [self _attributedForState:state atIndex:_Attributed_Index_Images];
}

- (UIImage *)showingImageForState:(CLImageTitleStaticCollectionViewCellState)state
{
    UIImage * image = [self imageForState:state];
    if (!image && state != CLImageTitleStaticCollectionViewCellStateNormal) {
        image = [self imageForState:CLImageTitleStaticCollectionViewCellStateNormal];
    }
    
    return (image && self.adjustImageWithTextColor) ? [image imageWithTintColor:[self showingTextColorForState:state]] : image;
}


#pragma mark -

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (self.isHighlighted != highlighted) {
        
        CLImageTitleStaticCollectionViewCellState fromState = self.state;
        [super setHighlighted:highlighted animated:animated];
        [self cellStateDidChangeFromState:fromState];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.isSelected != selected) {
        
        CLImageTitleStaticCollectionViewCellState fromState = self.state;
        [super setSelected:selected animated:animated];
        [self cellStateDidChangeFromState:fromState];
    }
}

- (CLImageTitleStaticCollectionViewCellState)state
{
    CLImageTitleStaticCollectionViewCellState state = CLImageTitleStaticCollectionViewCellStateNormal;
    
    if (self.isHighlighted) {
        state |= CLImageTitleStaticCollectionViewCellStateHighlighted;
    }
    
    if (self.isSelected) {
        state |= CLImageTitleStaticCollectionViewCellStateSelected;
    }
    
    return state;
}

- (void)cellStateDidChangeFromState:(CLImageTitleStaticCollectionViewCellState)fromState
{
    _contentVaild = NO;
    [self setNeedsLayout];
}
@end

