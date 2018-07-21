//
//  RH_WithdrawMoneyLowCell.h
//  gameBoxEx
//
//  Created by Lenny on 2018/1/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"

@class RH_WithdrawMoneyLowCell ;
@protocol WithdrawMoneyLowCellDelegate
@optional
-(void)withdrawMoneyLowCellDidTouchQuickButton:(RH_WithdrawMoneyLowCell*)withdrawLowCell ;
-(void)withdrawMoneyLowCellDidTouchRecycleButton:(RH_WithdrawMoneyLowCell *)withdrawLowCell;
@end

@interface RH_WithdrawMoneyLowCell : CLTableViewCell
@property(nonatomic,weak) id<WithdrawMoneyLowCellDelegate> delegate ;

@end
