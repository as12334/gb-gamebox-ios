//
//  RH_HomeCategoryItemsCell.h
//  lotteryBox
//
//  Created by luis on 2017/12/10.
//  Copyright © 2017年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTableViewCell.h"

@class RH_HomeCategoryItemsCell ;
@protocol HomeCategoryItemsCellDelegate
@optional
-(void)homeCategoryItemsCellDidTouchItemCell:(RH_HomeCategoryItemsCell*)homeCategoryItem DataModel:(id)cellItemModel index:(NSInteger)index;
@end

@interface RH_HomeCategoryItemsCell : CLTableViewCell
@property (nonatomic,weak) id<HomeCategoryItemsCellDelegate> delegate ;
@end
