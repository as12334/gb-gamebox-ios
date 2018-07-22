//
//  RH_CapitalInfoModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_CapitalTypeModel : RH_BasicModel
@property(nonatomic,strong,readonly)NSString *mTypeId;
@property(nonatomic,strong,readonly)NSString *mTypeName;
@property(nonatomic,strong,readonly)NSMutableArray *mTypeArray;
+(NSMutableArray *)dataArrayWithDictInfo:(NSDictionary *)dictInfo ;
@end
