//
//  RH_DatePickerView.h
//  gameBoxEx
//
//  Created by lewis on 2018/6/1.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RH_DatePickerView;
typedef void (^chooseDateFinishBlock)(NSDate *date);
@interface RH_DatePickerView : UIView
@property(nonatomic,copy)chooseDateFinishBlock chooseDateBlock;
//遮罩层
@property(nonatomic,strong,readonly) UIView *coverView;
+(RH_DatePickerView *)shareCalendarView:(NSString *)title defaultDate:(NSDate*)date;
@end
