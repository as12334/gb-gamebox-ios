//
//  RH_DepositeChooseMoneyCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
#import "RH_DepositeChooseMoneyCell.h"
@class RH_DepositeChooseMoneyCell;
@protocol DepositeChooseMoneyCellDelegate<NSObject>
@optional
-(void)depositeChooseMoneyCell:(NSInteger )moneyNumber;
@end
@interface RH_DepositeChooseMoneyCell : CLTableViewCell
@property(nonatomic,weak)id<DepositeChooseMoneyCellDelegate>delegate;
@end
