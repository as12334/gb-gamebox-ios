//
//  UIView+Screenshot.m
//  TaskTracking
//
//  Created by apple pro on 2017/2/21.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "UIView+Screenshot.h"

@implementation UIView (Screenshot)

- (UIImage *)convertViewToImage{
    return [self convertViewToImageWithRetina:YES];
}

- (UIImage *)convertViewToImageWithRetina:(BOOL)retina
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, retina ? 0.f : 1.f);

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
#else
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
#endif

    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

@end

