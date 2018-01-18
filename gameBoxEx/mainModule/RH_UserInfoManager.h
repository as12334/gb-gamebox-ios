//
//  RH_UserInfoManager.h
//  TaskTracking
//
//  Created by apple pro on 2017/2/19.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RH_UserBalanceGroupModel.h"
#import "RH_UserSafetyCodeModel.h"
#import "RH_MineInfoModel.h"
#import "RH_BankInfoModel.h"

#define  RHNT_UserInfoManagerBalanceChangedNotification           @"UserInfoManagerBalanceChangedNotification"
#define  RHNT_UserInfoManagerMineGroupChangedNotification         @"UserInfoManagerMineGroupChangedNotification"

#define HasLogin                    [[RH_UserInfoManager shareUserManager] hasLogin]
#define UserBalanceInfo             [RH_UserInfoManager shareUserManager].userBalanceGroupInfo
#define UserSafetyInfo              [RH_UserInfoManager shareUserManager].userSafetyInfo
#define MineSettingInfo             [RH_UserInfoManager shareUserManager].mineSettingInfo
#define BankList                    [RH_UserInfoManager shareUserManager].bankList

typedef void(^AutoLoginCompletation)(BOOL result) ;

@interface RH_UserInfoManager : NSObject
+(instancetype)shareUserManager ;
@property(nonatomic,strong,readonly) RH_UserBalanceGroupModel *userBalanceGroupInfo ;
@property(nonatomic,strong,readonly) RH_UserSafetyCodeModel *userSafetyInfo ;
@property(nonatomic,strong,readonly) RH_MineInfoModel *mineSettingInfo ;
@property(nonatomic,strong,readonly) NSArray<RH_BankInfoModel*> *bankList ;

-(BOOL)hasLogin ;
-(void)setUserBalanceInfo:(RH_UserBalanceGroupModel *)userBalanceInfo ;
-(void)setUserSafetyInfo:(RH_UserSafetyCodeModel *)userSafetyInfo ;
-(void)setMineSettingInfo:(RH_MineInfoModel *)mineSettingInfo ;
-(void)setBankList:(NSArray<RH_BankInfoModel *> *)bankList ;

///----app 层 相关开关
@property (nonatomic,assign,readonly) BOOL isVoiceSwitch    ; //声音开关
@property (nonatomic,assign,readonly) BOOL isScreenLock     ; //锁屏手势开关
@property (nonatomic,strong,readonly) NSString *screenLockPassword ; //锁屏手势密码

-(void)updateVoickSwitchFlag:(BOOL)bSwitch  ;
-(void)updateScreenLockFlag:(BOOL)lock      ;
-(void)updateScreenLockPassword:(NSString*)lockPassrod ;
-(NSString*)bankNameWithCode:(NSString*)bankCode ;
@end
