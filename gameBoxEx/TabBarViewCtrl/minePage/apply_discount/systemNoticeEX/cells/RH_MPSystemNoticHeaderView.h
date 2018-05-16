//
//  RH_MPGameNoticSectionView.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RH_MPSystemNoticHeaderViewBlock)(CGRect frame);
@class RH_MPSystemNoticHeaderView;
@protocol MPSystemNoticHeaderViewDelegate<NSObject>
-(void)gameSystemHeaderViewStartDateSelected:(RH_MPSystemNoticHeaderView *)view DefaultDate:(NSDate*)defaultDate ;
-(void)gameSystemHeaderViewEndDateSelected:(RH_MPSystemNoticHeaderView *)view DefaultDate:(NSDate*)defaultDate ;
@end
@interface RH_MPSystemNoticHeaderView : UIView
@property(nonatomic,weak)id<MPSystemNoticHeaderViewDelegate>delegate;
@property(nonatomic,copy)RH_MPSystemNoticHeaderViewBlock block;
@property (nonatomic,strong) NSDate *startDate ;
@property (nonatomic,strong) NSDate *endDate ;
@end
