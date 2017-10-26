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

@end
