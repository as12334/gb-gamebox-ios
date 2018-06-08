//
//  RH_FirstBigViewCell.h
//  gameBoxEx
//
//  Created by Richard on 2018/2/13.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
@class RH_FirstBigViewCell;
@protocol FirstBigViewCellDelegate<NSObject>
@optional
-(void)firstBigViewCellSearchSharelist:(NSDate *)startDate endDate:(NSDate *)endDate;
@end
@interface RH_FirstBigViewCell : CLTableViewCell
@property (nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,weak)id<FirstBigViewCellDelegate>delegate;
@end
