//
//  RH_LinkInfoModel.h
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_LinkInfoModel : RH_BasicModel
@property(nonatomic,strong,readonly) NSString  *mCode ;
@property(nonatomic,strong,readonly) NSString  *mLink ;
@property(nonatomic,strong,readonly) NSString  *mName ;

@end
