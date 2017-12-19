//
//  AppDelegate.h
//  gameBoxEx
//
//  Created by luis on 2017/10/6.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "CLAPPDelegate.h"

UIKIT_EXTERN NSString  *NT_LoginStatusChangedNotification ;

@interface RH_APPDelegate : CLAPPDelegate
@property(nonatomic,readonly,strong)  NSString *domain  ;
@property(nonatomic,readonly,strong)  NSString *servicePath ;//客服url ;
@property(strong,nonatomic)  NSString *customUrl;
@property(strong,nonatomic)  NSString *logoutUrl ;
@property(strong,nonatomic)  NSString *goBackURL;
//mine
@property (strong,nonatomic) NSString *gotoIndexUrl;
@property (nonatomic,assign,readonly) BOOL isLogin;

//wkweb cookie
@property (nonatomic,strong) NSDictionary *dictUserAgent ;

-(void)updateDomain:(NSString*)domain ;
-(void)updateServicePath:(NSString*)servicePath ;
-(void)updateLoginStatus:(BOOL)loginStatus ;

@end

