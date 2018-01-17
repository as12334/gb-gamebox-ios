//
//  RH_MPGameNoticSectionView.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_MPGameNoticHeaderView.h"
typedef void (^GameNoticHeaderViewBlock)(int number, CGRect frame);
typedef void (^GameNoticHeaderViewKuaixuanBlock)(int number, CGRect frame);
@class RH_MPGameNoticHeaderView;
@protocol MPGameNoticHeaderViewDelegate<NSObject>
-(void)gameNoticHeaderViewStartDateSelected:(RH_MPGameNoticHeaderView *)view DefaultDate:(NSDate*)defaultDate ;
-(void)gameNoticHeaderViewEndDateSelected:(RH_MPGameNoticHeaderView *)view DefaultDate:(NSDate*)defaultDate ;
@end
@interface RH_MPGameNoticHeaderView : UIView
@property (nonatomic,strong) NSDate *startDate ;
@property (nonatomic,strong) NSDate *endDate ;
@property(nonatomic,weak)id<MPGameNoticHeaderViewDelegate>delegate;
@property(nonatomic,copy)GameNoticHeaderViewBlock block;
@property(nonatomic,copy)GameNoticHeaderViewKuaixuanBlock kuaixuanBlock;
@property (weak, nonatomic) IBOutlet UILabel *gameTypeLabel;

@end
