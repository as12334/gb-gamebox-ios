//
//  UpdateStatusCacheManager.m
//  gameBoxEx
//
//  Created by shin on 2018/6/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "UpdateStatusCacheManager.h"
#import "RH_ServiceRequest.h"
#import "RH_UpdatedVersionModel.h"
#import "MacroDef.h"
#import "coreLib.h"

#define GB_UpdateStatus_VALID_CACHE_TIME 1*60*60 //有效期小时

@interface UpdateStatusCacheManager ()

@property (nonatomic, strong) RH_ServiceRequest *serviceRequest;

@end

@implementation UpdateStatusCacheManager

+ (instancetype)sharedManager
{
    static UpdateStatusCacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[UpdateStatusCacheManager alloc] init];
        }
    });
    return manager;
}

-(RH_ServiceRequest*)serviceRequest
{
    if (!_serviceRequest){
        _serviceRequest = [[RH_ServiceRequest alloc] init] ;
    }
    
    return _serviceRequest ;
}

- (NSDictionary *)updateStatusInfo
{
    NSDictionary *ipsCacheDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"GB_UPDATESTATUS_CACHE_DATA"];
    return ipsCacheDic;
}

- (BOOL)isUpdateStatusValid
{
    NSDictionary *updateStatusDic = [self updateStatusInfo];
    if (updateStatusDic != nil) {
        NSTimeInterval cachingTime = [[updateStatusDic objectForKey:@"cachingTime"] doubleValue];
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        
        BOOL status = [updateStatusDic objectForKey:@"status"];
        if (status==YES && currentTime-cachingTime < GB_UpdateStatus_VALID_CACHE_TIME) {
            //有效
            return YES;
        }
        else
        {
            //失效了
            return NO;
        }
    }
    
    //没有值 所以默认无效
    return NO;
}

- (void)refreshUpdateStatus:(BOOL)status
{
    NSTimeInterval cachingTime =  [[NSDate date] timeIntervalSince1970];
    NSDictionary *ipsCacheDic = @{
                                  @"status":@(status),
                                  @"cachingTime":@(cachingTime),
                                  };
    [[NSUserDefaults standardUserDefaults] setObject:ipsCacheDic forKey:@"GB_UPDATESTATUS_CACHE_DATA"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showUpdateAlert:(GBSkipUpdateShow)skip
{
    __weak typeof(self) weakSelf = self;

    [self.serviceRequest startV3UpdateCheck];
    self.serviceRequest.successBlock = ^(RH_ServiceRequest *serviceRequest, ServiceRequestType type, id data) {
        RH_UpdatedVersionModel *updateModel = ConvertToClassPointer(RH_UpdatedVersionModel, data);
        
        if(updateModel.mVersionCode<=[RH_APP_VERCODE integerValue]&&[updateModel.mForceVersion integerValue]<=[RH_APP_VERCODE integerValue]){
            //本地版本号和强制更新版本号都小于当前版本号 则 直接跳过
            if (skip)
            {
                skip();
            }
            return;
        }
        else if (updateModel.mVersionCode>[RH_APP_VERCODE integerValue]&&[updateModel.mForceVersion integerValue]<=[RH_APP_VERCODE integerValue])
        {
            //本地版本号比线上版本号要小 且
            //本地版本号大于强制更新版本号
            //需要弹框 但可以跳过
            UIAlertView *alert =
            [UIAlertView alertWithCallBackBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    //点击了忽略更新
                    //直接跳过
                    if (skip) {
                        skip();
                    }
                }
                else
                {
                    NSString *downLoadIpaUrl = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=https://%@%@/%@/app_%@_%@.plist",updateModel.mAppUrl,updateModel.mVersionName,CODE,CODE,updateModel.mVersionName];
                    NSURL *ipaUrl = [NSURL URLWithString:[downLoadIpaUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    [[UIApplication sharedApplication] openURL:ipaUrl];
                    exit(0);
                }
            }
                                          title:@"发现新版本啦"
                                        message:updateModel.mMemo
                               cancelButtonName:@"忽略更新"
                              otherButtonTitles:@"下载更新", nil];
            [alert show];
            [weakSelf refreshUpdateStatus:YES];
        }
        else if (updateModel.mVersionCode>[RH_APP_VERCODE integerValue]&&[updateModel.mForceVersion integerValue]>[RH_APP_VERCODE integerValue])
        {
            //本地版本号小于线上版本号 且
            //本地版本号小于线上强制更新版本号
            //需要弹框 不能跳过
            UIAlertView *alert =
            [UIAlertView alertWithCallBackBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    //点击了忽略更新
                    //直接退出app
                    exit(0);
                }
                else
                {
                    NSString *downLoadIpaUrl = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=https://%@%@/%@/app_%@_%@.plist",updateModel.mAppUrl,updateModel.mVersionName,CODE,CODE,updateModel.mVersionName];
                    NSURL *ipaUrl = [NSURL URLWithString:[downLoadIpaUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    [[UIApplication sharedApplication] openURL:ipaUrl];
                    exit(0);
                }
            }
                                          title:@"发现新版本啦"
                                        message:updateModel.mMemo
                               cancelButtonName:@"退出"
                              otherButtonTitles:@"下载更新", nil];
            [alert show];
            [weakSelf refreshUpdateStatus:YES];
        }
    };
    
    self.serviceRequest.failBlock = ^(RH_ServiceRequest *serviceRequest, ServiceRequestType type, NSError *error) {
        //检测失败则直接跳过
        if (skip) {
            skip();
        }
    };
}

@end
