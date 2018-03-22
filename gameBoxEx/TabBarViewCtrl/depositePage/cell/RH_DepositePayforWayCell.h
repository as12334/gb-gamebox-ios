//
//  RH_DepositePayforWayCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
#import "RH_DepositePayforWayCell.h"
@class RH_DepositePayforWayCell;
@protocol DepositePayforWayCellDelegate<NSObject>
@optional
-(void)depositePayforWayDidtouchItemCell:(RH_DepositePayforWayCell *)payforItem itemIndex:(NSInteger )itemIndex;
@end
@interface RH_DepositePayforWayCell : CLTableViewCell
@property(nonatomic,weak)id<DepositePayforWayCellDelegate>delegate;
@end
