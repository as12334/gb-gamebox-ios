//
//  AppDelegate.h
//  webViewtest
//
//  Created by 牛奶哈哈的小屋 on 2017/3/6.
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

//更新版本号
@property NSString *versionCode;
@property NSString *md5;
@property NSString *code;
@property NSString *s;

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) NSString *bossUrl;
@property (strong,nonatomic) NSString *domain;
@property (strong,nonatomic) NSString *customUrl;
@property BOOL isLogin;
@property (strong,nonatomic) NSString *servicePath;
@property int loginId;
@property BOOL goLogin;
@property NSString *goBackURL;

//mine
@property int gotoIndex;
@property (strong,nonatomic) NSString *gotoIndexUrl;

@end

