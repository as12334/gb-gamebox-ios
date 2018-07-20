//
//  RH_DepositeReminderCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
@class RH_DepositeReminderCell;
@protocol DepositeReminderCellCustomDelegate<NSObject>
@optional
-(void)touchTextViewCustomPushCustomViewController:(RH_DepositeReminderCell *)cell;
@end
@interface RH_DepositeReminderCell : CLTableViewCell
@property(nonatomic,weak)id<DepositeReminderCellCustomDelegate>delegate;
@end
