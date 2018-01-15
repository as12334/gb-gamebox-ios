//
//  RH_DiscountActivityTypeModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_DiscountActivityTypeModel : RH_BasicModel
@property(nonatomic,assign,readonly)NSInteger mID;
@property(nonatomic,strong,readonly)NSString *mActivityKey;
@property(nonatomic,strong,readonly)NSString *mActivityTypeName;
@end
