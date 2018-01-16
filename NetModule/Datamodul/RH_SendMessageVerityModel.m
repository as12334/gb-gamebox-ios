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

@implementation SuggestModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mModule = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_MODULE];
        _mRemark = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_REMARK];
        _mActive = [info boolValueForKey:RH_GP_SENDMESSGAVERITY_ACTIVE];
        _mId = [info integerValueForKey:RH_GP_SENDMESSGAVERITY_ID];
        _mDictCode = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_DICTCODE];
        _mTranslated = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_TRANSLATED];
        _mOrderNum = [info integerValueForKey:RH_GP_SENDMESSGAVERITY_ORDERNUM];
        _mDictType= [info stringValueForKey:RH_GP_SENDMESSGAVERITY_DICTTYPE];
        _mParentCode = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_PARENTCODE];
    }
    return self;
}
@end


@implementation FinanceProblemModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mModule = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_MODULE];
        _mRemark = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_REMARK];
        _mActive = [info boolValueForKey:RH_GP_SENDMESSGAVERITY_ACTIVE];
        _mId = [info integerValueForKey:RH_GP_SENDMESSGAVERITY_ID];
        _mDictCode = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_DICTCODE];
        _mTranslated = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_TRANSLATED];
        _mOrderNum = [info integerValueForKey:RH_GP_SENDMESSGAVERITY_ORDERNUM];
        _mDictType= [info stringValueForKey:RH_GP_SENDMESSGAVERITY_DICTTYPE];
        _mParentCode = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_PARENTCODE];
    }
    return self;
}
@end


@implementation OfferApplicationModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mModule = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_MODULE];
        _mRemark = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_REMARK];
        _mActive = [info boolValueForKey:RH_GP_SENDMESSGAVERITY_ACTIVE];
        _mId = [info integerValueForKey:RH_GP_SENDMESSGAVERITY_ID];
        _mDictCode = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_DICTCODE];
        _mTranslated = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_TRANSLATED];
        _mOrderNum = [info integerValueForKey:RH_GP_SENDMESSGAVERITY_ORDERNUM];
        _mDictType= [info stringValueForKey:RH_GP_SENDMESSGAVERITY_DICTTYPE];
        _mParentCode = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_PARENTCODE];
    }
    return self;
}
@end

@implementation OtherProblemModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mModule = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_MODULE];
        _mRemark = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_REMARK];
        _mActive = [info boolValueForKey:RH_GP_SENDMESSGAVERITY_ACTIVE];
        _mId = [info integerValueForKey:RH_GP_SENDMESSGAVERITY_ID];
        _mDictCode = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_DICTCODE];
        _mTranslated = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_TRANSLATED];
        _mOrderNum = [info integerValueForKey:RH_GP_SENDMESSGAVERITY_ORDERNUM];
        _mDictType= [info stringValueForKey:RH_GP_SENDMESSGAVERITY_DICTTYPE];
        _mParentCode = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_PARENTCODE];
    }
    return self;
}
@end

@implementation AdvisoryTypeModel

-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mSuggestModel =[SuggestModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_SENDMESSGAVERITY_SUGGEST]] ;
        _mOtherProblemModel = [OtherProblemModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_SENDMESSGAVERITY_OTHERPROBLEM]];
        _mFinanceProblemModel =[FinanceProblemModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_SENDMESSGAVERITY_FINANCEPROBLEM]];
        _mOfferApplicationModel = [OfferApplicationModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_SENDMESSGAVERITY_OFFERAPPLICATION]];
    }
    return self;
}

@end

@implementation RH_SendMessageVerityModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mAdvisoryTypeModel =[OfferApplicationModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_SENDMESSGAVERITY_ADVISORYTYPE]];
        _mIsOpenCaptcha = [info boolValueForKey:RH_GP_SENDMESSGAVERITY_ISOPENCAPTCHA];
        _mCaptcha_value = [info stringValueForKey:RH_GP_SENDMESSGAVERITY_CAPTCHA_VALUE];
    }
    return self;
}

@end
