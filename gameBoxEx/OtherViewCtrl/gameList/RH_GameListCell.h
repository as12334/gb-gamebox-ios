//
//  RH_GameListCell.h
//  gameBoxEx
//
//  Created by shin on 2018/6/7.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTableViewCell.h"

@class RH_LotteryInfoModel;
@class RH_LotteryAPIInfoModel;
@interface RH_GameListCell : CLTableViewCell

@property (nonatomic, strong) RH_LotteryInfoModel *model;
@property (nonatomic, strong) RH_LotteryAPIInfoModel *typeModel;

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *subType;

@end
