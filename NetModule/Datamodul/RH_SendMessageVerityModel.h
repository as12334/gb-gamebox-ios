//
//  RH_SiteSendMessageModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
@interface AdvisoryTypeListModel :RH_BasicModel
@property (nonatomic , strong , readonly) NSString      * mAdvisoryType;
@property (nonatomic , strong , readonly) NSString      * mAdvisoryName;

@end

@interface RH_SendMessageVerityModel :RH_BasicModel
@property (nonatomic , strong ,readonly)NSArray<AdvisoryTypeListModel *>  * mAdvisoryTypeListModel;
@property (nonatomic , assign ,readonly) BOOL                     mIsOpenCaptcha;  //是否开启验证
@property (nonatomic , strong ,readonly)NSString                 *mCaptcha_value;  //验证码链接

@end
