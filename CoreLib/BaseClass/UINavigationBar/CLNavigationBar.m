//
//  CLNavigationBar.m
//  cpLottery
//
//  Created by luis on 2017/11/6.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "CLNavigationBar.h"
#import "UIView+FrameSize.h"

@implementation CLNavigationBar

- (void)layoutSubviews {
    [super layoutSubviews];
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
//        self.hx_h = kNavigationBarHeight;
        for (UIView *view in self.subviews)
        {
            if([NSStringFromClass([view class]) containsString:@"Background"]) {
                view.frame = self.bounds;
            }else if ([NSStringFromClass([view class]) containsString:@"ContentView"]) {
                CGRect frame = view.frame;
                frame.origin.y = self.frameHeigh - 44;
                frame.size.height = self.bounds.size.height - frame.origin.y;
                view.frame = frame;
            }
        }
    }
#endif
}

@end
