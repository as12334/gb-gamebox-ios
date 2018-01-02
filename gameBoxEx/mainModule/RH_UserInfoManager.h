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

#define  RHNT_UserInfoManagerBalanceChangedNotification           @"UserInfoManagerBalanceChangedNotification"
#define  RHNT_UserInfoManagerMineGroupChangedNotification         @"UserInfoManagerMineGroupChangedNotification"

#define HasLogin                    [[RH_UserInfoManager shareUserManager] hasLogin]
#define UserBalanceInfo             [RH_UserInfoManager shareUserManager].userBalanceGroupInfo
#define MineGroupInfo             [RH_UserInfoManager shareUserManager].mineGroupInfo

typedef void(^AutoLoginCompletation)(BOOL result) ;

@interface RH_UserInfoManager : NSObject
+(instancetype)shareUserManager ;
@property(nonatomic,strong,readonly) RH_UserBalanceGroupModel *userBalanceGroupInfo ;
@property(nonatomic,strong,readonly) RH_MineGroupInfoModel *mineGroupInfo ;

-(BOOL)hasLogin ;
-(void)setUserBalanceInfo:(RH_UserBalanceGroupModel *)userBalanceInfo ;
-(void)setMineGroupInfo:(RH_MineGroupInfoModel *)mineGroupInfo ;

@end
