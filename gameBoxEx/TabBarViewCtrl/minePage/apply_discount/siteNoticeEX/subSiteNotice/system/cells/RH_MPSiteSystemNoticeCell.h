//
//  RH_MPSiteSystemNoticeCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/5.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
#import "RH_SiteMessageModel.h"
@class RH_MPSiteSystemNoticeCell;
@protocol SiteSystemNoticeCellDelegate<NSObject>
@optional
-(void)siteSystemNoticeCellEditBtn:(RH_MPSiteSystemNoticeCell *)systemNoticeCell  cellModel:(RH_SiteMessageModel*)cellModel;
@end

@interface RH_MPSiteSystemNoticeCell : CLTableViewCell
@property(nonatomic,weak)id<SiteSystemNoticeCellDelegate>delegate;
@property(nonatomic,assign)NSNumber *statusNumber;
@end
