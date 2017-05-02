//
//  BaseVC.h
//  webViewtest
//
//  Created by deve dawoo on 2017/4/11.
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseVC : UIViewController

//字符串非空判断
- (BOOL) isBlankString:(NSString *)string;
//Toast
- (void) addToastWithString:(NSString *)string inView:(UIView *)view;
- (void) removeToastWithView:(NSTimer *)timer;
- (void) stopLoadWV:(UIWebView *)wv;
@end
