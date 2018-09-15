//
//  RH_ScrollPageView.h
//  gameBoxEx
//
//  Created by jun on 2018/9/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_ScrollSegmentView.h"
#import "RH_ContentView.h"
#import "UIViewController+RHScrollPageController.h"
typedef void(^ExtraBtnOnClick)(UIButton *extraBtn);
@interface RH_ScrollPageView : UIView
@property (copy, nonatomic) ExtraBtnOnClick extraBtnOnClick;

- (instancetype)initWithFrame:(CGRect)frame segmentStyle:(RH_SegmentStyle *)segmentStyle childVcs:(NSArray *)childVcs Titles:(NSArray *)titles parentViewController:(UIViewController *)parentViewController;

/** 给外界设置选中的下标的方法 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;
/**  给外界重新设置视图内容的标题的方法 */
- (void)reloadChildVcsWithNewChildVcs:(NSArray *)newChildVcs;
@end
