//
//  RH_DepositeTransferReminderCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
@class RH_DepositeTransferReminderCell;
@protocol DepositeTransferReminderCellDelegate<NSObject>
@optional
-(void)touchTransferReminderTextViewPushCustomViewController:(RH_DepositeTransferReminderCell *)cell;
@end
@interface RH_DepositeTransferReminderCell : CLTableViewCell
@property(nonatomic,weak)id<DepositeTransferReminderCellDelegate>delegate;
@end
