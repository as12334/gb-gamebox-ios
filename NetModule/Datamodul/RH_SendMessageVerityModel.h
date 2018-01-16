//
//  RH_SiteSendMessageModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface SuggestModel :NSObject
@property (nonatomic , copy) NSString              * module;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , assign) BOOL              active;
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , copy) NSString              * dictCode;
@property (nonatomic , copy) NSString              * translated;
@property (nonatomic , assign) NSInteger              orderNum;
@property (nonatomic , copy) NSString              * dictType;
@property (nonatomic , copy) NSString              * parentCode;

@end

@interface FinanceProblemModel :NSObject
@property (nonatomic , copy) NSString              * module;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , assign) BOOL              active;
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , copy) NSString              * dictCode;
@property (nonatomic , copy) NSString              * translated;
@property (nonatomic , assign) NSInteger              orderNum;
@property (nonatomic , copy) NSString              * dictType;
@property (nonatomic , copy) NSString              * parentCode;

@end

@interface OfferApplicationModel :NSObject
@property (nonatomic , copy) NSString              * module;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , assign) BOOL              active;
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , copy) NSString              * dictCode;
@property (nonatomic , copy) NSString              * translated;
@property (nonatomic , assign) NSInteger              orderNum;
@property (nonatomic , copy) NSString              * dictType;
@property (nonatomic , copy) NSString              * parentCode;

@end

@interface OtherProblemModel :NSObject
@property (nonatomic , copy , readonly) NSString              * module;
@property (nonatomic , copy , readonly) NSString              * remark;
@property (nonatomic , assign , readonly) BOOL              active;
@property (nonatomic , assign , readonly) NSInteger              id;
@property (nonatomic , copy , readonly) NSString              * dictCode;
@property (nonatomic , copy , readonly) NSString              * translated;
@property (nonatomic , assign , readonly) NSInteger              orderNum;
@property (nonatomic , copy , readonly) NSString              * dictType;
@property (nonatomic , copy , readonly) NSString              * parentCode;

@end

@interface AdvisoryTypeModel :NSObject
@property (nonatomic , strong , readonly) SuggestModel                     * suggestModel;
@property (nonatomic , strong , readonly) FinanceProblemModel              * financeProblemModel;
@property (nonatomic , strong , readonly) OfferApplicationModel            * offerApplicationModel;
@property (nonatomic , strong , readonly) OtherProblemModel                * otherProblemModel;

@end

@interface RH_SendMessageVerityModel :NSObject
@property (nonatomic , strong ,readonly) AdvisoryTypeModel      * mAdvisoryTypeModel;
@property (nonatomic , assign ,readonly) BOOL                     mIsOpenCaptcha;  //是否开启验证
@property (nonatomic , strong ,readonly)NSString                 *mCaptcha_value;  //验证码链接

@end
