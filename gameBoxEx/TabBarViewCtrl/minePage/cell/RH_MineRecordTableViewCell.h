//
//  RH_MineRecordTableViewCell.h
//  lotteryBox
//
//  Created by Lewis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "CLTableViewCell.h"

@class RH_MineRecordTableViewCell ;
@protocol MineRecordTableViewCellProtocol
@optional
-(void)mineRecordTableViewCellDidTouchCell:(RH_MineRecordTableViewCell*)mineRecordTableCell CellInfo:(NSDictionary*)dictInfo ;
@end

@interface RH_MineRecordTableViewCell : CLTableViewCell
@property (nonatomic,weak) id<MineRecordTableViewCellProtocol> delegate ;

@property(nonatomic,assign)NSInteger numberSection;
@property(nonatomic,assign)NSInteger numberItems;
@end
