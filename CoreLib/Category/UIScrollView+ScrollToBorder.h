//
//  UIScrollView+ScrollToBorder.h
//  TaskTracking
//
//  Created by jinguihua on 2017/6/8.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, CLScrollBorder) {
    CLScrollBorderTop    = 1 << 0,
    CLScrollBorderBottom = 1 << 1,
    CLScrollBorderLeft   = 1 << 2,
    CLScrollBorderRight  = 1 << 3
};

@interface UIScrollView (ScrollToBorder)

- (void)scrollToBoder:(CLScrollBorder)border;
- (void)scrollToBoder:(CLScrollBorder)border animated:(BOOL)animated;

@end
