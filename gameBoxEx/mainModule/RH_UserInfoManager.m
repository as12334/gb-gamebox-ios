//
//  RH_UserInfoManager.m
//  TaskTracking
//
//  Created by apple pro on 2017/2/19.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_UserInfoManager.h"
#import "CLDocumentCachePool.h"
#import "MacroDef.h"
#import "RH_ServiceRequest.h"
#import "coreLib.h"
#import "RH_APPDelegate.h"

#define  key_screenlockFlag                             @"key_screenlockFlag"
#define  key_screenlockPassword                          @"key_screenlockPassword"

@interface RH_UserInfoManager ()<RH_ServiceRequestDelegate>
@property(nonatomic,strong,readonly) RH_ServiceRequest * serviceRequest;
@property(nonatomic,copy)  AutoLoginCompletation autoLoginCompletation ;
@end

@implementation RH_UserInfoManager
@synthesize serviceRequest = _serviceRequest;
@synthesize userBalanceGroupInfo = _userBalanceGroupInfo ;
@synthesize mineGroupInfo = _mineGroupInfo ;

+(instancetype)shareUserManager
{
    static RH_UserInfoManager * _shareUserManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareUserManager = [[RH_UserInfoManager alloc] init];
        
    });
    
    return _shareUserManager ;
}

#pragma mark- userBalanceGroupInfo
-(RH_UserBalanceGroupModel *)userBalanceGroupInfo
{
    return _userBalanceGroupInfo ;
}

-(void)setUserBalanceInfo:(RH_UserBalanceGroupModel *)userBalanceInfo
{
    _userBalanceGroupInfo = userBalanceInfo ;
    [[NSNotificationCenter defaultCenter] postNotificationName:RHNT_UserInfoManagerBalanceChangedNotification object:nil] ;
}

#pragma mark - mineGroupInfo
-(RH_MineGroupInfoModel *)mineGroupInfo{
    return _mineGroupInfo ;
}

-(void)setMineGroupInfo:(RH_MineGroupInfoModel *)mineGroupInfo
{
    _mineGroupInfo = mineGroupInfo ;
    [[NSNotificationCenter defaultCenter] postNotificationName:RHNT_UserInfoManagerMineGroupChangedNotification object:nil] ;
}


-(BOOL)hasLogin
{
    RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
    return appDelegate.isLogin ;
}

#pragma mark -
-(BOOL)isScreenLock
{
    NSString *bFlag = [[CLDocumentCachePool shareTempCachePool] cacheKeyedUnArchiverRootObjectForKey:key_screenlockFlag expectType:[NSString class]] ;
    return [bFlag boolValue] ;
}

-(void)updateScreenLockFlag:(BOOL)lock
{
    [[CLDocumentCachePool shareTempCachePool] cacheKeyedArchiverDataWithRootObject:lock?@"1":@"0"
                                                                            forKey:key_screenlockFlag
                                                                             async:YES] ;
}

#pragma mark-
-(NSString *)screenLockPassword
{
    NSString *screenLock = [[CLDocumentCachePool shareTempCachePool] cacheKeyedUnArchiverRootObjectForKey:key_screenlockPassword
                                                                                               expectType:[NSString class]] ;
    return screenLock ;
}

-(void)updateScreenLockPassword:(NSString *)lockPassrod
{
    if (lockPassrod){
        [[CLDocumentCachePool shareTempCachePool] cacheKeyedArchiverDataWithRootObject:lockPassrod
                                                                                forKey:key_screenlockPassword
                                                                                 async:YES] ;
    }
}

#pragma mark-
- (RH_ServiceRequest *)serviceRequest
{
    if (!_serviceRequest) {
        _serviceRequest = [[RH_ServiceRequest alloc] init];
        _serviceRequest.delegate = self;
    }
    
    return _serviceRequest;
}

#pragma mark-
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{

}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{

}

#pragma mark-
-(void)autoLogin:(AutoLoginCompletation) completation
{
//    self.autoLoginCompletation = completation ;
//    if (self.hasLogin){
//        if (NetworkAvailable()){
//            [self.serviceRequest startLogin:self.userModel.mUserName Password:self.userModel.mUserPassword] ;
//        }else{
//            self.autoLoginCompletation(TRUE) ;
//        }
//    }else{
//        self.autoLoginCompletation(FALSE) ;
//    }
}

@end
