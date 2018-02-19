//
//  RH_ShareRecordTableViewCell.h
//  gameBoxEx
//
//  Created by Richard on 2018/2/13.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
@class RH_ShareRecordTableViewCell;
@protocol RH_ShareRecordTableViewCellDelegate <NSObject>
@optional
-(void)shareRecordTableViewSearchBtnDidTouch:(RH_ShareRecordTableViewCell*)shareRecordTableViewCell ;
-(void)shareRecordTableViewWillSelectedStartDate:(RH_ShareRecordTableViewCell*)shareRecordTableView DefaultDate:(NSDate*)defaultDate ;
-(void)shareRecordTableViewWillSelectedEndDate:(RH_ShareRecordTableViewCell*)shareRecordTableView DefaultDate:(NSDate*)defaultDate ;
@end


@interface RH_ShareRecordTableViewCell : CLTableViewCell
@property(nonatomic,weak)id<RH_ShareRecordTableViewCellDelegate> delegate ;
@property (nonatomic,strong) NSDate *startDate ;
@property (nonatomic,strong) NSDate *endDate ;
@end
