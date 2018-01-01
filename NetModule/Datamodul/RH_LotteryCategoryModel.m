//
//  RH_LotteryCategoryModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_LotteryCategoryModel.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_APPDelegate.h"

@interface RH_LotteryCategoryModel ()
@end ;

@implementation RH_LotteryCategoryModel
@synthesize showCover = _showCover  ;
@synthesize isExistSubCategory = _isExistSubCategory ;

-(id)initWithInfoDic:(NSDictionary *)info
{
    self = [super initWithInfoDic:info] ;
    if (self){
        _mApiType = [info integerValueForKey:RH_GP_LotteryCategory_APITYPE] ;
        _mApiTypeName = [info stringValueForKey:RH_GP_LotteryCategory_APITYPENAME] ;
        _mCover = [info stringValueForKey:RH_GP_LotteryCategory_COVER] ;
        _mLocale = [info stringValueForKey:RH_GP_LotteryCategory_LOCALE] ;
        _mSiteApis = [RH_LotteryAPIInfoModel dataArrayWithInfoArray:[info arrayValueForKey:RH_GP_LotteryCategory_SITEAPIS]] ;
    }
    
    return self ;
}

#pragma mark -
-(BOOL)isExistSubCategory
{
    if (self.mSiteApis.count){
        RH_LotteryAPIInfoModel *lotteryApiModel = self.mSiteApis[0] ;
        return lotteryApiModel.mGameItems.count?YES:NO ;
    }
    
    return NO ;
}

-(NSString *)showCover
{
    if (!_showCover){
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        _showCover = [NSString stringWithFormat:@"%@/%@",appDelegate.domain,_mCover] ;
    }
    
    return _showCover ;
}

@end
