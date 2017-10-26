//
//  CLButton.h
//  TaskTracking
//
//  Created by jinguihua on 2017/2/27.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLButton : UIButton
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
- (UIColor *)backgroundColorForState:(UIControlState)state;

//是否自动调节背景色
@property(nonatomic) BOOL autoAdjustBackgroundColor;
- (UIColor *)showingBackgroundColorForState:(UIControlState)state;

//计算内建大小时单元扩张的比例，单位量，默认为CGSizeZero
@property(nonatomic) CGSize intrinsicSizeExpansionScale;
////计算内建大小时单元扩张的比例长度，绝对值，默认为CGSizeZero
@property(nonatomic) CGSize intrinsicSizeExpansionLength;

//改变触摸状态时调用改block
@property(nonatomic,copy) void(^buttonDidChangeTouchStateBlock)(CLButton * button, BOOL isTouch);

@end
