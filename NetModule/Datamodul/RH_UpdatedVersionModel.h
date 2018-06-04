//
//  RH_UpdatedVersionModel.h
//  gameBoxEx
//
//  Created by luis on 2017/10/27.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_UpdatedVersionModel : RH_BasicModel
@property(nonatomic,readonly,assign) NSInteger mID      ;
@property(nonatomic,readonly,strong) NSString *mAppName ;
@property(nonatomic,readonly,strong) NSString *mAppType ;
@property(nonatomic,readonly,strong) NSString *mAppUrl ;
@property(nonatomic,readonly,strong) NSString *mMD5 ;
@property(nonatomic,readonly,strong) NSString *mMemo ;
@property(nonatomic,readonly,strong) NSDate   *mUpdateTime ;
@property(nonatomic,readonly,assign) NSInteger mVersionCode ;
@property(nonatomic,readonly,strong) NSString *mVersionName ;
@property(nonatomic,readonly,strong) NSString *mForceVersion;
@end

