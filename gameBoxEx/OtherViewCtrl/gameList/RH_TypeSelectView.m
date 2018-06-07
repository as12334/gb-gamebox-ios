//
//  RH_TypeSelectView.m
//  gameBoxEx
//
//  Created by shin on 2018/6/6.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_TypeSelectView.h"
#import "CLHorizontalScroller.h"
#import "MacroDef.h"
#import "RH_LotteryCategoryModel.h"
#import "RH_LotteryAPIInfoModel.h"
#import "RH_GameListCategoryView.h"

@interface RH_TypeSelectView () <HorizontalScrollerDelegate>

@property (nonatomic, strong) CLHorizontalScroller *horizontalScroller;

@end

@implementation RH_TypeSelectView

- (void)setCategoryModel:(RH_LotteryCategoryModel *)categoryModel
{
    _categoryModel = categoryModel;
    [self.horizontalScroller reload];
}

- (CLHorizontalScroller *)horizontalScroller
{
    if (_horizontalScroller == nil) {
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        bg.image = [UIImage imageNamed:@"gamelist_bg"];
        [self addSubview:bg];
        
        _horizontalScroller = [[CLHorizontalScroller alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _horizontalScroller.backgroundColor = [UIColor clearColor];
        _horizontalScroller.delegate = self;
        [self addSubview:_horizontalScroller];
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-15)/2.0, self.frame.size.height-7, 15, 7.5)];
        arrow.image = [UIImage imageNamed:@"gamelist_arrow"];
        [self addSubview:arrow];
    }
    return _horizontalScroller;
}

#pragma mark - HorizontalScrollerDelegate M

- (NSInteger)numberOfViewsForHorizontalScroller:(CLHorizontalScroller*)scroller
{
    return _categoryModel.mSiteApis.count;
}

- (UIView *)horizontalScroller:(CLHorizontalScroller*)scroller viewAtIndex:(int)index
{
    RH_GameListCategoryView *item = [[[NSBundle mainBundle] loadNibNamed:@"RH_GameListCategoryView" owner:nil options:nil] lastObject];
    item.frame = CGRectMake(0, 0, 70, 70);
    item.model = _categoryModel.mSiteApis[index];
    return item;
}

- (void)horizontalScroller:(CLHorizontalScroller*)scroller clickedViewAtIndex:(int)index
{
    ifRespondsSelector(self.delegate, @selector(typeSelectView:didSelect:)){
        [self.delegate typeSelectView:self didSelect:index];
    }
}

- (NSInteger)initialViewIndexForHorizontalScroller:(CLHorizontalScroller *)scroller
{
    return 0;
}

@end
