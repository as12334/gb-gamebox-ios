//
//  CLSelectionProtocol.h
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <UIKit/UIKit.h>

//----------------------------------------------------------

typedef NS_OPTIONS(NSUInteger,CLSelectionOption) {
    CLSelectionOptionNone        = 0,
    CLSelectionOptionHighlighted = 1 << 0,
    CLSelectionOptionSelected    = 1 << 1,
    CLSelectionOptionAll         = ~0UL
};

//----------------------------------------------------------

@protocol CLSelectionProtocol

//默认为CLSelectionOptionNone
@property(nonatomic) CLSelectionOption selectionOption;

//默认为nil，使用tintColor
@property(nonatomic,strong) UIColor * selectionColor;
//selectionColor的透明度
@property(nonatomic) CGFloat selectionColorAlpha;

//显示的选择颜色
- (UIColor *)showingSelectionColor;
//选择的颜色改变
- (void)selectionColorDidChange;

//高亮的的对象
@property(nonatomic,strong) NSArray * highlightedObjects;

//是否在显示选择
@property(nonatomic,readonly,getter = isShowingSelection) BOOL showingSelection;

//当消失的时候选择是否强制有动画，默认为NO
@property(nonatomic) BOOL animatedSelectionForHidden;

@optional

- (UIView *)showSelectionView;

@property (nonatomic, getter=isSelected)  BOOL   selected;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

@end
