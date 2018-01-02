//
//  RH_MineRecordTableViewCell.h
//  lotteryBox
//
//  Created by Lewis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
@class RH_MineRecordTableViewCell;
@protocol MineRecordTableViewCellDelegate<NSObject>
-(void)clickStaticCellAndPushOtherController:(UIViewController *)controller;
@end
@interface RH_MineRecordTableViewCell : CLTableViewCell
@property(nonatomic,assign)NSInteger numberSection;
@property(nonatomic,assign)NSInteger numberItems;
@property(nonatomic,weak)id<MineRecordTableViewCellDelegate>delegate;
@end