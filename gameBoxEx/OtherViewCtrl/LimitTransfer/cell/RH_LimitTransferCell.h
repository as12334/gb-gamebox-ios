//
//  RH_LimitTransferCell.h
//  gameBoxEx
//
//  Created by Richard on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
#import "RH_UserApiBalanceModel.h"

@class RH_LimitTransferCell;
@protocol RH_LimitTransferCellDelegate
- (void)limitTransferCelRecoryAndRefreshBtnDidTouch:(RH_LimitTransferCell *)limitTransferCell withBtn:(UIButton *) sender withModel:(RH_UserApiBalanceModel *)model;
@end


@interface RH_LimitTransferCell : CLTableViewCell
@property (nonatomic, weak) id<RH_LimitTransferCellDelegate> delegate;

@end
