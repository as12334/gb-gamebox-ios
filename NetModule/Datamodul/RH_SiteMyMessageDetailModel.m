//
//  RH_SiteMyMessageDetail.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SiteMyMessageDetailModel.h"
#import "coreLib.h"
#import "RH_API.h"

@implementation RH_SiteMyMessageDetailModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mAdvisoryContent = [info stringValueForKey:RH_GP_MYMESSAGEDETAIL_ADVISORYCONTENT];
        _mAdvisoryTime = [NSDate dateWithTimeIntervalSince1970:[info doubleValueForKey:RH_GP_MYMESSAGEDETAIL_ADVISORYTIME]/1000.0];
        _mAdvisoryTitle = [info stringValueForKey:RH_GP_MYMESSAGEDETAIL_ADVISORYTITLE];
        _mQuestionType = [info stringValueForKey:RH_GP_MYMESSAGEDETAIL_QUESTIONTYPE];
        _listModel = [RH_SiteMyMessageDetailListModel dataArrayWithInfoArray:[info arrayValueForKey:@"replyList"] ];
    }
    return self;
}

@end
@implementation RH_SiteMyMessageDetailListModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mReplyContent = [info stringValueForKey:RH_GP_MYMESSAGEDETAIL_REPLYCONTENT];
        _mReplyTime = [NSDate dateWithTimeIntervalSince1970:[info doubleValueForKey:RH_GP_MYMESSAGEDETAIL_REPLYTIME]/1000.0];
        _mReplyTitle = [info stringValueForKey:RH_GP_MYMESSAGEDETAIL_REPLYTITLE];
    }
    return self;
}
@end
