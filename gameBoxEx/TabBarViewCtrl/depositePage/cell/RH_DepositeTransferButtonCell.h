//
//  RH_DepositeTransferButtonCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/3/28.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
#import "RH_DepositeTransferButtonCell.h"
@class RH_DepositeTransferButtonCell;
@protocol DepositeTransferButtonCellDelegate<NSObject>
@optional
-(void)selectedDepositeTransferButton:(RH_DepositeTransferButtonCell *)cell;
@end
@interface RH_DepositeTransferButtonCell : CLTableViewCell
@property(nonatomic,weak)id<DepositeTransferButtonCellDelegate>delegate;
@end
