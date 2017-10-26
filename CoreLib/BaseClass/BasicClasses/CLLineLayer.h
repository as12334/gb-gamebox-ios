//
//  CLLineLayer.h
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

//线的风格
typedef NS_ENUM(NSInteger, CLLineStyle) {
    CLLineStyleNormal,
    CLLineStyleGradient
};


@interface CLLineLayer : CALayer

@property(nonatomic) CLLineStyle lineStyle;

@property(nonatomic) CGFloat lineWidth;
@property(nonatomic,strong) UIColor * lineColor;

@property(nonatomic) CGPoint startPoint,endPoint;

//默认都为0.5f
@property(nonatomic) CGFloat gradientStartLocation,gradientEndLocation;

@end
