//
//  CLSectionControl.m
//  TaskTracking
//
//  Created by apple pro on 2017/2/21.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLSectionControl.h"

//----------------------------------------------------------

#import "CLSectionControl.h"
#import "MacroDef.h"
#import "UIImage+Tint.h"
#import "CLBadgeView.h"

//----------------------------------------------------------

@interface _CLSectionControlSection : NSObject

- (id)initWithTitle:(NSString *)title
              image:(UIImage *)image
   highlightedImage:(UIImage *)highlightedImage
      selectedImage:(UIImage *)selectedImage
      disabledImage:(UIImage *)disabledImage;

@property(nonatomic,strong) NSString * title;

@property(nonatomic,strong,readonly) NSMutableDictionary * images;
- (void)setImage:(UIImage *)image forState:(CLSectionControlSectionState)state;
- (UIImage *)imageForState:(CLSectionControlSectionState)state;

@property(nonatomic) BOOL enabled;

@property(nonatomic) CGRect sectionRect;
@property(nonatomic) CGRect sectionContentRect;
@property(nonatomic) CGRect sectionImageRect;
@property(nonatomic) CGRect sectionTitleRect;

@property(nonatomic,strong) NSString * badgeValue;
@property(nonatomic,strong) CLBadgeView * badgeView;

@end

//----------------------------------------------------------

@implementation _CLSectionControlSection

@synthesize images = _images;
@synthesize badgeView = _badgeView;

- (id)init
{
    return [self initWithTitle:nil
                         image:nil
              highlightedImage:nil
                 selectedImage:nil
                 disabledImage:nil];
}

- (id)initWithTitle:(NSString *)title
              image:(UIImage *)image
   highlightedImage:(UIImage *)highlightedImage
      selectedImage:(UIImage *)selectedImage
      disabledImage:(UIImage *)disabledImage
{
    self = [super init];

    if (self) {

        self.enabled = YES;
        self.title   = title;

        if (image) {
            [self setImage:image forState:CLSectionControlSectionStateNormal];
        }
        if (highlightedImage) {
            [self setImage:highlightedImage forState:CLSectionControlSectionStateHighlighted];
        }
        if (selectedImage) {
            [self setImage:selectedImage forState:CLSectionControlSectionStateSelected];
        }
        if (disabledImage) {
            [self setImage:disabledImage forState:CLSectionControlSectionStateDisabled];
        }
    }

    return self;
}

- (void)dealloc {
    [self.badgeView removeFromSuperview];
}

- (void)setTitle:(NSString *)title
{
    if ([title isEqual:[NSNull null]]) {
        _title = nil;
    }else if ([title isKindOfClass:[NSString class]]){
        _title = title;
    }else{
        _title = [title description];
    }
}

- (NSMutableDictionary *)images
{
    if (!_images) {
        _images = [NSMutableDictionary dictionaryWithCapacity:CLSectionControlSectionStateCount];
    }
    return _images;
}

- (void)setImage:(UIImage *)image forState:(CLSectionControlSectionState)state
{
    if ([image isKindOfClass:[UIImage class]]) {
        [self.images setObject:image forKey:@(state)];
    }else if(_images){
        [_images removeObjectForKey:@(state)];
    }
}

- (UIImage *)imageForState:(CLSectionControlSectionState)state {
    return _images ? _images[@(state)] : nil;
}

@end

//----------------------------------------------------------

@interface CLSectionControl ()

@property(nonatomic,strong,readonly) NSMutableArray * sections;
@property(nonatomic,strong,readonly) NSMutableDictionary * textColors;
@property(nonatomic,strong,readonly) NSMutableDictionary * sectionBackgroundColors;
@property(nonatomic,strong,readonly) CALayer * selectedIndicatorLine;

@property(nonatomic) BOOL isInvalidateContent;

//badge内容视图
@property(nonatomic,strong,readonly) UIView * badgeContentView;

@end

//----------------------------------------------------------


@implementation CLSectionControl
{
    NSUInteger _highlightedSectionIndex;
}

@synthesize sections   = _sections;
@synthesize textColors = _textColors;
@synthesize sectionBackgroundColors = _sectionBackgroundColors;
@synthesize selectedIndicatorLine = _selectedIndicatorLine;
@synthesize selectedSectionIndex  = _selectedSectionIndex;
@synthesize textFont = _textFont;
@synthesize selectedIndicatorLineColor = _selectedIndicatorLineColor;
@synthesize selectedIndicatorLineWidth = _selectedIndicatorLineWidth;
@synthesize separatorLineColor = _separatorLineColor;
@synthesize separatorLineWidth = _separatorLineWidth;
@synthesize borderColor = _borderColor;
@synthesize borderWidth = _borderWidth;
@synthesize badgeContentView = _badgeContentView;

#pragma mark-
+ (CLSectionControl *)createSystemStyleSegmentedControlWithTitles:(NSArray *)titles
{
    CLSectionControl * segmentedControl = [[CLSectionControl alloc] initWithSectionTitles:titles];

    segmentedControl.separatorLineColor = ColorWithNumberRGB(0x9a9a9a);
    segmentedControl.drawGradientSeparatorLine = NO;

    //border
    segmentedControl.clipsToBounds = YES;
    segmentedControl.layer.cornerRadius = 5.f;
    segmentedControl.layer.borderWidth = PixelToPoint(1.f);
    segmentedControl.layer.borderColor = segmentedControl.separatorLineColor.CGColor;

    //background
    segmentedControl.backgroundColor = [UIColor whiteColor];
    [segmentedControl setSectionBackgroundColor:ColorWithNumberRGB(0x999999)
                                       forState:CLSectionControlSectionStateSelected];

    //text
    [segmentedControl setTextColor:ColorWithNumberRGB(0x333333)
                          forState:CLSectionControlSectionStateNormal];
    [segmentedControl setTextColor:[UIColor whiteColor]
                          forState:CLSectionControlSectionStateSelected];
    segmentedControl.autoAdjustTextColor = NO;
    [segmentedControl setTextFont:[UIFont systemFontOfSize:17.f]];


    return segmentedControl;
}

+ (CLSectionControl *)createLightStyleSegmentedControlWithTitles:(NSArray *)titles images:(NSArray *)images
{
    return [self createLightStyleSegmentedControlWithTitles:titles
                                                     images:images
                                             selectedImages:nil
                                  showSelectedIndicatorLine:NO];
}

+ (CLSectionControl *)createLightStyleSegmentedControlWithTitles:(NSArray *)titles
                                                            images:(NSArray *)images
                                                    selectedImages:(NSArray *)selectedImages
                                         showSelectedIndicatorLine:(BOOL)showSelectedIndicatorLine
{
    CLSectionControl * segmentedControl = [[CLSectionControl alloc] initWithSectionTitles:titles images:images highlightedImages:nil selectedImages:selectedImages disabledImages:nil];

    //背景
    segmentedControl.backgroundColor = [UIColor whiteColor];

    //文本
    [segmentedControl setTextColor:ColorWithNumberRGB(0x212121) forState:CLSectionControlSectionStateNormal];
    [segmentedControl setTextColor:ColorWithNumberRGB(0xff5a00) forState:CLSectionControlSectionStateSelected];

    segmentedControl.textFont = [UIFont systemFontOfSize:16.f];
    segmentedControl.titleImageMargin = 10.f;

    //分割线
    segmentedControl.separatorLineColor = ColorWithNumberRGB(0xCCCCCC);
    segmentedControl.separatorLineInsetScale = UIEdgeInsetsMake(0.25f, 0.f, 0.25f, 0.f);
    segmentedControl.adjustImageWithTextColor = YES;

    //边界
    segmentedControl.borderMask = CLSectionControlBorderBottom;
    segmentedControl.borderColor = ColorWithNumberRGB(0xCCCCCC);

    if (showSelectedIndicatorLine) {
        segmentedControl.showSelectedIndicatorLine = YES;
        segmentedControl.selectedIndicatorLineWidth = 2.f;
        segmentedControl.selectedIndicatorLineColor = ColorWithNumberRGB(0xff5a00);
        segmentedControl.apportionsSelectedIndicatorLineByContent = YES;
        segmentedControl.selectedIndicatorLineInset = UIEdgeInsetsMake(0.f, - 4.f, 0.f, - 4.f);
    }

    return segmentedControl;
}

#pragma mark - life circle

- (id)init {
    return [self initWithSectionTitles:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithSectionTitles:nil];

    if (self) {
        self.frame = frame;
    }

    return self;
}

