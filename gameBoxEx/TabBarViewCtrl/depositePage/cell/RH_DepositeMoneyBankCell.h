//
//  RH_DepositeMoneyBankCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
#import "RH_DepositeMoneyBankCell.h"
@class RH_DepositeMoneyBankCell;
@protocol DepositeMoneyBankCellDeleaget<NSObject>
@optional
-(void)depositeMoneyBankCellChoosePickerview:(RH_DepositeMoneyBankCell *)cell andBankNameArray:(NSMutableArray *)bankNameArray;
@end
@interface RH_DepositeMoneyBankCell : CLTableViewCell
@property(nonatomic,weak)id<DepositeMoneyBankCellDeleaget>delegate;
@property(nonatomic,strong)NSString *bankNameString;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@end
