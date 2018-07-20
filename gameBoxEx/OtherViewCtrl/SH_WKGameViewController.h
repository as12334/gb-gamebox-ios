//
//  SH_WKGameViewController.h
//  GameBox
//
//  Created by shin on 2018/7/15.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_BasicPageLoadViewController.h"

typedef void(^WKGameWebViewControllerClose)(void);//游戏页面关闭
typedef void(^WKGameWebViewControllerCloseAndShowLogin)(void);//游戏页面关闭并展示登录

@interface SH_WKGameViewController : RH_BasicPageLoadViewController

@property (nonatomic, strong) NSString *url;
- (void)close:(WKGameWebViewControllerClose)closeBlock;
- (void)closeAndShowLogin:(WKGameWebViewControllerClose)closeAndShowLoginBlock;

@end
