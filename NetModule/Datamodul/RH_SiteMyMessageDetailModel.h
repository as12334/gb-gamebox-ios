//
//  RH_SiteMyMessageDetail.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
@interface RH_SiteMyMessageDetailListModel :RH_BasicModel
@property(nonatomic,strong,readonly)NSString *mReplyContent;
@property(nonatomic,strong,readonly)NSDate *mReplyTime;
@property(nonatomic,strong,readonly)NSString *mReplyTitle;

@end

@interface RH_SiteMyMessageDetailModel : RH_BasicModel
@property(nonatomic,strong,readonly)NSString   *mAdvisoryContent; //提问内容
@property(nonatomic,strong,readonly)NSDate     *mAdvisoryTime;  //提问时间
@property(nonatomic,strong,readonly)NSString   *mAdvisoryTitle; //提问标题
@property(nonatomic,strong,readonly)NSString  *mQuestionType; //问题类型
@property(nonatomic,strong,readonly)NSArray <RH_SiteMyMessageDetailListModel *>*listModel;
@end

