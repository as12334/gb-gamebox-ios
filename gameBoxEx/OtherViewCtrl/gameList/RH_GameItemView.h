//
//  RH_GameItemView.h
//  gameBoxEx
//
//  Created by shin on 2018/6/6.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RH_LotteryInfoModel;
@class RH_LotteryAPIInfoModel;
@interface RH_GameItemView : UIView

@property (nonatomic, strong) RH_LotteryInfoModel *model;
@property (nonatomic, strong) RH_LotteryAPIInfoModel *typeModel;

@end