- (id)initWithSectionTitles:(NSArray *)titles
{
    return [self initWithSectionTitles:titles
                                images:nil
                     highlightedImages:nil
                        selectedImages:nil
                        disabledImages:nil];
}

- (id)initWithSectionImages:(NSArray *)images
{
    return [self initWithSectionTitles:nil
                                images:images
                     highlightedImages:nil
                        selectedImages:nil
                        disabledImages:nil];
}

- (id)initWithSectionTitles:(NSArray *)titles
                     images:(NSArray *)images
{
    return [self initWithSectionTitles:titles
                                images:images
                     highlightedImages:nil
                        selectedImages:nil
                        disabledImages:nil];
}

- (id)initWithSectionTitles:(NSArray *)titles
                     images:(NSArray *)images
          highlightedImages:(NSArray *)highlightedImages
             selectedImages:(NSArray *)selectedImages
             disabledImages:(NSArray *)disabledImages
{
    self = [super initWithFrame:CGRectZero];

    if (self) {

        //初始化
        [self _commonInit_CLSectionControl];

        [self addSectionsWithTitles:titles
                             images:images
                  highlightedImages:highlightedImages
                     selectedImages:selectedImages
                     disabledImages:disabledImages];


        [self sizeToFit];
    }


    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _commonInit_CLSectionControl];
    }

    return self;
}

- (void)_commonInit_CLSectionControl
{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    super.contentMode = UIViewContentModeRedraw;

    _autoAdjustImage           = YES;
    _autoAdjustTextColor       = YES;
    _autoAdjustBackgroundColor = YES;
    _drawGradientSeparatorLine = YES;

    _selectedIndicatorLineWidth = 2.f;
    _separatorLineWidth = PixelToPoint(1.f);
    _borderWidth = _separatorLineWidth;

    _titleImageMargin = 2.f;

    _selectedSectionIndex = NoneSectionIndex;
    _highlightedSectionIndex = NoneSectionIndex;

    [self _invalidateContent];
}

- (void)setContentMode:(UIViewContentMode)contentMode {
    //do nothing
}

#pragma mark - section

- (NSMutableArray *)sections
{
    if (!_sections) {
        _sections = [NSMutableArray array];
    }

    return _sections;
}

- (NSUInteger)sectionCount{
    return self.sections.count;
}

- (void)addSectionsWithTitles:(NSArray *)titles
{
    [self addSectionsWithTitles:titles
                         images:nil
              highlightedImages:nil
                 selectedImages:nil
                 disabledImages:nil];
}

- (void)addSectionsWithImages:(NSArray *)images
{
    [self addSectionsWithTitles:nil
                         images:images
              highlightedImages:nil
                 selectedImages:nil
                 disabledImages:nil];
}

- (void)addSectionsWithDatas:(NSArray *)datas
{
    if (datas.count) {

        NSMutableArray * titles = [NSMutableArray arrayWithCapacity:datas.count];
        NSMutableArray * images = [NSMutableArray arrayWithCapacity:datas.count];

        for (id data in datas) {

            if ([data isKindOfClass:[NSString class]]) {
                [titles addObject:data];
                [images addObject:[NSNull null]];
            }else if ([data isKindOfClass:[UIImage class]]) {
                [titles addObject:[NSNull null]];
                [images addObject:data];
            }else {
                [titles addObject:[NSNull null]];
                [images addObject:[NSNull null]];
            }
        }

        [self addSectionsWithTitles:titles
                             images:images
                  highlightedImages:nil
                     selectedImages:nil
                     disabledImages:nil];
    }
}

- (void)addSectionsWithTitles:(NSArray *)titles
                       images:(NSArray *)images
{
    [self addSectionsWithTitles:titles
                         images:images
              highlightedImages:nil
                 selectedImages:nil
                 disabledImages:nil];
}

- (void)addSectionsWithTitles:(NSArray *)titles
                       images:(NSArray *)images
            highlightedImages:(NSArray *)highlightedImages
               selectedImages:(NSArray *)selectedImages
               disabledImages:(NSArray *)disabledImages
{
    NSUInteger addSectionsCount = MAX(titles.count, images.count);

    //无元素
    if (addSectionsCount == 0) {
        return;
    }

    //当前触摸无效
    [self _invalidateCurrentTouch];

    for (int i = 0; i < addSectionsCount; ++ i) {

        _CLSectionControlSection * section =
        [[_CLSectionControlSection alloc] initWithTitle:i < titles.count ? titles[i] : nil
                                                    image:i < images.count ? images[i] : nil
                                         highlightedImage:i < highlightedImages.count ? highlightedImages[i] : nil
                                            selectedImage:i < selectedImages.count ? selectedImages[i] : nil
                                            disabledImage:i < disabledImages.count ? disabledImages[i] : nil];

        [self.sections addObject:section];
    }

    [self _invalidateContent];
}

- (void)editSectionWithType:(CLSectionControlSectionEditType)editType
                    atIndex:(NSUInteger)index
                  withTitle:(NSString *)title
{
    [self editSectionWithType:editType
                      atIndex:index
                    withTitle:title
                        image:nil
             highlightedImage:nil
                selectedImage:nil
                disabledImage:nil];
}

- (void)editSectionWithType:(CLSectionControlSectionEditType)editType
                    atIndex:(NSUInteger)index
                  withImage:(UIImage *)image
{
    [self editSectionWithType:editType
                      atIndex:index
                    withTitle:nil
                        image:image
             highlightedImage:nil
                selectedImage:nil
                disabledImage:nil];
}

- (void)editSectionWithType:(CLSectionControlSectionEditType)editType
                    atIndex:(NSUInteger)index
                  withTitle:(NSString *)title
                      image:(UIImage *)image
{
    [self editSectionWithType:editType
                      atIndex:index
                    withTitle:title
                        image:image
             highlightedImage:nil
                selectedImage:nil
                disabledImage:nil];
}

- (void)editSectionWithType:(CLSectionControlSectionEditType)editType
                    atIndex:(NSUInteger)index
                  withTitle:(NSString *)title
                      image:(UIImage *)image
           highlightedImage:(UIImage *)highlightedImage
              selectedImage:(UIImage *)selectedImage
              disabledImage:(UIImage *)disabledImage
{
    checkIndexAtRange(index, NSMakeRange(0, self.sectionCount));

    //当前触摸无效
    [self _invalidateCurrentTouch];

    switch (editType) {
        case CLSectionControlSectionInsert:
        {
            _CLSectionControlSection * section =
            [[_CLSectionControlSection alloc] initWithTitle:title
                                                        image:image
                                             highlightedImage:highlightedImage
                                                selectedImage:selectedImage
                                                disabledImage:disabledImage];


            //更新选择的单元索引
            if (_selectedSectionIndex != NoneSectionIndex && _selectedSectionIndex <= index) {
                ++ _selectedSectionIndex;
            }

            //添加元素
            [self.sections insertObject:section atIndex:index];
        }
            break;

        case CLSectionControlSectionRemove:

            //更新选择的单元索引
            if (_selectedSectionIndex != NoneSectionIndex) {

                if (_selectedSectionIndex == index) {
                    _selectedSectionIndex = NoneSectionIndex;
                }else if (_selectedSectionIndex > index){
                    -- _selectedSectionIndex;
                }
            }

            [self.sections removeObjectAtIndex:index];

            break;

        case CLSectionControlSectionUpdate:
        {
            _CLSectionControlSection * section = self.sections[index];

            section.title = title;
            [section setImage:image forState:CLSectionControlSectionStateNormal];
            [section setImage:highlightedImage forState:CLSectionControlSectionStateHighlighted];
            [section setImage:selectedImage forState:CLSectionControlSectionStateSelected];
            [section setImage:disabledImage forState:CLSectionControlSectionStateDisabled];
        }

            break;

        case CLSectionControlSectionExpand:
        {
            _CLSectionControlSection * section = self.sections[index];

            if (title) {
                section.title = title;
            }
            if (image) {
                [section setImage:image forState:CLSectionControlSectionStateNormal];
            }
            if (highlightedImage) {
                [section setImage:highlightedImage forState:CLSectionControlSectionStateHighlighted];
            }
            if (selectedImage) {
                [section setImage:selectedImage forState:CLSectionControlSectionStateSelected];
            }
            if (disabledImage) {
                [section setImage:disabledImage forState:CLSectionControlSectionStateDisabled];
            }
        }
    }

    [self _invalidateContent];
}

