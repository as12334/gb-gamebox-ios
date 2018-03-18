//
//  RH_SiteMsgUnReadCountModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/2/11.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_SiteMsgUnReadCountModel : RH_BasicModel
@property(nonatomic,strong,readonly)NSString *sysMsgUnreadCount;
@property(nonatomic,strong,readonly)NSString *mineMsgUnreadCount;

//extend
@property(nonatomic,assign,readonly)NSInteger siteMsgUnReadCount;



@end
