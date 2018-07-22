//
//  CLSegmentedControl.h
//  cpLottery
//
//  Created by luis on 2017/11/19.
//  Copyright © 2017年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "help.h"

//----------------------------------------------------------

#define NoneSectionIndex NSNotFound

//----------------------------------------------------------

//section编辑的类型
typedef NS_ENUM(NSInteger,CLSegmentedControlSectionEditType) {
    CLSegmentedControlSectionInsert,    //插入
    CLSegmentedControlSectionRemove,    //移除
    CLSegmentedControlSectionUpdate,    //更新，删除原有元素
    CLSegmentedControlSectionExpand     //扩展，更新不删除原有元素
};

//section的状态
typedef NS_ENUM(NSInteger,CLSegmentedControlSectionState) {
    CLSegmentedControlSectionStateNormal,
    CLSegmentedControlSectionStateHighlighted,
    CLSegmentedControlSectionStateSelected,
    CLSegmentedControlSectionStateDisabled,
    CLSegmentedControlSectionStateCount
};

//布局方向
typedef NS_ENUM(NSInteger,CLSegmentedControlLayoutDirection) {
    CLSegmentedControlLayoutDirectionHorizontal,    //水平布局
    CLSegmentedControlLayoutDirectionVertical       //竖直布局
};

//section的布局
typedef NS_ENUM(NSInteger,CLSegmentedControlSectionLayout) {
    CLSegmentedControlSectionLayoutImageLeft,    //图左文右
    CLSegmentedControlSectionLayoutImageRight,   //图右文左
    CLSegmentedControlSectionLayoutImageTop,     //图上文下
    CLSegmentedControlSectionLayoutImageBottom   //图下文上
};

//内容的对其方式
typedef NS_ENUM(NSInteger,CLSegmentedControlSectionContentAlign) {
    CLSegmentedControlSectionContentAlignCenter,    //中心对齐
    CLSegmentedControlSectionContentAlignTop,       //上端对齐
    CLSegmentedControlSectionContentAlignBottom,    //下端对齐
    CLSegmentedControlSectionContentAlignLeft =
    CLSegmentedControlSectionContentAlignTop,       //左对齐
    CLSegmentedControlSectionContentAlignRight =
    CLSegmentedControlSectionContentAlignBottom     //右对齐
};


//选择指示器的布局
typedef NS_ENUM(NSInteger,CLSegmentedControlSelectedIndicatorLayout) {
    CLSegmentedControlSelectedIndicatorLayoutBottom,      //下端，针对水平布局
    CLSegmentedControlSelectedIndicatorLayoutTop,         //上端，针对水平布局
    CLSegmentedControlSelectedIndicatorLayoutLeft     =
    CLSegmentedControlSelectedIndicatorLayoutBottom,  //左端，针对竖直布局
    CLSegmentedControlSelectedIndicatorLayoutRight    =
    CLSegmentedControlSelectedIndicatorLayoutTop      //右端，针对竖直布局
};

//边界掩码
typedef NS_OPTIONS(NSUInteger, CLSegmentedControlBorderMask) {
    CLSegmentedControlBorderNone   = 0,
    CLSegmentedControlBorderTop    = 1,
    CLSegmentedControlBorderBottom = 1 << 1,
    CLSegmentedControlBorderLeft   = 1 << 2,
    CLSegmentedControlBorderRight  = 1 << 3,
    CLSegmentedControlBorderAll    = ~0UL
};


//----------------------------------------------------------

@interface CLSegmentedControl : UIControl

/**
 * 初始化
 */
//-----------------------------------------

- (id)initWithSectionTitles:(NSArray *)titles;
- (id)initWithSectionImages:(NSArray *)images;
- (id)initWithSectionTitles:(NSArray *)titles images:(NSArray *)images;

- (id)initWithSectionTitles:(NSArray *)titles
                     images:(NSArray *)images
          highlightedImages:(NSArray *)highlightedImages
             selectedImages:(NSArray *)selectedImages
             disabledImages:(NSArray *)disabledImages;

/**
 * 编辑section
 */
//-----------------------------------------

//单元个数
@property(nonatomic,readonly) NSUInteger sectionCount;


//添加一组Section
- (void)addSectionsWithTitles:(NSArray *)titles;
- (void)addSectionsWithImages:(NSArray *)images;
- (void)addSectionsWithTitles:(NSArray *)titles images:(NSArray *)images;
//datas为title和image组成的数组
- (void)addSectionsWithDatas:(NSArray *)datas;

- (void)addSectionsWithTitles:(NSArray *)titles
                       images:(NSArray *)images
            highlightedImages:(NSArray *)highlightedImages
               selectedImages:(NSArray *)selectedImages
               disabledImages:(NSArray *)disabledImages;


- (void)editSectionWithType:(CLSegmentedControlSectionEditType)editType
                    atIndex:(NSUInteger)index
                  withTitle:(NSString *)title;

- (void)editSectionWithType:(CLSegmentedControlSectionEditType)editType
                    atIndex:(NSUInteger)index
                  withImage:(UIImage *)image;