- (void)removeAllSections
{
    if (self.sectionCount) {

        //touch无效
        [self _invalidateCurrentTouch];

        _selectedSectionIndex = NoneSectionIndex;

        [self.sections removeAllObjects];

        [self _invalidateContent];
    }
}

- (NSString *)sectionTitleAtIndex:(NSUInteger)index
{
    checkIndexAtRange(index, NSMakeRange(0, self.sectionCount));

    _CLSectionControlSection * section = self.sections[index];
    return section.title;
}

- (UIImage *)sectionImageAtIndex:(NSUInteger)index
                        forState:(CLSectionControlSectionState)state
{
    checkIndexAtRange(index, NSMakeRange(0, self.sectionCount));

    _CLSectionControlSection * section = self.sections[index];
    return [section imageForState:state];
}

- (UIImage *)sectionShowingImageAtIndex:(NSUInteger)index
                               forState:(CLSectionControlSectionState)state
{
    UIImage * image = [self sectionImageAtIndex:index forState:state];
    if (!image && state != CLSectionControlSectionStateNormal) {
        image = [self sectionImageAtIndex:index forState:CLSectionControlSectionStateNormal];
        if (image && self.autoAdjustImage && !self.adjustImageWithTextColor && self.autoAdjustTextColor) {

            if (self.autoAdjustTextColor) {
                image = [image imageWithTintColor:[self showingTextColorForState:state]];
            }else {
                UIColor * textColor = [self textColorForState:state];
                if (textColor) {
                    image = [image imageWithTintColor:textColor];
                }
            }
        }
    }

    return image && self.adjustImageWithTextColor ? [image imageWithTintColor:[self showingTextColorForState:state]] : image;
}

#pragma mark -

- (UIFont *)textFont{
    return _textFont ?: [UIFont systemFontOfSize:17.f];
}

- (NSMutableDictionary *)textColors
{
    if (!_textColors) {
        _textColors = [NSMutableDictionary dictionaryWithCapacity:CLSectionControlSectionStateCount];
    }

    return _textColors;
}

- (void)setTextColor:(UIColor *)textColor forState:(CLSectionControlSectionState)state
{
    if (textColor) {
        [self.textColors setObject:textColor forKey:@(state)];
    }else if (_textColors){
        [_textColors removeObjectForKey:@(state)];
    }

    [self _updateViewIfNeedWhenPropertyChangeWithState:state];
}

- (UIColor *)textColorForState:(CLSectionControlSectionState)state{
    return _textColors ? _textColors[@(state)] : nil;
}

- (UIColor *)showingTextColorForState:(CLSectionControlSectionState)state
{
    UIColor * textColor = [self textColorForState:state];

    if (!textColor  && state != CLSectionControlSectionStateNormal) {

        if (self.autoAdjustTextColor) {

            switch (state) {

                case CLSectionControlSectionStateHighlighted:
                    textColor = [[self showingTextColorForState:CLSectionControlSectionStateSelected] colorWithAlphaComponent:0.5f];
                    break;

                case CLSectionControlSectionStateDisabled:
                    textColor = [[self textColorForState:CLSectionControlSectionStateNormal] colorWithAlphaComponent:0.5f];
                    break;

                default:
                    textColor = [self textColorForState:CLSectionControlSectionStateNormal];
                    break;
            }

        }else{
            textColor = [self textColorForState:CLSectionControlSectionStateNormal];
        }
    }

    return textColor ?: [UIColor blackColor];
}

- (void)setEnabled:(BOOL)enabled forSectionAtIndex:(NSUInteger)index
{
    checkIndexAtRange(index, NSMakeRange(0, self.sectionCount));

    _CLSectionControlSection * section = self.sections[index];

    if (section.enabled != enabled) {
        section.enabled = enabled;

        if (!enabled) {

            if (_highlightedSectionIndex == index) {
                [self _invalidateCurrentTouch];
            }else if (_selectedSectionIndex == index){
                _selectedSectionIndex = NoneSectionIndex;
            }
        }

        [self _invalidateSectionState];
    }
}

- (BOOL)isEnabledForSectionAtIndex:(NSUInteger)index
{
    checkIndexAtRange(index, NSMakeRange(0, self.sectionCount));

    _CLSectionControlSection * section = self.sections[index];

    return section.enabled;
}

- (NSMutableDictionary *)sectionBackgroundColors
{
    if (!_sectionBackgroundColors) {
        _sectionBackgroundColors = [NSMutableDictionary dictionaryWithCapacity:CLSectionControlSectionStateCount];
    }

    return _sectionBackgroundColors;
}

- (void)setSectionBackgroundColor:(UIColor *)backgroundColor
                         forState:(CLSectionControlSectionState)state
{
    if (backgroundColor) {
        [self.sectionBackgroundColors setObject:backgroundColor forKey:@(state)];
    }else if (_sectionBackgroundColors){
        [_sectionBackgroundColors removeObjectForKey:@(state)];
    }

    //更新视图
    [self _updateViewIfNeedWhenPropertyChangeWithState:state];
}

- (UIColor *)sectionBackgroundColorForState:(CLSectionControlSectionState)state {
    return _sectionBackgroundColors ? _sectionBackgroundColors[@(state)] : nil;
}

- (UIColor *)sectionShowingBackgroundColorForState:(CLSectionControlSectionState)state
{
    UIColor * sectionBackgroundColor = [self sectionBackgroundColorForState:state];

    if (!sectionBackgroundColor && state != CLSectionControlSectionStateNormal) {

        if (self.autoAdjustBackgroundColor) {

            switch (state) {
                case CLSectionControlSectionStateHighlighted:
                    sectionBackgroundColor = [[self sectionShowingBackgroundColorForState:CLSectionControlSectionStateSelected] colorWithAlphaComponent:0.5f];
                    break;

                case CLSectionControlSectionStateDisabled:
                    sectionBackgroundColor = [[self sectionBackgroundColorForState:CLSectionControlSectionStateNormal] colorWithAlphaComponent:0.5f];
                    break;

                default:
                    sectionBackgroundColor = [self sectionBackgroundColorForState:CLSectionControlSectionStateNormal];
                    break;
            }

        }else{
            sectionBackgroundColor = [self sectionBackgroundColorForState:CLSectionControlSectionStateNormal];
        }
    }

    return sectionBackgroundColor;
}

- (void)_updateViewIfNeedWhenPropertyChangeWithState:(CLSectionControlSectionState)state
{
    BOOL needUpdateView = NO;

    switch (state) {
        case CLSectionControlSectionStateHighlighted:
            needUpdateView = _highlightedSectionIndex != NoneSectionIndex;
            break;

        case CLSectionControlSectionStateSelected:
            needUpdateView = _selectedSectionIndex != NoneSectionIndex;
            break;

        case CLSectionControlSectionStateDisabled:
            for (_CLSectionControlSection * section in self.sections) {
                needUpdateView = !section.enabled;
                if (needUpdateView) break;
            }
            break;

        default:
            needUpdateView = YES;
            break;
    }

    if (needUpdateView) {
        [self setNeedsDisplay];
    }
}

- (CLSectionControlSectionState)sectionStateAtIndex:(NSUInteger)index
{
    if ([self isEnabledForSectionAtIndex:index]) {

        if (index == _selectedSectionIndex){
            return CLSectionControlSectionStateSelected;
        }else if (index == _highlightedSectionIndex) {
            return CLSectionControlSectionStateHighlighted;
        }else{
            return CLSectionControlSectionStateNormal;
        }
    }

    return CLSectionControlSectionStateDisabled;
}

#pragma mark - selectedIndicatorLine && separatorLine && border

- (UIColor *)borderColor {
    return _borderColor ?: [UIColor blackColor];
}
- (CGFloat)borderWidth {
    return fabs(_borderWidth);
}

- (UIColor *)separatorLineColor {
    return _separatorLineColor ?: [UIColor blackColor];
}

- (UIColor *)selectedIndicatorLineColor {
    return _selectedIndicatorLineColor ?: self.tintColor;
}
- (void)setSelectedIndicatorLineColor:(UIColor *)selectedIndicatorLineColor
{
    _selectedIndicatorLineColor = selectedIndicatorLineColor;
    _selectedIndicatorLine.backgroundColor = self.selectedIndicatorLineColor.CGColor;
}
- (void)tintColorDidChange
{
    [super tintColorDidChange];

    if (!_selectedIndicatorLineColor && _selectedIndicatorLine) {
        _selectedIndicatorLine.backgroundColor = self.tintColor.CGColor;
    }
}

