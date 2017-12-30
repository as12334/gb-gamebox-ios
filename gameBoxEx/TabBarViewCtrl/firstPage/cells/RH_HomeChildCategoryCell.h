//
//  RH_HomeChildCategoryCell.h
//  lotteryBox
//
//  Created by luis on 2017/12/10.
//  Copyright © 2017年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTableViewCell.h"

@class RH_HomeChildCategoryCell ;
@protocol HomeChildCategoryCellDelegate
@optional
-(void)homeChildCategoryCellDidChangedSelectedIndex:(RH_HomeChildCategoryCell*)homeChildCategoryCell ;
@end

@interface RH_HomeChildCategoryCell : CLTableViewCell
@property (nonatomic,weak) id<HomeChildCategoryCellDelegate> delegate ;
@property(nonatomic,readonly,assign) NSInteger selectedIndex ;
@end
