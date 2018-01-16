//
//  RH_SiteMyMessageDetail.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_SiteMyMessageDetailModel : RH_BasicModel
@property(nonatomic,strong,readonly)NSString   *mAdvisoryContent; //内容
@property(nonatomic,strong,readonly)NSDate     *mAdvisoryTime;  //时间
@property(nonatomic,strong,readonly)NSString   *mAdvisoryTitle; //标题
@property(nonatomic,strong,readonly)NSString  *mQuestionType; //问题
@property(nonatomic,strong,readonly)NSString   *mReplyTitle;  //回复标题
@property(nonatomic,strong,readonly)NSString   *mReplyContent; //内容
@property(nonatomic,strong,readonly)NSDate     *mReplyTime;  //时间
@end
