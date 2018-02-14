//
//  RH_ShareRecordTableViewCell.h
//  gameBoxEx
//
//  Created by Richard on 2018/2/13.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
@class RH_ShareRecordTableViewCell;
@protocol RH_ShareRecordTableViewCellDelegate <NSObject>
@optional
-(void)shareRecordTableViewSearchBtnDidTouchBackButton:(RH_ShareRecordTableViewCell*)shareRecordTableViewCell ;
@end


@interface RH_ShareRecordTableViewCell : CLTableViewCell
@property(nonatomic,weak)id<RH_ShareRecordTableViewCellDelegate> delegate ;
@end
