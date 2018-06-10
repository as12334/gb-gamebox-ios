//
//  RH_GameListCategoryView.h
//  gameBoxEx
//
//  Created by shin on 2018/6/6.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RH_LotteryAPIInfoModel;
@class RH_GameListCategoryView;

@protocol RH_GameListCategoryViewDelegate

- (void)gameListCategoryViewDidSelect:(RH_GameListCategoryView *)view;

@end

@interface RH_GameListCategoryView : UIView

@property (nonatomic, strong) RH_LotteryAPIInfoModel *model;
@property (nonatomic, weak) id <RH_GameListCategoryViewDelegate> delegate;

@end
