//
//  RH_SystemNoticeModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_SystemNoticeModel : RH_BasicModel
@property(nonatomic,strong,readonly)NSString *mID;
@property(nonatomic,strong,readonly)NSString *mContent;
@property(nonatomic,strong,readonly)NSDate *mPublishTime;
@property(nonatomic,strong,readonly)NSString *mLink;
@property(nonatomic,assign,readonly)NSInteger mPageTotal;
@property(nonatomic,strong,readonly)NSDate *mMinDate;
@property(nonatomic,strong,readonly)NSDate *mMaxDate;

@end
