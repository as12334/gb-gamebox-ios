//
//  RH_GameListCategoryScrollView.m
//  gameBoxEx
//
//  Created by shin on 2018/6/8.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_GameListCategoryScrollView.h"
#import "MacroDef.h"
#import "RH_LotteryCategoryModel.h"
#import "RH_LotteryAPIInfoModel.h"
#import "RH_GameListCategoryView.h"

#define RH_GameListCategoryView_Width 70.0
#define RH_GameListCategoryView_Height 80.0

@interface RH_GameListCategoryScrollView () <RH_GameListCategoryViewDelegate>

@property (nonatomic, strong) UIImageView *markImg;
@property (nonatomic, strong) UIScrollView *scroll;

@end

@implementation RH_GameListCategoryScrollView

- (UIImageView *)markImg
{
    if (_markImg == nil) {
        _markImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-7, 15, 7.5)];
        _markImg.image = [UIImage imageNamed:@"gamelist_arrow"];
    }
    return _markImg;
}

- (void)setCategoryModel:(RH_LotteryCategoryModel *)categoryModel
{
    _categoryModel = categoryModel;
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    bg.image = [UIImage imageNamed:@"gamelist_bg"];
    [self addSubview:bg];

    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:_scroll];
    
    CGFloat temp = 10.0;
    CGFloat contenSize_w = _categoryModel.mSiteApis.count*RH_GameListCategoryView_Width + (_categoryModel.mSiteApis.count-1)*temp > self.bounds.size.width ? _categoryModel.mSiteApis.count*RH_GameListCategoryView_Width + (_categoryModel.mSiteApis.count-1)*temp: self.bounds.size.width;
    _scroll.contentSize = CGSizeMake(contenSize_w, self.bounds.size.height);
    
    for (int i = 0; i < _categoryModel.mSiteApis.count; i++) {
        RH_GameListCategoryView *item = [[[NSBundle mainBundle] loadNibNamed:@"RH_GameListCategoryView" owner:nil options:nil] lastObject];
        item.frame = CGRectMake(i*(temp+RH_GameListCategoryView_Width), (self.bounds.size.height-RH_GameListCategoryView_Height)/2.0, RH_GameListCategoryView_Width, RH_GameListCategoryView_Height);
        item.model = _categoryModel.mSiteApis[i];
        item.tag = 1024+i;
        item.delegate = self;
        [_scroll addSubview:item];
    }
    
    [_scroll addSubview:self.markImg];
    
    RH_GameListCategoryView *defaultSelectItem = [_scroll viewWithTag:1024+self.selectedIndex];
    self.markImg.frame = CGRectMake(defaultSelectItem.frame.origin.x+RH_GameListCategoryView_Width/2.0-self.markImg.frame.size.width/2.0, self.markImg.frame.origin.y, self.markImg.frame.size.width, self.markImg.frame.size.height);
    
    for (int i = 0; i < self.categoryModel.mSiteApis.count; i++) {
        RH_GameListCategoryView *view = [_scroll viewWithTag:1024+i];

        if (self.selectedIndex == i) {
            CGAffineTransform viewsOriginalTransform = view.transform;
            view.transform = CGAffineTransformScale(viewsOriginalTransform, 1.2, 1.2);
            view.alpha = 1.0;
        }
        else
        {
            view.transform = CGAffineTransformIdentity;
            view.alpha = 0.8;
        }
    }
}

#pragma mark - RH_GameListCategoryViewDelegate M

- (void)gameListCategoryViewDidSelect:(RH_GameListCategoryView *)view
{
    if (self.selectedIndex != view.tag-1024) {
        self.selectedIndex = (int)(view.tag-1024);
        self.markImg.frame = CGRectMake(view.frame.origin.x+RH_GameListCategoryView_Width/2.0-self.markImg.frame.size.width/2.0, self.markImg.frame.origin.y, self.markImg.frame.size.width, self.markImg.frame.size.height);
        
        for (int i = 0; i < self.categoryModel.mSiteApis.count; i++) {
            RH_GameListCategoryView *subItem = [self.scroll viewWithTag:1024+i];
            if (view.tag-1024 == i) {
                CGAffineTransform viewsOriginalTransform = view.transform;
                subItem.transform = CGAffineTransformScale(viewsOriginalTransform, 1.2, 1.2);
                subItem.alpha = 1.0;
            }
            else
            {
                subItem.transform = CGAffineTransformIdentity;
                subItem.alpha = 0.8;
            }
        }
        
        ifRespondsSelector(self.delegate, @selector(gameListCategoryScrollView:didSelect:))
        {
            [self.delegate gameListCategoryScrollView:self didSelect:view.tag-1024];
        }
    }
}

@end
