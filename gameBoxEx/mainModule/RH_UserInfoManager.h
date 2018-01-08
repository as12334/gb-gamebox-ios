//
//  RH_UserInfoManager.h
//  TaskTracking
//
//  Created by apple pro on 2017/2/19.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RH_UserBalanceGroupModel.h"
#import "RH_MineGroupInfoModel.h"
#import "RH_UserSafetyCodeModel.h"

#define  RHNT_UserInfoManagerBalanceChangedNotification           @"UserInfoManagerBalanceChangedNotification"
#define  RHNT_UserInfoManagerMineGroupChangedNotification         @"UserInfoManagerMineGroupChangedNotification"

#define HasLogin                    [[RH_UserInfoManager shareUserManager] hasLogin]
#define UserBalanceInfo             [RH_UserInfoManager shareUserManager].userBalanceGroupInfo
#define MineGroupInfo               [RH_UserInfoManager shareUserManager].mineGroupInfo
#define UserSafetyInfo              [RH_UserInfoManager shareUserManager].userSafetyInfo

typedef void(^AutoLoginCompletation)(BOOL result) ;

@interface RH_UserInfoManager : NSObject
+(instancetype)shareUserManager ;
@property(nonatomic,strong,readonly) RH_UserBalanceGroupModel *userBalanceGroupInfo ;
@property(nonatomic,strong,readonly) RH_MineGroupInfoModel *mineGroupInfo ;
@property(nonatomic,strong,readonly) RH_UserSafetyCodeModel *userSafetyInfo ;

-(BOOL)hasLogin ;
-(void)setUserBalanceInfo:(RH_UserBalanceGroupModel *)userBalanceInfo ;
-(void)setMineGroupInfo:(RH_MineGroupInfoModel *)mineGroupInfo ;
-(void)setUserSafetyInfo:(RH_UserSafetyCodeModel *)userSafetyInfo ;

///----app 层 相关开关
@property (nonatomic,assign,readonly) BOOL isScreenLock ;
@property (nonatomic,strong,readonly) NSString *screenLockPassword ;
-(void)updateScreenLockFlag:(BOOL)lock ;
-(void)updateScreenLockPassword:(NSString*)lockPassrod ;

@end
