//
//  RH_DepositeTransferOrderNumCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/3/26.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
#import "RH_DepositeTransferOrderNumCell.h"
@class RH_DepositeTransferOrderNumCell;
@protocol DepositeTransferOrderNumCellDelegate<NSObject>
@optional
-(void)depositeTransferOrderNumCellSelecteUpframe:(RH_DepositeTransferOrderNumCell *)cell;
@end
@interface RH_DepositeTransferOrderNumCell : CLTableViewCell
@property(nonatomic,strong)NSString *transferOrderString;
@property (weak, nonatomic) IBOutlet UITextField *orderNumTextfiled;
@property(nonatomic,weak)id<DepositeTransferOrderNumCellDelegate>delegate;
@end
