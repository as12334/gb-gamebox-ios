//
//  RH_BettingRecordHeaderView.h
//  lotteryBox
//
//  Created by luis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RH_BettingRecordHeaderView ;
@protocol BettingRecordHeaderViewDelegate
@optional
-(void)bettingRecordHeaderViewWillSelectedStartDate:(RH_BettingRecordHeaderView*)bettingRecordHeaderView DefaultDate:(NSDate*)defaultDate ;
-(void)bettingRecordHeaderViewWillSelectedEndDate:(RH_BettingRecordHeaderView*)bettingRecordHeaderView DefaultDate:(NSDate*)defaultDate ;
-(void)bettingRecordHeaderViewTouchSearchButton:(RH_BettingRecordHeaderView*)bettingRecordHeaderView ;
@end

@interface RH_BettingRecordHeaderView : UIView
@property (nonatomic,weak) id<BettingRecordHeaderViewDelegate> delegate ;
@property (nonatomic,strong) NSDate *startDate ;
@property (nonatomic,strong) NSDate *endDate ;

@end
