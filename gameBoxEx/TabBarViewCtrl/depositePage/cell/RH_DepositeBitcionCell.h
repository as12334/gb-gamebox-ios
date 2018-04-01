//
//  RH_DepositeBitcionCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/3/31.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
#import "RH_DepositeBitcionCell.h"
@class RH_DepositeBitcionCell;
@protocol DepositeBitcionCellDelegate<NSObject>
@optional
-(void)depositeBitcionCellSubmit:(RH_DepositeBitcionCell *)bitcoinCell;
@end
@interface RH_DepositeBitcionCell : CLTableViewCell
@property(nonatomic,weak)id<DepositeBitcionCellDelegate>delegate;
@property(nonatomic,strong)NSString *bitcoinAdressStr;
@property(nonatomic,strong)NSString *txidStr;
@property(nonatomic,strong)NSString *bitcoinNumStr;
@property(nonatomic,strong)NSString *bitcoinChangeTimeStr;

@property (nonatomic,strong) NSDate *bitConDate ;
@end
