//
//  RH_DepositeChooseMoneyCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
#import "RH_DepositeChooseMoneyCell.h"
#import "RH_DepositeTransferChannelModel.h"
@class RH_DepositeChooseMoneyCell;
@protocol DepositeChooseMoneyCellDelegate<NSObject>
@optional
-(void)depositeChooseMoneyCell:(NSInteger )moneyNumber;
@end
@interface RH_DepositeChooseMoneyCell : CLTableViewCell
@property(nonatomic,weak)id<DepositeChooseMoneyCellDelegate>delegate;
-(void)updateUIWithListModelModel:(RH_DepositeTransferListModel *)model;//这里仅仅是要获取到最大值最小值
@end
