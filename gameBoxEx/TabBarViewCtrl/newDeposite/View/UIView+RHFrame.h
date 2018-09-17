//
//  UIView+RHFrame.h
//  gameBoxEx
//
//  Created by jun on 2018/9/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RHFrame)
@property (nonatomic, assign) CGFloat rb_centerX;
@property (nonatomic, assign) CGFloat rb_centerY;

@property (nonatomic, assign) CGFloat rb_x;
@property (nonatomic, assign) CGFloat rb_y;
@property (nonatomic, assign) CGFloat rb_width;
@property (nonatomic, assign) CGFloat rb_height;

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
@end
