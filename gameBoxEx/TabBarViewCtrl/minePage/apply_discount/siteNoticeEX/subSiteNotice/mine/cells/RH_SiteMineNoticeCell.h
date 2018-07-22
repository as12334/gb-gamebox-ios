//
//  RH_SiteMineNoticeCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
#import "RH_SiteMyMessageModel.h"

typedef void (^chooseBtnBlock)(void);
@class RH_SiteMineNoticeCell;
@protocol SiteMineNoticeCellDelegate <NSObject>
@optional
-(void)siteMineNoticeCellTouchEditBtn:(RH_SiteMineNoticeCell *)siteMineNoticeCell CellModel:(RH_SiteMyMessageModel*)cellMoel;
@end

@interface RH_SiteMineNoticeCell : CLTableViewCell
@property(nonatomic,weak)id<SiteMineNoticeCellDelegate>delegate;
@property(nonatomic,assign)NSNumber *statusNumber;
@end
