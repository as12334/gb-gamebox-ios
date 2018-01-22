//
//  RH_ApplyDiscountSystemPageCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PageLoadContentPageCell.h"
#import "RH_DiscountActivityTypeModel.h"
#import "RH_MPSystemNoticHeaderView.h"
@class RH_ApplyDiscountSystemPageCell;
@protocol ApplyDiscountSystemPageCellDelegate<NSObject>
@optional
-(void)applyDiscountSystemStartDateSelected:(RH_ApplyDiscountSystemPageCell *)cell dateSelected:(RH_MPSystemNoticHeaderView*)view DefaultDate:(NSDate *)defaultDate;
-(void)applyDiscountSystemEndDateSelected:(RH_ApplyDiscountSystemPageCell *)cell  dateSelected:(RH_MPSystemNoticHeaderView*)view DefaultDate:(NSDate *)defaultDate;

@end

@interface RH_ApplyDiscountSystemPageCell : RH_PageLoadContentPageCell
@property(nonatomic,weak)id<ApplyDiscountSystemPageCellDelegate>delegate;
@property (nonatomic,strong)NSString *startDate;
@property (nonatomic,strong)NSString *endDate;

-(void)updateViewWithContext:(CLPageLoadDatasContext*)context ;
-(void)updateViewWithType:(RH_DiscountActivityTypeModel*)typeModel  Context:(CLPageLoadDatasContext*)context ;
@end
