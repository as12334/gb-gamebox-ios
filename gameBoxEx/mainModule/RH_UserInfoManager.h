//
//  RH_UserInfoManager.h
//  TaskTracking
//
//  Created by apple pro on 2017/2/19.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RH_UserBalanceGroupModel.h"

#define  RHNT_UserInfoManagerBalanceChangedNotification           @"UserInfoManagerBalanceChangedNotification"
#define HasLogin                    [[RH_UserInfoManager shareUserManager] hasLogin]
#define UserBalanceInfo             [RH_UserInfoManager shareUserManager].userBalanceGroupInfo

typedef void(^AutoLoginCompletation)(BOOL result) ;

@interface RH_UserInfoManager : NSObject
+(instancetype)shareUserManager ;
@property(nonatomic,strong,readonly) RH_UserBalanceGroupModel *userBalanceGroupInfo ;
-(BOOL)hasLogin ;
-(void)setUserBalanceInfo:(RH_UserBalanceGroupModel *)userBalanceInfo ;

@end
