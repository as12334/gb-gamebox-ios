//
//  RH_SiteMineNoticeCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
typedef void (^chooseBtnBlock)(void);
@class RH_SiteMineNoticeCell;
@protocol MPSiteMineNoticeCellDelegate<NSObject>
@optional
-(void)chooseSiteSystemNoticeCellEditBtn:(UIButton *)button ;
@end
@interface RH_SiteMineNoticeCell : CLTableViewCell
@property(nonatomic,weak)id<MPSiteMineNoticeCellDelegate>delegate;
@property(nonatomic,assign)NSNumber *statusNumber;
@property(nonatomic,copy)chooseBtnBlock block;
@end
