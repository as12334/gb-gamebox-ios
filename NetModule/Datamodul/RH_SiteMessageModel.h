//
//  RH_SiteMessageModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_SiteMessageModel : RH_BasicModel
@property(nonatomic,assign,readonly)NSInteger mId;
@property(nonatomic,strong,readonly)NSString *mContent;
@property(nonatomic,strong,readonly)NSDate *mPublishTime;
@property(nonatomic,strong,readonly)NSString *mLink;
@property(nonatomic,strong,readonly)NSString *mTitle;
@property(nonatomic,assign,readonly)BOOL mRead;
@property(nonatomic,strong,readonly)NSString *mSearchId;
//@property(nonatomic,strong,readonly)NSString *mMarkString;
//---extend
@property(nonatomic,strong)NSNumber *number;

@end