- (CALayer *)selectedIndicatorLine
{
    if (!_selectedIndicatorLine) {
        _selectedIndicatorLine = [CALayer layer];
        _selectedIndicatorLine.actions = @{@"backgroundColor":[NSNull null]};
        _selectedIndicatorLine.backgroundColor = self.selectedIndicatorLineColor.CGColor;
    }

    return _selectedIndicatorLine;
}

- (void)setShowSelectedIndicatorLine:(BOOL)showSelectedIndicatorLine
{
    if (_showSelectedIndicatorLine != showSelectedIndicatorLine) {
        _showSelectedIndicatorLine = showSelectedIndicatorLine;

        [_selectedIndicatorLine removeFromSuperlayer];

        if (_showSelectedIndicatorLine) {
            [self.layer addSublayer:self.selectedIndicatorLine];
            [self _invalidateSelectedIndicatorLine];
        }
    }
}

- (void)_updateSelectedIndicatorLineWithAnimated:(BOOL)animated
{
    if (self.showSelectedIndicatorLine) {

        CGRect selectedIndicatorLineFrame = CGRectZero;

        if (_selectedSectionIndex != NoneSectionIndex && self.selectedIndicatorLineWidth > 0.f) {

            CGRect selectedSectionRect = [self rectForSectionAtIndex:_selectedSectionIndex];

            CLSectionControlBorderMask borderMask;
            if (self.layoutDirection == CLSectionControlLayoutDirectionHorizontal) {
                borderMask = (self.selectedIndicatorLayout == CLSectionControlSelectedIndicatorLayoutBottom) ? CLSectionControlBorderBottom : CLSectionControlBorderTop;

                if (self.apportionsSelectedIndicatorLineByContent) {
                    CGRect selectedSectionContentRect = [self rectForSectionContentAtIndex:_selectedSectionIndex];
                    selectedSectionRect.origin.x = CGRectGetMinX(selectedSectionContentRect);
                    selectedSectionRect.size.width = CGRectGetWidth(selectedSectionContentRect);
                }

            }else {
                borderMask = (self.selectedIndicatorLayout == CLSectionControlSelectedIndicatorLayoutLeft) ? CLSectionControlBorderLeft : CLSectionControlBorderRight;

                if (self.apportionsSelectedIndicatorLineByContent) {
                    CGRect selectedSectionContentRect = [self rectForSectionContentAtIndex:_selectedSectionIndex];
                    selectedSectionRect.origin.y = CGRectGetMinY(selectedSectionContentRect);
                    selectedSectionRect.size.height = CGRectGetHeight(selectedSectionContentRect);
                }
            }


            selectedIndicatorLineFrame = [self _borderLineRectForRect:selectedSectionRect
                                                           borderMask:borderMask
                                                            lineWidth:self.selectedIndicatorLineWidth
                                                                inset:self.selectedIndicatorLineInset
                                                           insetScale:self.selectedIndicatorLineInsetScale
                                                         standardFunc:roundf];
            //
            //            if (self.apportionsSelectedIndicatorLineByContent) {
            //
            //                CGRect selectedSectionContentRect = [self rectForSectionContentAtIndex:_selectedSectionIndex];
            //                if (self.layoutDirection == CLSectionControlLayoutDirectionHorizontal) {
            //                    selectedIndicatorLineFrame.origin.x = CGRectGetMinX(selectedSectionContentRect);
            //                    selectedIndicatorLineFrame.size.width = CGRectGetWidth(selectedSectionContentRect);
            //                }else{
            //                    selectedIndicatorLineFrame.origin.y = CGRectGetMinY(selectedSectionContentRect);
            //                    selectedIndicatorLineFrame.size.height = CGRectGetHeight(selectedSectionContentRect);
            //                }
            //            }
        }

        [CATransaction begin];
        [CATransaction setDisableActions:!animated];

        if (animated) {
            [CATransaction setAnimationDuration:0.3f];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        }

        self.selectedIndicatorLine.frame = selectedIndicatorLineFrame;

        [CATransaction commit];
    }

}

- (void)_updateSelectedIndicatorLine{
    [self _updateSelectedIndicatorLineWithAnimated:NO];
}


#pragma mark - update

#define IMP_MUTATOR(mutator, ctype, member, selector) \
- (void)mutator (ctype)value \
{ \
member = value; \
if(selector){ \
[self performSelector:selector withObject:nil];\
}\
}

#define IMP_MUTATOR_JE(mutator, ctype, member, selector) \
- (void)mutator (ctype)value \
{ \
if(member != value){ \
member = value; \
if(selector){ \
[self performSelector:selector withObject:nil];\
}\
}\
}


//布局失效
#define IMP_MUTATOR_IC(mutator, ctype, member) \
IMP_MUTATOR(mutator, ctype, member, @selector(_invalidateContent))
#define IMP_MUTATOR_JE_IC(mutator, ctype, member) \
IMP_MUTATOR_JE(mutator, ctype, member, @selector(_invalidateContent))

//布局失效当布局block为空时
#define IMP_MUTATOR_IC_B(mutator, ctype, member) \
- (void)mutator (ctype)value \
{ \
member = value; \
if(!self.sectionContentLayoutBlock) { [self _invalidateContent]; } \
}

#define IMP_MUTATOR_JE_IC_B(mutator, ctype, member) \
- (void)mutator (ctype)value \
{ \
if(member != value) { \
member = value; \
if(!self.sectionContentLayoutBlock) { [self _invalidateContent]; } \
}\
}

//需要重新绘制
#define IMP_MUTATOR_ND(mutator, ctype, member) \
IMP_MUTATOR(mutator, ctype, member, @selector(setNeedsDisplay))
#define IMP_MUTATOR_JE_ND(mutator, ctype, member) \
IMP_MUTATOR_JE(mutator, ctype, member, @selector(setNeedsDisplay))

//选择线失效
#define IMP_MUTATOR_IS(mutator, ctype, member) \
IMP_MUTATOR(mutator, ctype, member, @selector(_invalidateSelectedIndicatorLine))
#define IMP_MUTATOR_JE_IS(mutator, ctype, member) \
IMP_MUTATOR_JE(mutator, ctype, member, @selector(_invalidateSelectedIndicatorLine))


//_invalidateContent
IMP_MUTATOR_JE_IC(setTextFont:, UIFont *, _textFont)
IMP_MUTATOR_JE_IC(setLayoutDirection:, CLSectionControlLayoutDirection, _layoutDirection)
IMP_MUTATOR_JE_IC(setSectionLayout:, CLSectionControlSectionLayout, _sectionLayout)
IMP_MUTATOR_JE_IC_B(setSectionContentLayout:, CLContentLayout, _sectionContentLayout)
IMP_MUTATOR_JE_IC_B(setSectionContentAlign:, CLSectionControlSectionContentAlign, _sectionContentAlign)
IMP_MUTATOR_JE_IC(setApportionsSectionSizeByContent:, BOOL, _apportionsSectionSizeByContent)
IMP_MUTATOR_JE_IC(setCalculateScetionSizeByState:, BOOL, _calculateScetionSizeByState)
IMP_MUTATOR_JE_IC(setTitleImageMargin:, CGFloat, _titleImageMargin)
IMP_MUTATOR_JE_IC(setMinSectionMargin:, CGFloat, _minSectionMargin)
IMP_MUTATOR_IC_B(setSectionContentOffset:, CGPoint, _sectionContentOffset)

