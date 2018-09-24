//
//  AppDelegate.h
//  gameBoxEx
//
//  Created by luis on 2017/10/6.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "CLAPPDelegate.h"
//6474cf94eea676728f54dad1      119
//c90cbc31f7b5b2d38502fad8      270
static NSString *appKey = @"6474cf94eea676728f54dad1";
static NSString *channel = @"iOS";
static BOOL isProduction = TRUE;
UIKIT_EXTERN NSString  *NT_LoginStatusChangedNotification ;

@interface RH_APPDelegate : CLAPPDelegate
@property(nonatomic,readonly,strong)  NSString *domain  ;
@property(nonatomic,readonly,strong)NSString *headerDomain;
@property(nonatomic,readonly,strong)NSString *demainName;//保存检测通过的域名
@property(nonatomic,readonly,strong)  NSString *servicePath ;//客服url ;
@property(strong,nonatomic)  NSString *customUrl;
@property(strong,nonatomic)  NSString *logoutUrl ;
@property(strong,nonatomic)  NSString *goBackURL;
//mine
@property (strong,nonatomic) NSString *gotoIndexUrl;
@property (nonatomic,assign,readonly) BOOL isLogin;
//是否有新的系统信息
@property (nonatomic,strong)NSString *whetherNewSystemNotice;

//wkweb cookie
@property (nonatomic,strong) NSDictionary *dictUserAgent ;
//check type
@property (nonatomic,strong)NSString *checkType;
@property(assign,nonatomic)  BOOL openForgetPsw;

-(void)updateDomain:(NSString*)domain ;
-(void)updateServicePath:(NSString*)servicePath ;
-(void)updateLoginStatus:(BOOL)loginStatus ;
-(void)updateHeaderDomain:(NSString *)headerDomain;
-(void)updateDomainName:(NSString *)domainName;
@end

