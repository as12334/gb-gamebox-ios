//
//  RH_HomeCategoryCell.h
//  lotteryBox
//
//  Created by luis on 2017/12/10.
//  Copyright © 2017年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTableViewCell.h"

@class RH_HomeCategoryCell ;
@protocol HomeCategoryCellDelegate
@optional
-(void)homeCategoryCellDidChangedSelected:(RH_HomeCategoryCell*)homeCategoryCell index:(NSInteger)index;
@end

@interface RH_HomeCategoryCell : CLTableViewCell
@property(nonatomic,weak) id<HomeCategoryCellDelegate> delegate ;
@property(nonatomic,readonly,assign) NSInteger selectedIndex ;
@end
