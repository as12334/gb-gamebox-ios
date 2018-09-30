//
//  UILabel+CalculateShowSize.h
//  CoreLib
//
//  Created by apple pro on 2016/11/22.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CalculateShowSize)
+ (CGSize)showSizeWithText:(NSString *)text
                      font:(UIFont *)font
                     width:(CGFloat)width;

+ (CGSize)showSizeWithText:(NSString *)text
                      font:(UIFont *)font
                     width:(CGFloat)width
             numberOfLines:(NSUInteger)numberOfLines;


+ (CGSize)showSizeWithAttributedText:(NSAttributedString *)attributedText
                         defaultFont:(UIFont *)font
                               width:(CGFloat)width;

+ (CGSize)showSizeWithAttributedText:(NSAttributedString *)attributedText
                         defaultFont:(UIFont *)font
                         constraints:(CGSize)size
                       numberOfLines:(NSUInteger)numberOfLines;

-(void)setTextWithFirstString:(NSString *)firstString
                 SecondString:(NSString *)secondString
                     FontSize:(CGFloat)fontSize
                        Color:(UIColor *)color;

//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
+ (CGFloat)getWidthWithText:(NSString *)text
                     height:(CGFloat)height
                       font:(CGFloat)font;

//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
+ (CGFloat)getLabelHeightWithText:(NSString *)text
                            width:(CGFloat)width
                             font: (CGFloat)font;

@end
