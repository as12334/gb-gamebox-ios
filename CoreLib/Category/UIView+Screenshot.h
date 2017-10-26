//
//  UIView+Screenshot.h
//  TaskTracking
//
//  Created by apple pro on 2017/2/21.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Screenshot)

- (UIImage *)convertViewToImage;
- (UIImage *)convertViewToImageWithRetina:(BOOL)retina;

@end
