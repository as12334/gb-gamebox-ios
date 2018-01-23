//
//  RH_MPSiteSystemNoticeCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/5.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
typedef void (^chooseBtnBlock)(void);
@class RH_MPSiteSystemNoticeCell;
@protocol MPSiteSystemNoticeCellDelegate<NSObject>
@optional
-(void)chooseSiteSystemNoticeCellEditBtn:(UIButton *)button ;
@end

@interface RH_MPSiteSystemNoticeCell : CLTableViewCell
@property(nonatomic,weak)id<MPSiteSystemNoticeCellDelegate>delegate;
@property(nonatomic,assign)NSNumber *statusNumber;
@property(nonatomic,copy)chooseBtnBlock block;
@end