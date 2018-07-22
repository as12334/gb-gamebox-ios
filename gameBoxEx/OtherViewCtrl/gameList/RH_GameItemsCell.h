//
//  RH_GameItemsCell.h
//  gameBoxEx
//
//  Created by shin on 2018/6/6.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RH_LotteryAPIInfoModel;
@class RH_GameItemsCell;
@class RH_LotteryInfoModel;

@protocol RH_GameItemsCellDelegate

@optional
- (void)gameItemsCell:(RH_GameItemsCell *)view didSelect:(RH_LotteryInfoModel *)model;

@end

@interface RH_GameItemsCell : UITableViewCell

@property (nonatomic, strong) NSArray *itemsArr;
@property (nonatomic, strong) RH_LotteryAPIInfoModel *typeModel;
@property (nonatomic, weak) id <RH_GameItemsCellDelegate> delegate;

@end
