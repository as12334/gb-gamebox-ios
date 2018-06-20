//
//  RH_UpdatedVersionModel.m
//  gameBoxEx
//
//  Created by luis on 2017/10/27.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_UpdatedVersionModel.h"
#import "coreLib.h"
#import "RH_API.h"

@implementation RH_UpdatedVersionModel

-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mID = [info integerValueForKey:RH_GP_CHECKVERSION_ID] ;
        _mAppName = [info stringValueForKey:RH_GP_CHECKVERSION_APPNAME] ;
        _mAppType = [info stringValueForKey:RH_GP_CHECKVERSION_APPTYPE] ;
        _mAppUrl = [info stringValueForKey:RH_GP_CHECKVERSION_APPURL].trim ;
        _mVersionCode = [info integerValueForKey:RH_GP_CHECKVERSION_VERSIONCODE] ;
        _mVersionName = [info stringValueForKey:RH_GP_CHECKVERSION_VERSIONNAME] ;
        _mMemo = [info stringValueForKey:RH_GP_CHECKVERSION_MEMO];
        _mMD5 = [info stringValueForKey:RH_GP_CHECKVERSION_MD5];
        _mUpdateTime = [NSDate dateWithTimeIntervalSince1970:[info doubleValueForKey:RH_GP_CHECKVERSION_UPDATETIME]/1000.0];
        _mForceVersion = [info stringValueForKey:RH_GP_CHECKVERSION_FORCEVERSION];
    }
    
    return self ;
}

@end
