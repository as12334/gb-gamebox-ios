//
//  UIImage+Alpha.h
//  CoreLib
//
//  Created by apple pro on 2016/11/22.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (Alpha)
/**
 *  @brief  是否有alpha通道
 *
 *  @return 是否有alpha通道
 */
- (BOOL)hasAlpha;
/**
 *  @brief  如果没有alpha通道 增加alpha通道
 *
 *  @return 如果没有alpha通道 增加alpha通道
 */
- (UIImage *)imageWithAlpha;
/**
 *  @brief  增加透明边框
 *
 *  @param borderSize 边框尺寸
 *
 *  @return 增加透明边框后的图片
 */
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;


//http://stackoverflow.com/questions/6521987/crop-uiimage-to-alpha?answertab=oldest#tab-top
/**
 *  @brief  裁切含透明图片为最小大小
 *
 *  @return 裁切后的图片
 */
- (UIImage *)trimmedBetterSize;

@end
