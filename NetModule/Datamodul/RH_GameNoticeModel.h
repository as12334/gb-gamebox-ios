//
//  RH_GameNoticeModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface ListModel :RH_BasicModel
@property (nonatomic , strong , readonly) NSString              * mId;
@property (nonatomic , strong , readonly) NSString              * mTitle;
@property (nonatomic , strong , readonly) NSString              * mGameName;
@property (nonatomic , assign , readonly) NSInteger              mPublishTime;
@property (nonatomic , strong , readonly) NSString              * mContext;
@property (nonatomic , strong , readonly) NSString              * mLink;

@end

@interface ApiSelectModel :RH_BasicModel
@property (nonatomic , assign , readonly) NSInteger              mApiId;
@property (nonatomic , strong , readonly) NSString              * mApiName;

@end

@interface RH_GameNoticeModel :RH_BasicModel
@property (nonatomic , assign , readonly) NSInteger              mMinDate;
@property (nonatomic , assign , readonly) NSInteger              mMaxDate;
@property (nonatomic , strong , readonly) NSArray<ListModel *>   * mListModel;
@property (nonatomic , strong , readonly) NSArray<ApiSelectModel *>    * mApiSelectModel;
@property (nonatomic , assign , readonly) NSInteger              mPageTotal;

@end