//setNeedsDisplay
IMP_MUTATOR_JE_ND(setAutoAdjustTextColor:, BOOL, _autoAdjustTextColor)
IMP_MUTATOR_JE_ND(setAutoAdjustBackgroundColor:, BOOL, _autoAdjustBackgroundColor)
IMP_MUTATOR_JE_ND(setAdjustImageWithTextColor:, BOOL, _adjustImageWithTextColor)
IMP_MUTATOR_JE_ND(setAutoAdjustImage:, BOOL, _autoAdjustImage)
IMP_MUTATOR_JE_ND(setDrawGradientSeparatorLine:, BOOL, _drawGradientSeparatorLine)
IMP_MUTATOR_JE_ND(setSeparatorLineWidth:, CGFloat, _separatorLineWidth)
IMP_MUTATOR_JE_ND(setSeparatorLineColor:, UIColor *, _separatorLineColor)
IMP_MUTATOR_ND(setSeparatorLineInset:, UIEdgeInsets, _separatorLineInset)
IMP_MUTATOR_ND(setSeparatorLineInsetScale:, UIEdgeInsets, _separatorLineInsetScale)
IMP_MUTATOR_ND(setSeparatorLineOffset:, CGPoint, _separatorLineOffset)
IMP_MUTATOR_JE_ND(setBorderMask:, CLSectionControlBorderMask, _borderMask)
IMP_MUTATOR_JE_ND(setBorderColor:, UIColor *, _borderColor)
IMP_MUTATOR_JE_ND(setBorderWidth:, CGFloat, _borderWidth)
IMP_MUTATOR_ND(setBorderLineInset:, UIEdgeInsets, _borderLineInset)
IMP_MUTATOR_ND(setBorderLineInsetScale:, UIEdgeInsets, _borderLineInsetScale)
IMP_MUTATOR_ND(setSectionBackgroundColorInset:, UIEdgeInsets, _sectionBackgroundColorInset)

//_invalidateSelectedIndicatorLine
IMP_MUTATOR_JE_IS(setSelectedIndicatorLayout:, CLSectionControlSelectedIndicatorLayout, _selectedIndicatorLayout)
IMP_MUTATOR_JE_IS(setSelectedIndicatorLineWidth:, CGFloat, _selectedIndicatorLineWidth)
IMP_MUTATOR_JE_IS(setApportionsSelectedIndicatorLineByContent:, BOOL, _apportionsSelectedIndicatorLineByContent)
IMP_MUTATOR_IS(setSelectedIndicatorLineInset:, UIEdgeInsets, _selectedIndicatorLineInset)
IMP_MUTATOR_IS(setSelectedIndicatorLineInsetScale:, UIEdgeInsets, _selectedIndicatorLineInsetScale)

//invalidateIntrinsicContentSize
IMP_MUTATOR(setIntrinsicSectionExpansionScale:, CGSize, _intrinsicSectionExpansionScale, @selector(invalidateIntrinsicContentSize))
IMP_MUTATOR(setIntrinsicSectionExpansionLength:, CGSize, _intrinsicSectionExpansionLength, @selector(invalidateIntrinsicContentSize))

- (void)setGetSectionSizeBlock:(CGSize (^)(NSUInteger, CGSize, CGPoint, CGSize))getSectionSizeBlock
{
    if (_getSectionSizeBlock != getSectionSizeBlock) {

        //赋值给成员变量时会自动拷贝到堆上，不需要显示调用copy
        _getSectionSizeBlock = getSectionSizeBlock;
        [self _invalidateContent];
    }
}

//layoutblock
- (void)setSectionContentLayoutBlock:(void (^)(NSUInteger, CGRect, CGSize, CGSize, CGSize, CGRect *, CGRect *, CGRect *))sectionContentLayoutBlock
{
    if (_sectionContentLayoutBlock != sectionContentLayoutBlock) {

        //赋值给成员变量时会自动拷贝到堆上，不需要显示调用copy
        _sectionContentLayoutBlock = sectionContentLayoutBlock;
        [self _invalidateContent];
    }
}


- (void)_invalidateContent
{
    if (!self.isInvalidateContent) {
        self.isInvalidateContent = YES;
        [self setNeedsDisplay];
    }

    [self invalidateIntrinsicContentSize];
}

- (void)_invalidateSectionState
{
    if (self.calculateScetionSizeByState) {
        [self _invalidateContent];
    }else{
        [self setNeedsDisplay];
    }
}

- (void)_invalidateSelectedIndicatorLine
{
    if (!self.isInvalidateContent) {
        [self _updateSelectedIndicatorLine];
    }
}

#pragma mark - section size

//是否是水平布局section
#define IsHorizontalLayoutSection() \
(self.sectionLayout == CLSectionControlSectionLayoutImageLeft || \
self.sectionLayout == CLSectionControlSectionLayoutImageRight)


//更新
- (void)_updateSectionSize
{
    if(!self.isInvalidateContent){
        return;
    }

    self.isInvalidateContent = NO;

    NSUInteger sectionCount  = self.sectionCount;
    if (sectionCount) {

        CGRect bounds = self.bounds;
        CGSize sectionSize = CGSizeZero;
        CGSize sectionSizeInset = CGSizeMake(1.f, 1.f);

        if (self.apportionsSectionSizeByContent) {

            CGSize allSectionDrawSize = [self _allSectionDrawSize:self.calculateScetionSizeByState];
            if (self.layoutDirection == CLSectionControlLayoutDirectionHorizontal) {
                sectionSizeInset.width = CGRectGetWidth(bounds) / allSectionDrawSize.width;
            }else{
                sectionSizeInset.height = CGRectGetHeight(bounds) / allSectionDrawSize.height;
            }
        }else{

            if (self.layoutDirection == CLSectionControlLayoutDirectionHorizontal) {
                sectionSize.width  = CGRectGetWidth(bounds) / sectionCount;
                sectionSize.height = CGRectGetHeight(bounds);
            }else{
                sectionSize.height = CGRectGetHeight(bounds) / sectionCount;
                sectionSize.width  = CGRectGetWidth(bounds);
            }
        }

        //偏移
        CGPoint sectionOffset = CGPointMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds));

        for (NSUInteger index = 0; index < sectionCount;  ++ index) {

            CLSectionControlSectionState state = self.calculateScetionSizeByState ? [self sectionStateAtIndex:index] : CLSectionControlSectionStateNormal;

            CGRect sectionRect        = CGRectZero;
            CGRect sectionContentRect = CGRectZero;
            CGRect titleRect          = CGRectZero;
            CGRect imageRect          = CGRectZero;

            //计算section的大小
            if (self.getSectionSizeBlock) {

                //自定义计算
                sectionSize = self.getSectionSizeBlock(index,
                                                       [self _sectionDrawSizeAtIndex:index forState:state],
                                                       sectionOffset,
                                                       bounds.size);

            }else if (self.apportionsSectionSizeByContent) {

                //计算大小
                sectionSize = [self _sectionDrawSizeAtIndex:index forState:state];
                if (self.layoutDirection == CLSectionControlLayoutDirectionHorizontal) {
                    sectionSize.width  *= sectionSizeInset.width;
                    sectionSize.height = CGRectGetHeight(bounds);
                }else{
                    sectionSize.height *= sectionSizeInset.height;
                    sectionSize.width  = CGRectGetWidth(bounds);
                }
            }

            sectionRect = CGRectMake(sectionOffset.x, sectionOffset.y, sectionSize.width, sectionSize.height);
            sectionContentRect.size = sectionSize;

            //更新偏移和内容大小
            if (self.layoutDirection == CLSectionControlLayoutDirectionHorizontal) {
                sectionOffset.x += sectionSize.width;
                sectionContentRect.size.width -= self.minSectionMargin;
            }else{
                sectionOffset.y += sectionSize.height;
                sectionContentRect.size.height -= self.minSectionMargin;
            }

            if(CGRectGetWidth(sectionContentRect) > 0 && CGRectGetHeight(sectionContentRect) > 0){

                //计算大小
                CGSize titleDrawSize = [self _sectionTitleDrawSizeAtIndex:index];
                CGSize imageDrawSize = [self _sectionImageDrawSizeAtIndex:index forState:state];

                //水平布局
                if (IsHorizontalLayoutSection()) {

                    //计算内容大小
                    BOOL hasMargin = (titleDrawSize.width && imageDrawSize.width);

                    CGSize imageMaxSize = CGSizeZero;
                    imageMaxSize.width = CGRectGetWidth(sectionContentRect) - (hasMargin? self.titleImageMargin : 0.f);
                    imageMaxSize.width = MAX(0.f, imageMaxSize.width);
                    imageMaxSize.height = CGRectGetHeight(sectionContentRect);

                    //缩小图片到合适大小
                    CGSize targetSize = sizeZoomToTagetSize(imageDrawSize, imageMaxSize, CLZoomModeAspectFit);
                    if (targetSize.width < imageDrawSize.width) {
                        imageDrawSize = targetSize;
                    }

                    //显示不下则缩小
                    if (imageMaxSize.width < imageDrawSize.width + titleDrawSize.width){
                        titleDrawSize.width = imageMaxSize.width - imageDrawSize.width;
                    }

                    sectionContentRect.size.width = titleDrawSize.width + imageDrawSize.width + (hasMargin ? self.titleImageMargin : 0.f);
                    sectionContentRect.size.height = MAX(titleDrawSize.height, imageDrawSize.height);

                }else{ //竖直布局

                    //计算内容大小
                    BOOL hasMargin = (titleDrawSize.height && imageDrawSize.height);

                    CGSize imageMaxSize = CGSizeZero;
                    imageMaxSize.height = CGRectGetHeight(sectionContentRect) - (hasMargin? self.titleImageMargin : 0.f);
                    imageMaxSize.height = MAX(0.f, imageMaxSize.height);
                    imageMaxSize.width = CGRectGetWidth(sectionContentRect);

                    //缩小图片到合适大小
                    CGSize targetSize = sizeZoomToTagetSize(imageDrawSize, imageMaxSize, CLZoomModeAspectFit);
                    if (targetSize.height < imageDrawSize.height) {
                        imageDrawSize = targetSize;
                    }

                    if (imageMaxSize.height < imageDrawSize.height + titleDrawSize.height){
                        titleDrawSize.height = imageMaxSize.height - imageDrawSize.height;
                    }

                    sectionContentRect.size.height = titleDrawSize.height + imageDrawSize.height + (hasMargin ? self.titleImageMargin : 0.f);
                    sectionContentRect.size.width = MAX(titleDrawSize.width, imageDrawSize.width);
                }

                if (self.sectionContentLayoutBlock) {

                    //自定义计算布局
                    self.sectionContentLayoutBlock(index,
                                                   sectionRect,
                                                   sectionContentRect.size,
                                                   imageDrawSize,
                                                   titleDrawSize,
                                                   &sectionContentRect,
                                                   &imageRect,
                                                   &titleRect);

                }else {

                    //使用布局信息计算

                    CLContentLayout imageLayout,titleLayout;

                    if (IsHorizontalLayoutSection()) {

                        //计算布局
                        if (self.sectionContentAlign == CLSectionControlSectionContentAlignTop) {
                            imageLayout = CLContentLayoutTop;
                        }else if (self.sectionContentAlign == CLSectionControlSectionContentAlignBottom){
                            imageLayout = CLContentLayoutBottom;
                        }else{
                            imageLayout = CLContentLayoutCenter;
                        }

                        titleLayout = imageLayout;

                        //图左文右
                        if (self.sectionLayout == CLSectionControlSectionLayoutImageLeft) {
                            imageLayout |= CLContentLayoutLeft;
                            titleLayout |= CLContentLayoutRight;
                        }else{ //文左图右
                            imageLayout |= CLContentLayoutRight;
                            titleLayout |= CLContentLayoutLeft;
                        }

                    }else {

                        //计算布局
                        if (self.sectionContentAlign == CLSectionControlSectionContentAlignLeft) {
                            imageLayout = CLContentLayoutLeft;
                        }else if (self.sectionContentAlign == CLSectionControlSectionContentAlignRight){
                            imageLayout = CLContentLayoutRight;
                        }else{
                            imageLayout = CLContentLayoutCenter;
                        }

                        titleLayout = imageLayout;

                        //图上文下
                        if (self.sectionLayout == CLSectionControlSectionLayoutImageTop) {
                            imageLayout |= CLContentLayoutTop;
                            titleLayout |= CLContentLayoutBottom;
                        }else{ //文上图下
                            imageLayout |= CLContentLayoutBottom;
                            titleLayout |= CLContentLayoutLeft;
                        }

                    }

                    //计算内容视图的rect
                    sectionContentRect = contentRectForLayout(sectionRect, sectionContentRect.size, self.sectionContentLayout);
                    //偏移
                    sectionContentRect = CGRectOffset(sectionContentRect, self.sectionContentOffset.x, self.sectionContentOffset.y);

                    //计算文字和图片位置
                    titleRect = contentRectForLayout(sectionContentRect, titleDrawSize, titleLayout);
                    imageRect = contentRectForLayout(sectionContentRect, imageDrawSize, imageLayout);
                }

            }else{
                sectionContentRect = CGRectZero;
            }

            //更新数据
            _CLSectionControlSection * section = self.sections[index];
            section.sectionRect = sectionRect;
            section.sectionContentRect = sectionContentRect;
            section.sectionTitleRect = titleRect;
            section.sectionImageRect = imageRect;
        }
    }

    //更新选择指示线
    [self _updateSelectedIndicatorLine];

    //更新badge视图
    [self _updateBadgeViews];

}