- (void)editSectionWithType:(CLSegmentedControlSectionEditType)editType
                    atIndex:(NSUInteger)index
                  withTitle:(NSString *)title
                      image:(UIImage *)image;

- (void)editSectionWithType:(CLSegmentedControlSectionEditType)editType
                    atIndex:(NSUInteger)index
                  withTitle:(NSString *)title
                      image:(UIImage *)image
           highlightedImage:(UIImage *)highlightedImage
              selectedImage:(UIImage *)selectedImage
              disabledImage:(UIImage *)disabledImage;

//移除所有的sections
- (void)removeAllSections;


/**
 * section的内容
 */
//-----------------------------------------


//获取索引的index的section的标题
- (NSString *)sectionTitleAtIndex:(NSUInteger)index;

/**
 * 获取section的图片
 * @param index index为section的索引
 * @param state state为section的状态
 * @return 返回图片，没有则为nil
 */
- (UIImage *)sectionImageAtIndex:(NSUInteger)index forState:(CLSegmentedControlSectionState)state;


//字体，默认为17号system字体
@property(nonatomic,strong) UIFont  * textFont;

/**
 * 设置文本颜色
 * @param textColor textColor未文本颜色
 * @param state     state为状态
 */
- (void)setTextColor:(UIColor *)textColor forState:(CLSegmentedControlSectionState)state;

//返回state状态的文本颜色
- (UIColor *)textColorForState:(CLSegmentedControlSectionState)state;

//是否自动调整文本颜色，如果为YES，则当状态改变时，如无颜色则按照一定规律调整显示，默认为YES
@property(nonatomic) BOOL autoAdjustTextColor;

//返回state状态显示的文本颜色，原则是如果state状态无自定义颜色则使用Normal状态下的颜色，Normal无则用默认黑色
- (UIColor *)showingTextColorForState:(CLSegmentedControlSectionState)state;


//是否自动调整图片，如果为YES，则当状态改变时，如无自定义图片则通过文字颜色自动改变Normal状态下的图片，默认为YES
@property(nonatomic) BOOL autoAdjustImage;
//是否调整图片和文本颜色一致，默认为NO
@property(nonatomic) BOOL adjustImageWithTextColor;

//获取索引的index的section在state状态下显示的图片,包含自动调整的结果
- (UIImage *)sectionShowingImageAtIndex:(NSUInteger)index forState:(CLSegmentedControlSectionState)state;

//设置可用性，默认为YES
- (void)setEnabled:(BOOL)enabled forSectionAtIndex:(NSUInteger)index;
- (BOOL)isEnabledForSectionAtIndex:(NSUInteger)index;


//背景色，默认为nil，即透明
- (void)setSectionBackgroundColor:(UIColor *)backgroundColor forState:(CLSegmentedControlSectionState)state;
- (UIColor *)sectionBackgroundColorForState:(CLSegmentedControlSectionState)state;

//是否自动调整背景颜色，如果为YES，则当状态改变时，如无颜色则按照一定规律调整显示，默认为YES
@property(nonatomic) BOOL autoAdjustBackgroundColor;

- (UIColor *)sectionShowingBackgroundColorForState:(CLSegmentedControlSectionState)state;

//背景的inset
@property(nonatomic) UIEdgeInsets sectionBackgroundColorInset;


//获取索引为index的section状态
- (CLSegmentedControlSectionState)sectionStateAtIndex:(NSUInteger)index;

/**
 * 选择指示线
 */
//-----------------------------------------

//是否显示选择指示线,默认为NO
@property(nonatomic) BOOL    showSelectedIndicatorLine;
//选择指示线的布局，针对水平布局默认为下端，竖直布局，默认为左端
@property(nonatomic) CLSegmentedControlSelectedIndicatorLayout selectedIndicatorLayout;

//选择指示线的宽度,默认为2.f
@property(nonatomic) CGFloat selectedIndicatorLineWidth;
//选择指示线的颜色，默认为nil，为nil时使用tintColor
@property(nonatomic,strong) UIColor * selectedIndicatorLineColor;

//是否选择指示器长度由内容决定，默认为NO
@property(nonatomic) BOOL    apportionsSelectedIndicatorLineByContent;
//选择指示线的缩进量，绝对值，默认为0
@property(nonatomic) UIEdgeInsets selectedIndicatorLineInset;
//选择指示线的缩进比例，单位量，默认为0
@property(nonatomic) UIEdgeInsets selectedIndicatorLineInsetScale;

/**
 * 分隔线
 */
//-----------------------------------------

//是否为渐变的的分割线，默认为YES
@property(nonatomic) BOOL drawGradientSeparatorLine;

//分割线的宽度,默认为1个像素宽度,小于0时不显示
@property(nonatomic) CGFloat separatorLineWidth;
//分割线颜色,默认为黑色
@property(nonatomic,strong) UIColor * separatorLineColor;

//分割线的缩进量，绝对值，默认为0
@property(nonatomic) UIEdgeInsets separatorLineInset;
//分割线缩进比例，单位量，默认为0
@property(nonatomic) UIEdgeInsets separatorLineInsetScale;
//分割线的偏移
@property(nonatomic) CGPoint separatorLineOffset;


