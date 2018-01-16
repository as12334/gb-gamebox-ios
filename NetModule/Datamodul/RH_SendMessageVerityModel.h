//
//  RH_SiteSendMessageModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface SuggestModel :RH_BasicModel
@property (nonatomic , strong , readonly) NSString              * mModule;
@property (nonatomic , strong , readonly) NSString              * mRemark;
@property (nonatomic , assign , readonly) BOOL                  mActive;
@property (nonatomic , assign , readonly) NSInteger              mId;
@property (nonatomic , strong , readonly) NSString              * mDictCode;
@property (nonatomic , strong , readonly) NSString              * mTranslated;
@property (nonatomic , assign , readonly) NSInteger              mOrderNum;
@property (nonatomic , strong , readonly) NSString              * mDictType;
@property (nonatomic , strong , readonly) NSString              * mParentCode;

@end

@interface FinanceProblemModel :RH_BasicModel
@property (nonatomic , strong , readonly) NSString              * mModule;
@property (nonatomic , strong , readonly) NSString              * mRemark;
@property (nonatomic , assign , readonly) BOOL                  mActive;
@property (nonatomic , assign , readonly) NSInteger              mId;
@property (nonatomic , strong , readonly) NSString              * mDictCode;
@property (nonatomic , strong , readonly) NSString              * mTranslated;
@property (nonatomic , assign , readonly) NSInteger              mOrderNum;
@property (nonatomic , strong , readonly) NSString              * mDictType;
@property (nonatomic , strong , readonly) NSString              * mParentCode;

@end

@interface OfferApplicationModel :RH_BasicModel
@property (nonatomic , strong , readonly) NSString              * mModule;
@property (nonatomic , strong , readonly) NSString              * mRemark;
@property (nonatomic , assign , readonly) BOOL                  mActive;
@property (nonatomic , assign , readonly) NSInteger              mId;
@property (nonatomic , strong , readonly) NSString              * mDictCode;
@property (nonatomic , strong , readonly) NSString              * mTranslated;
@property (nonatomic , assign , readonly) NSInteger              mOrderNum;
@property (nonatomic , strong , readonly) NSString              * mDictType;
@property (nonatomic , strong , readonly) NSString              * mParentCode;

@end

@interface OtherProblemModel :RH_BasicModel
@property (nonatomic , strong , readonly) NSString              * mModule;
@property (nonatomic , strong , readonly) NSString              * mRemark;
@property (nonatomic , assign , readonly) BOOL                  mActive;
@property (nonatomic , assign , readonly) NSInteger              mId;
@property (nonatomic , strong , readonly) NSString              * mDictCode;
@property (nonatomic , strong , readonly) NSString              * mTranslated;
@property (nonatomic , assign , readonly) NSInteger              mOrderNum;
@property (nonatomic , strong , readonly) NSString              * mDictType;
@property (nonatomic , strong , readonly) NSString              * mParentCode;

@end

@interface AdvisoryTypeModel :RH_BasicModel
@property (nonatomic , strong , readonly) NSArray<SuggestModel *>           * mSuggestModel;
@property (nonatomic , strong , readonly) NSArray<FinanceProblemModel *>    * mFinanceProblemModel;
@property (nonatomic , strong , readonly) NSArray<OfferApplicationModel *>  * mOfferApplicationModel;
@property (nonatomic , strong , readonly) NSArray<OtherProblemModel *>      * mOtherProblemModel;

@end

@interface RH_SendMessageVerityModel :RH_BasicModel
@property (nonatomic , strong ,readonly)NSArray<AdvisoryTypeModel *>  * mAdvisoryTypeModel;
@property (nonatomic , assign ,readonly) BOOL                     mIsOpenCaptcha;  //是否开启验证
@property (nonatomic , strong ,readonly)NSString                 *mCaptcha_value;  //验证码链接

@end
