//
//  HorizontalScroller.h
//  AlbumLibrary
//  适配器（Adapter）模式    代理模式
//  适配器可以让一些接口不兼容的类一起工作。它包装一个对象然后暴漏一个标准的交互接口。
//  Created by LamTsanFeng on 14-8-16.
//  Copyright (c) 2014年 LamTsanFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizontalScrollerDelegate;

@interface CLHorizontalScroller : UIView <UIScrollViewDelegate>

@property (weak) id<HorizontalScrollerDelegate> delegate;

- (void)reload;

@end

@protocol HorizontalScrollerDelegate <NSObject>

@required

// 视图的数量

- (NSInteger)numberOfViewsForHorizontalScroller:(CLHorizontalScroller*)scroller;

// 指定索引位置的视图

- (UIView *)horizontalScroller:(CLHorizontalScroller*)scroller viewAtIndex:(int)index;

// 用户点击视图后的行为

- (void)horizontalScroller:(CLHorizontalScroller*)scroller clickedViewAtIndex:(int)index;

@optional

// 初始化视图；
// 如果它没有实现，那么HorizontalScroller将缺省用第一个索引的视图。

- (NSInteger)initialViewIndexForHorizontalScroller:(CLHorizontalScroller*)scroller;

@end
