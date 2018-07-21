//
//  RH_ApplyDiscountPageCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PageLoadContentPageCell.h"
#import "RH_DiscountActivityTypeModel.h"
#import "RH_MPGameNoticHeaderView.h"
#import "RH_MPGameNoticePulldownView.h"
@class RH_ApplyDiscountPageCell;
@protocol ApplyDiscountPageCellDelegate<NSObject>
@optional
-(void)applyDiscountPageCellStartDateSelected:(RH_ApplyDiscountPageCell *)cell dateSelected:(RH_MPGameNoticHeaderView*)view DefaultDate:(NSDate *)defaultDate;
-(void)applyDiscountPageCellEndDateSelected:(RH_ApplyDiscountPageCell *)cell  dateSelected:(RH_MPGameNoticHeaderView*)view DefaultDate:(NSDate *)defaultDate;

@end

@interface RH_ApplyDiscountPageCell : RH_PageLoadContentPageCell
@property(nonatomic,weak)id<ApplyDiscountPageCellDelegate>delegate;
@property (nonatomic,strong)NSString *startDate;
@property (nonatomic,strong)NSString *endDate;
@property (nonatomic,strong,readonly)RH_MPGameNoticePulldownView *listView;


-(void)updateViewWithType:(RH_DiscountActivityTypeModel*)typeModel  Context:(CLPageLoadDatasContext*)context ;
@end
