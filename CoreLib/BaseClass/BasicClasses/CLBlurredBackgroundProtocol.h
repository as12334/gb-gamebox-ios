//
//  CLBlurredBackgroundProtocol.h
//  TaskTracking
//
//  Created by apple pro on 2017/2/21.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#ifndef CLBlurredBackgroundProtocol_h
#define CLBlurredBackgroundProtocol_h

//----------------------------------------------------------

typedef NS_ENUM(NSInteger,CLBlurredBackgroundType) {
    CLBlurredBackgroundTypeNone,    //无
    CLBlurredBackgroundTypeStatic   //静态

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    ,CLBlurredBackgroundTypeDynamic  //动态
#endif

};

//----------------------------------------------------------

typedef UIImage *(^MyApplyBlurredEffectBlock)(UIImage *image);

//----------------------------------------------------------

@protocol CLBlurredBackgroundProtocol

//毛玻璃背景类型
@property(nonatomic) CLBlurredBackgroundType blurredBackgroundType;
//添加毛玻璃效果的block,对于静态毛玻璃效果有效
@property(nonatomic,copy) MyApplyBlurredEffectBlock applyBlurredEffectBlock;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

//对于动态毛玻璃有效
@property(nonatomic) UIBlurEffectStyle blurEffectStyle;
//毛玻璃透明度
@property(nonatomic) CGFloat blurEffectAlpha;

#endif


@end


#endif /* CLBlurredBackgroundProtocol_h */
