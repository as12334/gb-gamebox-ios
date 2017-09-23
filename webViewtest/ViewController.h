//
//  ViewController.h
//  webViewtest
//
//  Created by 牛奶哈哈的小屋 on 2017/3/6.
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface ViewController : BaseVC<UIWebViewDelegate>//设置代理

/*!
 * 切换TAB
 */
- (void) changeTab:(NSString*) target;
- (void) gotoCustom;
/*!
 * 彩票试玩
 */
- (void) demoEnter:(NSString *) line;

- (void) reload;
@end
