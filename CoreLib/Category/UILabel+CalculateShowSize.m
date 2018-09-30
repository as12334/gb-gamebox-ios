//
//  UILabel+CalculateShowSize.m
//  CoreLib
//
//  Created by apple pro on 2016/11/22.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "UILabel+CalculateShowSize.h"
#import "TTTAttributedLabel.h"

@implementation UILabel (CalculateShowSize)
+ (CGSize)showSizeWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width {
    return [self showSizeWithText:text font:font width:width numberOfLines:0];

}

+ (CGSize)showSizeWithText:(NSString *)text
                      font:(UIFont *)font
                     width:(CGFloat)width
             numberOfLines:(NSUInteger)numberOfLines
{
    if (text.length == 0) {
        return CGSizeZero;
    }

    return [self showSizeWithAttributedText:[[NSAttributedString alloc] initWithString:text]
                                defaultFont:font
                                constraints:CGSizeMake(width, CGFLOAT_MAX)
                              numberOfLines:numberOfLines];

}


+ (CGSize)showSizeWithAttributedText:(NSAttributedString *)attributedText
                         defaultFont:(UIFont *)defaultFont
                               width:(CGFloat)width
{
    return [self showSizeWithAttributedText:attributedText
                                defaultFont:defaultFont
                                constraints:CGSizeMake(width, CGFLOAT_MAX)
                              numberOfLines:0];
}

+ (CGSize)showSizeWithAttributedText:(NSAttributedString *)attributedText
                         defaultFont:(UIFont *)defaultFont
                         constraints:(CGSize)size
                       numberOfLines:(NSUInteger)numberOfLines
{
    if (attributedText.length == 0) {
        return CGSizeZero;
    }

    UILabel * label = [[self alloc] initWithFrame:CGRectZero];
    label.numberOfLines = numberOfLines;
    label.preferredMaxLayoutWidth = size.width;
    label.font = defaultFont;

    if ([label isKindOfClass:[TTTAttributedLabel class]]) {

        [(TTTAttributedLabel *)label setText:attributedText afterInheritingLabelAttributesAndConfiguringWithBlock:nil];

    }else {

        label.attributedText = attributedText;
    }

    CGSize intrinsicContentSize = [label intrinsicContentSize];
    return CGSizeMake(MIN(intrinsicContentSize.width, size.width),
                      MIN(intrinsicContentSize.height, size.height));
}


-(void)setTextWithFirstString:(NSString *)firstString
                 SecondString:(NSString *)secondString
                     FontSize:(CGFloat)fontSize
                        Color:(UIColor *)color{
    
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:firstString];
    //富文本的属性通过字典的形式传入
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:fontSize],NSFontAttributeName,//字体
                                   color,NSForegroundColorAttributeName,//字体颜色
                                   nil ];
    NSRange range = NSMakeRange(0, 0);
    if (firstString&&secondString) {
        range  = [firstString rangeOfString:secondString];
    }
    
    //统一设置富文本对象的属性
    [attributedStr addAttributes:attributeDict range:range];
    self.attributedText = attributedStr;
}

+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                     context:nil];
    return rect.size.width;
}
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect.size.height;
}

@end
