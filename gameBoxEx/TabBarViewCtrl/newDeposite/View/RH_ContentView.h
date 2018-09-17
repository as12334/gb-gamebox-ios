//
//  RH_ContentView.h
//  gameBoxEx
//
//  Created by jun on 2018/9/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RH_ScrollSegmentView;
@interface RH_ContentView : UIView
@property (weak, nonatomic) UICollectionView *collectionView;
- (instancetype)initWithFrame:(CGRect)frame childVcs:(NSArray *)childVcs segmentView:(RH_ScrollSegmentView *)segmentView parentViewController:(UIViewController *)parentViewController;

/** 给外界可以设置ContentOffSet的方法 */
- (void)setContentOffSet:(CGPoint)offset animated:(BOOL)animated;
/** 给外界刷新视图的方法 */
- (void)reloadAllViewsWithNewChildVcs:(NSArray *)newChileVcs;
@end
