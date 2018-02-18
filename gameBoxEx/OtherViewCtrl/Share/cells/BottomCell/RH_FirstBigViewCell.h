//
//  RH_FirstBigViewCell.h
//  gameBoxEx
//
//  Created by Richard on 2018/2/13.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
@class RH_FirstBigViewCell;
@protocol RH_FirstBigViewCellDelegate<NSObject>
@optional
-(void)firstBigViewCellStartDateSelected:(RH_FirstBigViewCell *)cell  DefaultDate:(NSDate *)defaultDate;
-(void)firstBigViewCellEndDateSelected:(RH_FirstBigViewCell *)cell   DefaultDate:(NSDate *)defaultDate;
@end

@interface RH_FirstBigViewCell : CLTableViewCell
@property(nonatomic,weak)id<RH_FirstBigViewCellDelegate>delegate;
@property (nonatomic,assign)NSInteger selectedIndex;
@end
