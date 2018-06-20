//
//  RH_MineAccountCell.h
//  lotteryBox
//
//  Created by Lewis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
@class RH_MineAccountCell ;
@protocol MineAccountCellDelegate
@optional
-(void)mineAccountCellTouchRchargeButton:(RH_MineAccountCell*)mineAccountCell ;
-(void)mineAccountCellTouchWithDrawButton:(RH_MineAccountCell*)mineAccountCell ;

@end

@interface RH_MineAccountCell : CLTableViewCell
@property (nonatomic,weak) id<MineAccountCellDelegate> delegate ;

@end
