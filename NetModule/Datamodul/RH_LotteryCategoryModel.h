//
//  RH_LotteryCategoryModel.h
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
#import "RH_LotteryAPIInfoModel.h"

@interface RH_LotteryCategoryModel : RH_BasicModel
@property(nonatomic,assign,readonly) NSInteger  mApiType ;
@property(nonatomic,strong,readonly) NSString  *mApiTypeName ;
@property(nonatomic,strong,readonly) NSString  *mCover ;
@property(nonatomic,strong,readonly) NSString  *mLocale ;
@property(nonatomic,strong,readonly) NSArray<RH_LotteryAPIInfoModel*>  *mSiteApis ;

//extend property
@property(nonatomic,assign,readonly) BOOL isExistSubCategory ;
@property(nonatomic,strong,readonly) NSString *showCover ;
@end
