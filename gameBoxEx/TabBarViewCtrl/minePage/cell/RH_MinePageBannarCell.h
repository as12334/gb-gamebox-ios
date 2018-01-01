//
//  RH_MinePageBannarCell.h
//  lotteryBox
//
//  Created by Lewis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
@class RH_MinePageBannarCell;
@protocol MinePageBannarCellDelegate<NSObject>
-(void)testTimePickerClick:(RH_MinePageBannarCell *)cell;
@end
@interface RH_MinePageBannarCell : CLTableViewCell
@property (nonatomic,strong) IBOutlet UILabel *labAccoutInfo ;
@property(nonatomic,weak)id<MinePageBannarCellDelegate>delegate;
@end
