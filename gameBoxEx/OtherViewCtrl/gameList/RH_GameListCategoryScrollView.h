//
//  RH_GameListCategoryScrollView.h
//  gameBoxEx
//
//  Created by shin on 2018/6/8.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RH_GameListCategoryScrollView;
@class RH_LotteryCategoryModel;
@protocol RH_GameListCategoryScrollViewDelegate

@required
- (void)gameListCategoryScrollView:(RH_GameListCategoryScrollView *)view didSelect:(NSInteger)index;

@end

@interface RH_GameListCategoryScrollView : UIView

@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, strong) RH_LotteryCategoryModel *categoryModel;
@property (nonatomic, assign) id <RH_GameListCategoryScrollViewDelegate> delegate;

@end
