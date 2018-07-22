//
//  RH_HelpCenterDetailViewCell.h
//  gameBoxEx
//
//  Created by Richard on 2018/3/25.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"

@class RH_HelpCenterDetailViewCell ;
@protocol helpCenterDetailViewCellDelegate<NSObject>
@optional
-(void)helpCenterDetailViewCellDidTouchTitleBtn:(RH_HelpCenterDetailViewCell*)helpCenterDetailViewCell;

@end

@interface RH_HelpCenterDetailViewCell : CLTableViewCell
@property(nonatomic,assign)BOOL isOpen ;
@property (nonatomic,weak) id<helpCenterDetailViewCellDelegate> delegate ;
@end
