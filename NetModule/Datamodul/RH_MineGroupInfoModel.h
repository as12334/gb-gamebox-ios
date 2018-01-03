//
//  RH_MineGroupInfoModel.h
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
#import "RH_MineInfoModel.h"
#import "RH_LinkInfoModel.h"

@interface RH_MineGroupInfoModel : RH_BasicModel
@property (nonatomic,assign,readonly) BOOL mIsBit  ;
@property (nonatomic,assign,readonly) BOOL mIsCash ;
@property (nonatomic,strong,readonly) NSArray<RH_LinkInfoModel*> *mLink ;
@property (nonatomic,strong,readonly) RH_MineInfoModel *mUserInfo ;

-(RH_LinkInfoModel*)getLinkInfoWithCode:(NSString*)code ;
@end
