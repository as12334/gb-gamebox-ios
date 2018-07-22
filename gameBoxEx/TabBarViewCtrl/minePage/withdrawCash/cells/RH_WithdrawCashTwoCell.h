//
//  RH_WithdrawCashTwoCell.h
//  gameBoxEx
//
//  Created by Lenny on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ModifyPasswordCell.h"

@class RH_WithdrawCashTwoCell ;
@protocol WithdrawCashTwoCellDelegate
@optional
-(void)withdrawCashTwoCellDidTouchDONE:(RH_WithdrawCashTwoCell*)withdrawCashCell ;
@end

@interface RH_WithdrawCashTwoCell : RH_ModifyPasswordCell
@property (nonatomic,weak) id<WithdrawCashTwoCellDelegate> delegate ;

@end
