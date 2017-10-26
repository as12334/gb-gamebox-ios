//
//  CLPageView.h
//  TaskTracking
//
//  Created by jinguihua on 2017/3/14.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <UIKit/UIKit.h>

//滑动的方向
typedef NS_ENUM(NSInteger,CLPageViewScrollDirection) {
    CLPageViewScrollDirectionHorizontal,
    CLPageViewScrollDirectionVertical
};

//----------------------------------------------------------

@class CLPageView;
@protocol CLPageViewDelegate <UIScrollViewDelegate>

@optional

//显示了page
- (void)pageView:(CLPageView *)pageView didDisplayPageAtIndex:(NSUInteger)pageIndex;
//隐藏了page
- (void)pageView:(CLPageView *)pageView didEndDisplayPageAtIndex:(NSUInteger)pageIndex;


//选中了page
- (void)pageView:(CLPageView *)pageView didSelectedPageAtIndex:(NSUInteger)pageIndex;

@end

//----------------------------------------------------------

@protocol CLPageViewDatasource <NSObject>

@optional
//page数，默认为1
- (NSUInteger)numberOfPagesInPageView:(CLPageView *)pageView;

@required
- (UICollectionViewCell *)pageView:(CLPageView *)pageView cellForPageAtIndex:(NSUInteger)pageIndex;

@end

//----------------------------------------------------------

@interface CLPageView : UIView

- (id)initWithFrame:(CGRect)frame scrollDirection:(CLPageViewScrollDirection)scrollDirection;
//滑动的方向，默认为水平方向
@property(nonatomic,readonly) CLPageViewScrollDirection scrollDirection;

//页面间距（默认为0），设置小于0的值会以0处理
@property(nonatomic) CGFloat pageMargin;


//页面数目,由数据源决定
@property(nonatomic,readonly) NSUInteger pagesCount;

//返回特定索引上的页面cell，如果索引越界或者页面没有显示将返回nil
- (id)cellForPageAtIndex:(NSUInteger)pageIndex;
//返回page的index
- (NSUInteger)indexForPageCell:(UICollectionViewCell *)cell;


//当前显示的page索引,无页面时改值为NSNotFound
@property(nonatomic) NSUInteger dispalyPageIndex;

//重新加载page，keepDispalyPage决定重新加载后是否保持当前页面
- (void)reloadPages:(BOOL)keepDispalyPage;

//注册复用
- (void)registerCellForPage:(Class)cellClass;
- (void)registerCellForPage:(Class)cellClass andReuseIdentifier:(NSString *)identifier;
- (void)registerCellForPage:(Class)cellClass
               nibNameOrNil:(NSString *)nibNameOrNil
                bundleOrNil:(NSBundle *)bundleOrNil
         andReuseIdentifier:(NSString *)reuseIdentifier;

//返回复用的cell(pageView:cellForPageAtIndex:里调用)
- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forPageIndex:(NSUInteger)pageIndex;

@property(nonatomic,weak) id<CLPageViewDatasource> dataSource;
@property(nonatomic,weak) id<CLPageViewDelegate> delegate;

@end
