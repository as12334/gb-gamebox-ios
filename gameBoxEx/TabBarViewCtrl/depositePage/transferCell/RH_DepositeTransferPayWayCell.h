//
//  RH_DepositeTransferPayWayCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
#import "RH_DepositeTransferPayWayCell.h"
@class RH_DepositeTransferPayWayCell;
@protocol DepositeTransferPayWayCellDelegate<NSObject>
@optional
-(void)depositeTransferPaywayCellSelecteUpframe:(RH_DepositeTransferPayWayCell *)cell;
@end
@interface RH_DepositeTransferPayWayCell : CLTableViewCell
@property (nonatomic,strong)NSString *paywayString;
@property (weak, nonatomic) IBOutlet UITextField *payNumTextfield;
@property(nonatomic,weak)id<DepositeTransferPayWayCellDelegate>delegate;
@end
