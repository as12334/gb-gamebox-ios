//
//  UIScrollView+ScrollToBorder.m
//  TaskTracking
//
//  Created by jinguihua on 2017/6/8.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "UIScrollView+ScrollToBorder.h"
#import "CLBorderProtocol.h"

@implementation UIScrollView (ScrollToBorder)

- (void)scrollToBoder:(CLScrollBorder)border {
    [self scrollToBoder:border animated:NO];
}

- (void)scrollToBoder:(CLScrollBorder)border animated:(BOOL)animated
{
    if (border) {

        CGPoint contentOffset = self.contentOffset;
        UIEdgeInsets contentInset = self.contentInset;

        if (border & CLBorderMarkTop) {
            contentOffset.y = - contentInset.top;
        }else if (border & CLBorderMarkBottom) {

            CGSize  contentSize = self.contentSize;
            CGSize  size = self.bounds.size;

            if (contentSize.height + contentInset.top + contentInset.bottom < size.height) {
                contentOffset.y = - contentInset.top;
            }else {
                contentOffset.y = contentSize.height + contentInset.bottom - size.height;
            }
        }

        if (border & CLBorderMarkLeft) {
            contentOffset.x = - contentInset.left;
        }else if (border & CLBorderMarkRight) {

            CGSize  contentSize = self.contentSize;
            CGSize  size = self.bounds.size;

            if (contentSize.width + contentInset.left + contentInset.right < size.width) {
                contentOffset.x = - contentInset.left;
            }else {
                contentOffset.x = contentSize.width + contentInset.right - size.width;
            }
        }

        [self setContentOffset:contentOffset animated:animated];
    }
}

@end