- (CGSize)_sectionTitleDrawSizeAtIndex:(NSUInteger)index {
    return  TEXTSIZE([self sectionTitleAtIndex:index], self.textFont);
}

- (CGSize)_sectionImageDrawSizeAtIndex:(NSUInteger)index
                              forState:(CLSectionControlSectionState)state
{
    UIImage * image = [self sectionShowingImageAtIndex:index forState:state];
    return image ? image.size : CGSizeZero;
}

- (CGSize)_sectionDrawSizeAtIndex:(NSUInteger)index
                         forState:(CLSectionControlSectionState)state
{
    CGSize titleSize = [self _sectionTitleDrawSizeAtIndex:index];
    CGSize imageSize = [self _sectionImageDrawSizeAtIndex:index forState:state];

    CGSize sectionDrawSize = CGSizeZero;

    if (IsHorizontalLayoutSection()) {
        sectionDrawSize.height = MAX(titleSize.height, imageSize.height);
        sectionDrawSize.width  = ((titleSize.width && imageSize.width) ? self.titleImageMargin : 0.f) + titleSize.width + imageSize.width + self.minSectionMargin;
    }else{
        sectionDrawSize.width  = MAX(titleSize.width, imageSize.width);
        sectionDrawSize.height = ((titleSize.height && imageSize.height) ? self.titleImageMargin : 0.f) + titleSize.height + imageSize.height + self.minSectionMargin;
    }

    return sectionDrawSize;
}

- (CGSize)_allSectionDrawSize:(BOOL)calculateScetionSizeByState
{
    CGSize allSectionDrawSize = CGSizeZero;

    NSUInteger sectionCount = self.sectionCount;
    if (sectionCount) {

        for (NSUInteger index = 0; index < sectionCount; ++ index) {

            CGSize sectionSize = [self _sectionDrawSizeAtIndex:index
                                                      forState:calculateScetionSizeByState ? [self sectionStateAtIndex:index]: CLSectionControlSectionStateNormal];

            if (self.apportionsSectionSizeByContent) {
                if (self.layoutDirection == CLSectionControlLayoutDirectionHorizontal) {
                    allSectionDrawSize.height = MAX(allSectionDrawSize.height, sectionSize.height);
                    allSectionDrawSize.width += sectionSize.width;
                }else{
                    allSectionDrawSize.width = MAX(allSectionDrawSize.width, sectionSize.width);
                    allSectionDrawSize.height += sectionSize.height;
                }
            }else{
                allSectionDrawSize.width = MAX(allSectionDrawSize.width, sectionSize.width);
                allSectionDrawSize.height = MAX(allSectionDrawSize.height, sectionSize.height);
            }
        }

        if (!self.apportionsSectionSizeByContent) {
            if (self.layoutDirection == CLSectionControlLayoutDirectionHorizontal) {
                allSectionDrawSize.width *= sectionCount;
            }else{
                allSectionDrawSize.height *= sectionCount;
            }
        }
    }

    return allSectionDrawSize;
}

- (_CLSectionControlSection *)_sectionForRectAtIndex:(NSUInteger)index
{
    checkIndexAtRange(index, NSMakeRange(0, self.sectionCount));
    [self _updateSectionSize];

    return  self.sections[index];
}
- (CGRect)rectForSectionAtIndex:(NSUInteger)index {
    return [self _sectionForRectAtIndex:index].sectionRect;
}

- (CGRect)rectForSectionContentAtIndex:(NSUInteger)index {
    return [self _sectionForRectAtIndex:index].sectionContentRect;
}

- (CGRect)rectForSectionImageAtIndex:(NSUInteger)index {
    return [self _sectionForRectAtIndex:index].sectionImageRect;
}

- (CGRect)rectForSectionTitleAtIndex:(NSUInteger)index {
    return [self _sectionForRectAtIndex:index].sectionTitleRect;
}

