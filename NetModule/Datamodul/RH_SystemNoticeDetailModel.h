//
//  RH_SystemNoticeDetailModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_SystemNoticeDetailModel : RH_BasicModel
@property(nonatomic,strong,readonly)NSString *mContent;
@property(nonatomic,strong,readonly)NSString *mID;
@property(nonatomic,strong,readonly)NSString *mLink;
@property(nonatomic,strong,readonly)NSDate *mPublishTime;
@property(nonatomic,strong,readonly)NSString  *mTitle;

@end
