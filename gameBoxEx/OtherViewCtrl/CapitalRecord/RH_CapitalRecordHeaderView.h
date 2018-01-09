//
//  RH_CapitalRecordHeaderView.h
//  gameBoxEx
//
//  Created by Richard on 04/01/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RH_CapitalRecordHeaderView ;
@protocol CapitalRecordHeaderViewDelegate
@optional
-(void)CapitalRecordHeaderViewWillSelectedStartDate:(RH_CapitalRecordHeaderView*)CapitalRecordHeaderView DefaultDate:(NSDate*)defaultDate ;
-(void)CapitalRecordHeaderViewWillSelectedEndDate:(RH_CapitalRecordHeaderView*)CapitalRecordHeaderView DefaultDate:(NSDate*)defaultDate ;
@end

@interface RH_CapitalRecordHeaderView : UIView
@property (nonatomic,weak) id<CapitalRecordHeaderViewDelegate> delegate ;
@property (nonatomic,strong) NSDate *startDate ;
@property (nonatomic,strong) NSDate *endDate ;

@end
