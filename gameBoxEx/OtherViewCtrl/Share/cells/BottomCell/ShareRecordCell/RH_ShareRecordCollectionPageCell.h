//
//  RH_ShareRecordCollectionViewCell.h
//  gameBoxEx
//
//  Created by Richard on 2018/2/13.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PageLoadContentPageCell.h"
#import "RH_SharePlayerRecommendModel.h"

@class RH_ShareRecordCollectionPageCell;
@protocol RH_ShareRecordCollectionPageCellDelegate<NSObject>
@optional
-(void)shareRecordCollectionPageCellStartDateSelected:(RH_ShareRecordCollectionPageCell *)cell  DefaultDate:(NSDate *)defaultDate;
-(void)shareRecordCollectionPageCellEndDateSelected:(RH_ShareRecordCollectionPageCell *)cell   DefaultDate:(NSDate *)defaultDate;
@end

@interface RH_ShareRecordCollectionPageCell : RH_PageLoadContentPageCell
@property(nonatomic,weak)id<RH_ShareRecordCollectionPageCellDelegate>delegate;
@property (nonatomic,strong)NSString *startDate;
@property (nonatomic,strong)NSString *endDate;


-(void)updateViewWithType:(RH_SharePlayerRecommendModel*)typeModel  Context:(CLPageLoadDatasContext*)context ;

@end
