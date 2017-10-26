//
//  CircleProgressView.h
//  CircleProgress
//
//  Created by ln on 15/8/4.
//  Copyright (c) 2015年 xcgdb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIView

@property (nonatomic,assign) CGFloat lineWitdh; //线条宽度
@property (nonatomic,assign) CGFloat startValue; //初始值
@property (nonatomic,assign) CGFloat changeValue; //改变值
@property (nonatomic,strong) UIColor *lineColor; // 线条颜色
@property (nonatomic,strong) UILabel *progressText; //进度值



@end
