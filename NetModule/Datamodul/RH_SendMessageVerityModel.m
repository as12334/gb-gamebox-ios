//
//  RH_SiteSendMessageModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SendMessageVerityModel.h"
#import "coreLib.h"
#import "RH_API.h"




@implementation AdvisoryTypeListModel

-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mAdvisoryType = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_ADVISORYTYPE];
        _mAdvisoryName = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_ADVISORYNAME];
    }
    return self;
}

@end

@implementation RH_SendMessageVerityModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mAdvisoryTypeListModel =[AdvisoryTypeListModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_SENDMESSGAVERITY_ADVISORYTYPELIST]];
        _mIsOpenCaptcha = [info boolValueForKey:RH_GP_SENDMESSGAVERITY_ISOPENCAPTCHA];
        _mCaptcha_value = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_CAPTCHA_VALUE];
    }
    return self;
}

@end