/**
 * 边界
 */
//-----------------------------------------

//边界掩码，指示显示的边界，默认为CLSegmentedControlBorderNone
@property(nonatomic) CLSegmentedControlBorderMask  borderMask;

//边界宽度，默认为1像素的的宽度
@property(nonatomic) CGFloat borderWidth;
//边界颜色，默认为黑色
@property(nonatomic,strong) UIColor * borderColor;

//分割线的缩进量，绝对值，默认为0
@property(nonatomic) UIEdgeInsets borderLineInset;
//分割线缩进比例，单位量，默认为0
@property(nonatomic) UIEdgeInsets borderLineInsetScale;



/**
 * section的布局
 */
//-----------------------------------------

//布局方向，默认为CLSegmentedControlLayoutDirectionHorizontal，水平布局
@property(nonatomic) CLSegmentedControlLayoutDirection layoutDirection;
//section的布局，默认为CLSegmentedControlSectionLayoutImageLeft，图左文右
@property(nonatomic) CLSegmentedControlSectionLayout   sectionLayout;
//section内容的布局，默认为MyContentLayoutCenter，中心
@property(nonatomic) CLContentLayout sectionContentLayout;
//section内容的对齐方式，默认为CLSegmentedControlSectionContentAlignCenter
@property(nonatomic) CLSegmentedControlSectionContentAlign sectionContentAlign;

//获取section大小的block，设置该值，可进行自定义计算
@property(nonatomic,copy) CGSize(^getSectionSizeBlock)(NSUInteger sectionIndex, //当前需要获取大小的sectionIndex
CGSize contentShowSize,  //section内容显示需要的大小
CGPoint sectionOffset,  //section当前的偏移
CGSize boundsSize);


//内容布局block,设置该值，可进行完全自定义布局
@property(nonatomic,copy) void(^sectionContentLayoutBlock)(NSUInteger sectionIndex, //当前需要布局的sectionIndex
CGRect sectionRect,      //section的rect
CGSize contentSize,      //内容大小
CGSize imageSize,        //图像大小
CGSize titleSize,        //文本大小
CGRect * contentRect,    //返回内容布局的外部变量，基于sectionRect
CGRect * imageRect,      //返回图像布局的外部变量，基于sectionRect
CGRect * titleRect);     //返回文本布局的外部变量，基于sectionRect

//section的大小是否由其内容决定，默认为NO
@property(nonatomic) BOOL apportionsSectionSizeByContent;
//是否只依据section的状态的内容计算大小，即状态改变重新计算大小，默认为NO
@property(nonatomic) BOOL calculateScetionSizeByState;

//图片和文字的间隔，默认为2.f
@property(nonatomic) CGFloat titleImageMargin;
//最小的单元间隔，默认为0.f
@property(nonatomic) CGFloat minSectionMargin;
//section内容的偏移，默认为CGPointZero
@property(nonatomic) CGPoint sectionContentOffset;

//返回索引为index的section的rect
- (CGRect)rectForSectionAtIndex:(NSUInteger)index;
//返回索引为index的section内容的rect
- (CGRect)rectForSectionContentAtIndex:(NSUInteger)index;
//返回索引为index的section图像的rect
- (CGRect)rectForSectionImageAtIndex:(NSUInteger)index;
//返回索引为index的section标题的rect
- (CGRect)rectForSectionTitleAtIndex:(NSUInteger)index;
//返回point所在section的索引，不存在则返回NoneSectionIndex
- (NSUInteger)sectionIndexForPoint:(CGPoint)point;


//计算内建大小时单元扩张的比例，单位量，默认为0
@property(nonatomic) CGSize intrinsicSectionExpansionScale;
////计算内建大小时单元扩张的比例长度，绝对值，默认为CGSizeZero
@property(nonatomic) CGSize intrinsicSectionExpansionLength;


/**
 * 选择
 */
//-----------------------------------------

//是否是短暂的，如果设置为YES，则不会显示选择状态，默认为NO
@property(nonatomic,getter=isMomentary) BOOL momentary;

//是否允许取消选择，即点击到已选项可以取消选择
@property(nonatomic,getter=isAllowDeselected) BOOL allowDeselected;


//选择的单元索引,默认为NoneSectionIndex，对于momentary风格此属性将被忽略,返回最近被press的单元的index
@property(nonatomic) NSUInteger selectedSectionIndex;
- (void)setSelectedSectionIndex:(NSUInteger)selectedSectionIndex animated:(BOOL)animated;

//取消选择
- (void)cancleSelected;

/**
 * 动画
 */
//-----------------------------------------

- (void)actionWithAnimations:(void(^)(void))animations duration:(NSTimeInterval)duration;

/**
 * badge
 */
//-----------------------------------------

//设置badge值
- (void)setBadgeValue:(NSString *)badgeValue forSectionAtIndex:(NSUInteger)index;

//更新badgeView,设置badgeValue后需调用该方法刷新视图，否则不会立即刷新
- (void)updateBadgeViews;

//获取badge值
- (NSString *)badgeValueForSectionAtIndex:(NSUInteger)index;

@end

