//
//  UIView+RHFrame.m
//  gameBoxEx
//
//  Created by jun on 2018/9/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "UIView+RHFrame.h"

@implementation UIView (RHFrame)
- (CGFloat)rb_height
{
    return self.frame.size.height;
}

- (CGFloat)rb_width
{
    return self.frame.size.width;
}

- (void)setRb_height:(CGFloat)rb_height {
    CGRect frame = self.frame;
    frame.size.height = rb_height;
    self.frame = frame;
}
- (void)setRb_width:(CGFloat)rb_width {
    CGRect frame = self.frame;
    frame.size.width = rb_width;
    self.frame = frame;
}

- (CGFloat)rb_x
{
    return self.frame.origin.x;
}

- (void)setRb_x:(CGFloat)rb_x {
    CGRect frame = self.frame;
    frame.origin.x = rb_x;
    self.frame = frame;
}


- (CGFloat)rb_y
{
    return self.frame.origin.y;
}


- (void)setRb_y:(CGFloat)rb_y {
    CGRect frame = self.frame;
    frame.origin.y = rb_y;
    self.frame = frame;
}


- (void)setRb_centerX:(CGFloat)rb_centerX {
    CGPoint center = self.center;
    center.x = rb_centerX;
    self.center = center;
}

- (CGFloat)rb_centerX
{
    return self.center.x;
}


- (void)setRb_centerY:(CGFloat)rb_centerY {
    CGPoint center = self.center;
    center.y = rb_centerY;
    self.center = center;
}

- (CGFloat)rb_centerY
{
    return self.center.y;
}
- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}
- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}
- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
@end
