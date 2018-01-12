//
//  RH_PromoInfoModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
#import <CoreGraphics/CoreGraphics.h>

@interface RH_PromoInfoModel : RH_BasicModel
@property(nonatomic,strong,readonly) NSString *mActivityName;
@property(nonatomic,strong,readonly) NSString *mActivityVersion;
@property(nonatomic,strong,readonly) NSDate *mApplyTime ;
@property(nonatomic,assign,readonly) NSInteger mCheckState;
@property(nonatomic,strong,readonly) NSString *mCheckStateName;
@property(nonatomic,assign,readonly) NSInteger mID;
@property(nonatomic,assign,readonly) BOOL mPreferentialAudit  ;
@property(nonatomic,strong,readonly) NSString *mPreferentialAuditName;
@property(nonatomic,assign,readonly) CGFloat mPreferentialValue ;
@property(nonatomic,assign,readonly) NSInteger mUserID;

///---
@property (nonatomic,strong) NSString *showApplyTime ;
@property (nonatomic,strong) NSString *showPreferentialValue ;

@end
