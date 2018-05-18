//
//  RH_Crash.h
//  gameBoxEx
//
//  Created by lewis on 2018/4/24.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RH_Crash : NSObject
@property(nonatomic,strong)NSString *siteId;
@property(nonatomic,strong)NSString *userNameStr;
@property(nonatomic,strong)NSString *lastLoginTimeStr;
@property(nonatomic,strong)NSString *domainStr;
@property(nonatomic,strong)NSString *ipStr;
@property(nonatomic,strong)NSString *errorMessageStr;
@property(nonatomic,strong)NSString *codesStr;
@property(nonatomic,strong)NSString *markStr;
@property(nonatomic,strong)NSString *isAppStr;
@property(nonatomic,strong)NSString *versionNameStr;
@property(nonatomic,strong)NSString *channelStr;
@property(nonatomic,strong)NSString *syscodeStr;
@property(nonatomic,strong)NSString *brandsStr;
@property(nonatomic,strong)NSString *phoneModelStr;
void uncaughtExceptionHandler(NSException *exception);

@end