- (NSUInteger)sectionIndexForPoint:(CGPoint)point
{
    NSUInteger sectionIndex = NoneSectionIndex;
    NSUInteger sectionCount = self.sectionCount;

    if (sectionCount && CGRectContainsPoint(self.bounds, point)) {

        if (self.apportionsSectionSizeByContent) {

            for (NSInteger index = 0 ; index < sectionCount; ++ index) {
                if (CGRectContainsPoint([self rectForSectionAtIndex:index],point)) {
                    sectionIndex = index;
                    break;
                }
            }

        }else{ //等宽情况下的直接计算

            if (self.layoutDirection == CLSectionControlLayoutDirectionHorizontal) {
                sectionIndex = floorf((point.x - CGRectGetMinX(self.bounds)) / CGRectGetWidth(self.bounds) * sectionCount);
            }else{
                sectionIndex = floorf((point.y - CGRectGetMinY(self.bounds)) / CGRectGetHeight(self.bounds) * sectionCount);
            }
        }
    }

    return sectionIndex;
}


#pragma mark - intrinsic content size

- (CGSize)sizeThatFits:(CGSize)size {
    return [self intrinsicContentSize];
}

- (CGSize)intrinsicContentSize
{
    CGSize intrinsicContentSize = CGSizeZero;
    NSUInteger sectionCount = self.sectionCount;

    if (sectionCount) {

        intrinsicContentSize = [self _allSectionDrawSize:self.calculateScetionSizeByState];

        intrinsicContentSize.width  *= (1.f + self.intrinsicSectionExpansionScale.width);
        intrinsicContentSize.height *= (1.f + self.intrinsicSectionExpansionScale.height);

        if (self.layoutDirection == CLSectionControlLayoutDirectionHorizontal) {
            intrinsicContentSize.width += (self.intrinsicSectionExpansionLength.width * sectionCount);
            intrinsicContentSize.height += self.intrinsicSectionExpansionLength.height;
        }else{
            intrinsicContentSize.height += (self.intrinsicSectionExpansionLength.height * sectionCount);
            intrinsicContentSize.width += self.intrinsicSectionExpansionLength.width;
        }

        intrinsicContentSize.width = ceilf(intrinsicContentSize.width);
        intrinsicContentSize.height = ceilf(intrinsicContentSize.height);
    }

    return intrinsicContentSize;
}


#pragma mark - draw

- (void)drawRect:(CGRect)rect
{
    //更新大小
    [self _updateSectionSize];

    NSUInteger sectionCount  = self.sectionCount;
    for (NSUInteger index = 0; index < sectionCount;  ++ index) {

        _CLSectionControlSection * section = self.sections[index];
        CLSectionControlSectionState state = [self sectionStateAtIndex:index];

        //绘制背景
        CGRect backgroundColorRect = UIEdgeInsetsInsetRect(section.sectionRect, self.sectionBackgroundColorInset);
        if (CGRectGetWidth(backgroundColorRect) > 0 &&
            CGRectGetHeight(backgroundColorRect) > 0) {
            [self _drawSectionBackgroundColorInRect:backgroundColorRect
                                           forState:state];
        }

        //绘制图片
        [self _drawSectionImageAtIndex:index
                                inRect:section.sectionImageRect
                              forState:state];
        //绘制文字
        [self _drawSectionTitleAtIndex:index
                                inRect:section.sectionTitleRect
                              forState:state];

        //绘制分割线
        if (self.separatorLineWidth > 0 && index != 0) {

            CGRect separatorLineRect = [self _borderLineRectForRect:CGRectOffset(section.sectionRect, - self.separatorLineWidth * 0.5f, - self.separatorLineWidth * 0.5f)
                                                         borderMask:(self.layoutDirection == CLSectionControlLayoutDirectionHorizontal) ?CLSectionControlBorderLeft : CLSectionControlBorderTop
                                                          lineWidth:self.separatorLineWidth
                                                              inset:self.separatorLineInset
                                                         insetScale:self.separatorLineInsetScale
                                                       standardFunc:roundf];

            if (CGRectGetWidth(separatorLineRect) > 0 &&
                CGRectGetHeight(separatorLineRect) > 0) {
                [self _drawSeparatorLineInRect:CGRectOffset(separatorLineRect, self.separatorLineOffset.x, self.separatorLineOffset.y)];
            }
        }
    }

    //绘制边框
    if (self.borderWidth != 0 && self.borderMask != CLSectionControlBorderNone) {

        CLSectionControlBorderMask mask[4] = {CLSectionControlBorderTop,
            CLSectionControlBorderBottom,
            CLSectionControlBorderLeft,
            CLSectionControlBorderRight};

        for (int i = 0; i < 4; ++ i) {

            if (self.borderMask & mask[i]) {

                float (*func)(float) = (mask[i] == CLSectionControlBorderTop || mask[i] == CLSectionControlBorderLeft) ? ceilf : roundf;

                CGRect borderLineRect = [self _borderLineRectForRect:rect
                                                          borderMask:mask[i]
                                                           lineWidth:self.borderWidth
                                                               inset:self.borderLineInset
                                                          insetScale:self.borderLineInsetScale
                                                        standardFunc:func];

                [self _drawLineInRect:borderLineRect
                                color:self.borderColor
                           isGradient:NO
                      layoutDirection:(mask[i] == CLSectionControlBorderTop || mask[i] == CLSectionControlBorderBottom) ? CLSectionControlLayoutDirectionHorizontal : CLSectionControlLayoutDirectionVertical];
            }
        }

    }
}


- (CGRect)_borderLineRectForRect:(CGRect)rect
                      borderMask:(CLSectionControlBorderMask)borderMask
                       lineWidth:(CGFloat)lineWidth
                           inset:(UIEdgeInsets)inset
                      insetScale:(UIEdgeInsets)insetScale
                    standardFunc:(float (*)(float))func
{

    CGRect lineRect = CGRectZero;

    CGFloat onePiexlLenght = PixelToPoint(1.f);

    if (borderMask == CLSectionControlBorderTop ||
        borderMask == CLSectionControlBorderBottom) {

        lineRect.origin.x = CGRectGetMinX(rect) + CGRectGetWidth(rect) * insetScale.left + inset.left;
        lineRect.size.width = CGRectGetWidth(rect) * (1 - insetScale.left - insetScale.right) - inset.left - inset.right;
        lineRect.size.height = lineWidth;

        if (CGRectGetWidth(lineRect) > 0) {

            if (borderMask == CLSectionControlBorderTop) {

                lineRect.origin.y = CGRectGetMinY(rect);
                lineRect.origin.y = func(lineRect.origin.y / onePiexlLenght) * onePiexlLenght;
            }else{
                lineRect.origin.y = CGRectGetMaxY(rect) - lineWidth;
                lineRect.origin.y = func(lineRect.origin.y / onePiexlLenght) * onePiexlLenght;
            }
        }else{
            lineRect = CGRectZero;
        }
    }else if(borderMask == CLSectionControlBorderLeft ||
             borderMask == CLSectionControlBorderRight){

        lineRect.origin.y = CGRectGetMinY(rect) + CGRectGetHeight(rect) * insetScale.top + inset.top;
        lineRect.size.height = CGRectGetHeight(rect) * (1 - insetScale.top - insetScale.bottom) - inset.top - inset.bottom;
        lineRect.size.width = lineWidth;

        if (CGRectGetHeight(lineRect) > 0) {

            if (borderMask == CLSectionControlBorderLeft) {
                lineRect.origin.x = CGRectGetMinX(rect);
                lineRect.origin.x = func(lineRect.origin.x / onePiexlLenght) * onePiexlLenght;
            }else{
                lineRect.origin.x = CGRectGetMaxX(rect) - self.borderWidth;
                lineRect.origin.x = func(lineRect.origin.x / onePiexlLenght) * onePiexlLenght;
            }
        }else{
            lineRect = CGRectZero;
        }
    }

    return lineRect;
}

- (void)_drawSectionBackgroundColorInRect:(CGRect)rect
                                 forState:(CLSectionControlSectionState)state
{
    UIColor * bgColor = [self sectionShowingBackgroundColorForState:state];

    if (bgColor != nil) {

        //保存状态
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        CGContextSaveGState(currentContext);

        [bgColor setFill];
        CGContextFillRect(currentContext, rect);

        //恢复
        CGContextRestoreGState(currentContext);
    }
}

- (void)_drawSectionTitleAtIndex:(NSUInteger)index
                          inRect:(CGRect)rect
                        forState:(CLSectionControlSectionState)state

