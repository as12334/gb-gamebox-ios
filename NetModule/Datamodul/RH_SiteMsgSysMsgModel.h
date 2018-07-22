//
//  RH_SiteMsgSysMsgModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/26.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
/*站点消息  系统消息模型*/
@interface RH_SiteMsgSysMsgModel : RH_BasicModel
@property (nonatomic , strong , readonly) NSString              * mContent;
@property (nonatomic , assign , readonly) NSInteger               mId;
@property (nonatomic , strong , readonly) NSString              * mLink;
@property (nonatomic , strong , readonly) NSDate                * mPublishTime;
@property (nonatomic , assign , readonly) BOOL                    mRead;
@property (nonatomic , strong , readonly) NSString              * mTitle;
@end
