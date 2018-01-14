//
//  RH_GameNoticeDetailModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_GameNoticeDetailModel : RH_BasicModel
@property(nonatomic,assign,readonly)NSInteger mID;
@property(nonatomic,strong,readonly)NSString *mTitle;
@property(nonatomic,strong,readonly)NSString *mLink;
@property(nonatomic,strong,readonly)NSString *mGameName;
@property(nonatomic,assign,readonly)NSInteger mPublishTime;
@property(nonatomic,strong,readonly)NSString *mContext;
@end
