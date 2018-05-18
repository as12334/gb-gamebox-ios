//
//  RH_DepositeTransferModel.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeTransferModel.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_APPDelegate.h"
@implementation RH_DepositeTransferModel
@synthesize showCover = _showCover ;
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mCode = [info stringValueForKey:RH_GP_DEPOSITEORIGIN_CODE];
        _mName =[info stringValueForKey:RH_GP_DEPOSITEORIGIN_NAME];
        _mIconUrl = [info stringValueForKey:RH_GP_DEPOSITEORIGIN_ICOURL];
    }
    return self;
}

-(NSString *)showCover
{
    if (!_showCover){
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        if ([_mIconUrl containsString:@"http"] || [_mIconUrl containsString:@"https:"]) {
            _showCover = [NSString stringWithFormat:@"%@",_mIconUrl] ;
        }else
        {
            _showCover = [NSString stringWithFormat:@"%@/%@",appDelegate.domain,_mIconUrl] ;
        }
    }
    
    return _showCover ;
}
@end

