//
//  UIFont+CLCategory.m
//  CoreLib
//
//  Created by apple pro on 2016/11/22.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "UIFont+CLCategory.h"

@implementation UIFont (CLCategory)
+ (instancetype)lightSystemFontWithSize:(CGFloat)fontSize
{
    UIFontDescriptor * fd = [UIFontDescriptor fontDescriptorWithFontAttributes:@{@"NSCTFontUIUsageAttribute" : @"CTFontLightUsage"}];
    return [UIFont fontWithDescriptor:fd size:fontSize];
}

@end
