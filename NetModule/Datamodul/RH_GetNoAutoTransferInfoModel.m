//
//  RH_GetNoAutoTransferInfoModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/26.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_GetNoAutoTransferInfoModel.h"
#import "coreLib.h"

@implementation RH_GetNoAutoTransferInfoModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mTransferPendingAmount = [info floatValueForKey:@"transferPendingAmount"]  ;
        _mCurrency = [info stringValueForKey:@"currency"] ;
        _mToken = [info stringValueForKey:@"token"] ;
        _selectModel = [SelectModel dataArrayWithInfoArray:[info objectForKey:@"select"]] ;
    }
    return self ;
}
@end

@implementation SelectModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mValue = [info stringValueForKey:@"value"] ;
        _mText = [info stringValueForKey:@"text"] ;
    }
    return self ;
}
@end
