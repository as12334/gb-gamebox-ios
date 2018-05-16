//
//  CLCalendarView.h
//  TaskTracking
//
//  Created by jinguihua on 2017/2/22.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLBorderView.h"

@class CLCalendarView ;
@protocol CLCalendarViewDelegate <NSObject>
@optional
-(void)calendarViewTouchConfirmButton:(CLCalendarView*)calendarView SelectDate:(NSDate*)date ;
-(void)calendarViewTouchCancelButton:(CLCalendarView*)calendarView ;

@end

@interface CLCalendarView : CLBorderView
+(CLCalendarView*)shareCalendarView:(NSString*)title
                        defaultDate:(NSString*)defaultDate  //yyyy-MM-dd HH:mm
                            MinDate:(NSDate*)minDate
                            MaxDate:(NSDate*)maxDate ;

@property(nonatomic,weak) id<CLCalendarViewDelegate> delegate ;
@end