{
    NSString * title = [self sectionTitleAtIndex:index];

    if (title.length > 0) {

        UIColor * textColor = [self showingTextColorForState:state];

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0

        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;

        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithString:title
                                                                       attributes:@{
                                                                                    NSFontAttributeName : self.textFont,
                                                                                    NSForegroundColorAttributeName : textColor,
                                                                                    NSParagraphStyleAttributeName  : paragraphStyle}];

        [attrStr drawInRect:rect];
#else

        [textColor setStroke];
        [title drawInRect:rect
                 withFont:self.textFont
            lineBreakMode:NSLineBreakByTruncatingTail
                alignment:NSTextAlignmentCenter];

#endif

    }
}

- (void)_drawSectionImageAtIndex:(NSUInteger)index
                          inRect:(CGRect)rect
                        forState:(CLSectionControlSectionState)state
{
    [[self sectionShowingImageAtIndex:index forState:state] drawInRect:rect];
}

- (void)_drawLineInRect:(CGRect)rect
                  color:(UIColor *)lineColor
             isGradient:(BOOL)isGradient
        layoutDirection:(CLSectionControlLayoutDirection)layoutDirection
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 保持住现在的context
    CGContextSaveGState(context);

    if (isGradient) {

        CGContextClipToRect(context, rect);// 截取对应的context

        CGColorRef startColor  = [lineColor colorWithAlphaComponent:0.01f].CGColor;
        NSArray * cgColorArray = @[
                                   (__bridge id)startColor,
                                   (__bridge id)lineColor.CGColor,
                                   (__bridge id)startColor
                                   ];

        //绘制渐变线
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(rgb, (__bridge CFArrayRef)cgColorArray,NULL);
        CGColorSpaceRelease(rgb);

        CGPoint startPoint,endPoint;

        if (layoutDirection == CLSectionControlLayoutDirectionVertical) {
            startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
            endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        }else{
            startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
            endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
        }

        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);

        CGGradientRelease(gradient);
        CGContextFillPath(context);

    }else{
        //绘制线
        [lineColor setFill];
        CGContextFillRect(context, rect);
    }

    // 恢复到之前的context
    CGContextRestoreGState(context);
}


- (void)_drawSeparatorLineInRect:(CGRect)rect
{
    [self _drawLineInRect:rect
                    color:self.separatorLineColor
               isGradient:self.drawGradientSeparatorLine
          layoutDirection:self.layoutDirection == CLSectionControlLayoutDirectionHorizontal ? CLSectionControlLayoutDirectionVertical : CLSectionControlLayoutDirectionHorizontal];
}

#pragma mark - Selected Index

- (void)setMomentary:(BOOL)momentary
{
    if (_momentary != momentary) {
        _momentary = momentary;

        if (_momentary && _selectedSectionIndex != NoneSectionIndex) {
            _selectedSectionIndex = NoneSectionIndex;
            [self _invalidateSectionState];
        }
    }
}

- (NSUInteger)selectedSectionIndex {
    return self.isMomentary ? _highlightedSectionIndex : _selectedSectionIndex;
}

- (void)setSelectedSectionIndex:(NSUInteger)selectedSectionIndex {
    [self setSelectedSectionIndex:selectedSectionIndex animated:NO];
}

- (void)setSelectedSectionIndex:(NSUInteger)selectedSectionIndex animated:(BOOL)animated
{
    if (!self.isMomentary) {

        if (selectedSectionIndex != NoneSectionIndex) { //检验范围
            checkIndexAtRange(selectedSectionIndex, NSMakeRange(0, self.sectionCount));
        }

        [self _setSelectedSectionIndex:selectedSectionIndex animated:animated notify:NO];
    }
}

- (void)_setSelectedSectionIndex:(NSUInteger)selectedSectionIndex animated:(BOOL)animated notify:(BOOL)notify
{
    if (_selectedSectionIndex != selectedSectionIndex) {

        animated = animated && (_selectedSectionIndex != NoneSectionIndex);

        _selectedSectionIndex = selectedSectionIndex;

        if (animated && self.showSelectedIndicatorLine) {

            if (self.calculateScetionSizeByState) {
                self.isInvalidateContent = YES;
                [self _updateSectionSize];
            }

            [self _updateSelectedIndicatorLineWithAnimated:YES];
            [self setNeedsDisplay];

        }else{
            [self _invalidateSectionState];
            [self _invalidateSelectedIndicatorLine];
        }

        if (notify) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

- (void)cancleSelected {
    self.selectedSectionIndex = NoneSectionIndex;
}

#pragma mark - Touch

- (void)_invalidateCurrentTouch
{
    if (_highlightedSectionIndex != NoneSectionIndex) {
        _highlightedSectionIndex = NoneSectionIndex;

        [self _invalidateSectionState];
    }
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];

    if (!enabled) {
        [self _invalidateCurrentTouch];
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSUInteger sectionIndex = [self sectionIndexForPoint:[touch locationInView:self]];

    if (NoneSectionIndex != sectionIndex &&
        [self isEnabledForSectionAtIndex:sectionIndex] &&
        (self.isAllowDeselected || sectionIndex != _selectedSectionIndex)) {

        _highlightedSectionIndex = sectionIndex;
        [self _invalidateSectionState];

        return YES;
    }

    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (_highlightedSectionIndex != NoneSectionIndex) {

        CGRect highlightedSectionRect = [self rectForSectionAtIndex:_highlightedSectionIndex];

        if (CGRectContainsPoint(highlightedSectionRect, [touch locationInView:self])) {
            return YES;
        }else{
            [self _invalidateCurrentTouch];
        }
    }

    return NO;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (_highlightedSectionIndex != NoneSectionIndex) {

        if (!self.isMomentary) {
            [self _setSelectedSectionIndex:(_highlightedSectionIndex == _selectedSectionIndex) ? NoneSectionIndex : _highlightedSectionIndex animated:YES notify:YES];
        }else{
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            [self _invalidateSectionState];
        }

        _highlightedSectionIndex = NoneSectionIndex;
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event{
    [self _invalidateCurrentTouch];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {

        if (self.sectionCount && (_selectedSectionIndex == NoneSectionIndex || self.isAllowDeselected ||  _selectedSectionIndex != [self sectionIndexForPoint:[gestureRecognizer locationInView:self]])) {
            return NO;
        }
    }
    return YES;
}

#pragma mark -

- (void)actionWithAnimations:(void(^)())animations
                    duration:(NSTimeInterval)duration
{
    CATransition * transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    [self.layer addAnimation:transition forKey:nil];

    if (animations) {
        animations();
    }
}

#pragma mark -

- (void)setBadgeValue:(NSString *)badgeValue forSectionAtIndex:(NSUInteger)index
{
    checkIndexAtRange(index, NSMakeRange(0, self.sectionCount));

    _CLSectionControlSection * section = self.sections[index];
    section.badgeValue = badgeValue;
}

- (NSString *)badgeValueForSectionAtIndex:(NSUInteger)index
{
    checkIndexAtRange(index, NSMakeRange(0, self.sectionCount));
    return [self.sections[index] badgeValue];
}

- (void)updateBadgeViews
{
    //内容有效则更新badge视图
    if (!self.isInvalidateContent) {
        [self _updateBadgeViews];
    }
}

- (UIView *)badgeContentView
{
    if (!_badgeContentView) {
        _badgeContentView = [[UIView alloc] initWithFrame:self.bounds];
        _badgeContentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _badgeContentView.userInteractionEnabled = NO;

        [self addSubview:_badgeContentView];
    }

    return _badgeContentView;
}

//更新badge视图
- (void)_updateBadgeViews
{
    CGRect bounds = self.bounds;

    for (_CLSectionControlSection * section in self.sections) {

        if (section.badgeValue) {

            //设置值
            CLBadgeView * badgeView = section.badgeView;

            //无badgeView进行初始化
            if (!badgeView) {
                badgeView = [[CLBadgeView alloc] init];
                section.badgeView = badgeView;
                [self.badgeContentView addSubview:badgeView];
            }

            badgeView.badgeValue = section.badgeValue;
            badgeView.badgeAnchorPoint = CGPointMake(0.5f, 0.4f);

            //设置位置
            CGRect contentRect = section.sectionContentRect;
            badgeView.locationAnchorPoint = CGPointMake(CGRectGetMaxX(contentRect) / CGRectGetWidth(bounds),
                                                        CGRectGetMinY(contentRect) / CGRectGetHeight(bounds));

            //显示
            [badgeView setShowBadge:YES animated:YES completedBlock:nil];

        }else {

            //隐藏
            [section.badgeView setShowBadge:NO animated:YES completedBlock:nil];
        }
    }
}

@end
