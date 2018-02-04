//
//  RH_ApplyDiscountSiteGameCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/19.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PageLoadContentPageCell.h"
#import "RH_DiscountActivityTypeModel.h"

typedef void (^SiteSendMessageViewSubmitSuccessBlock)(NSString *titelStr,NSString *contenStr);
@interface RH_ApplyDiscountSiteSendCell :RH_PageLoadContentPageCell
-(void)updateViewWithType:(RH_DiscountActivityTypeModel*)typeModel  Context:(CLPageLoadDatasContext*)context ;
@property (nonatomic, copy) SiteSendMessageViewSubmitSuccessBlock submitSuccessBlock;
@end
