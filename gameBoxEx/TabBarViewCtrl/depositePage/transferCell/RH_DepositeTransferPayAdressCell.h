//
//  RH_DepositeTransferPayAdressCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/3/26.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
#import "RH_DepositeTransferPayAdressCell.h"
@class RH_DepositeTransferPayAdressCell;
@protocol DepositeTransferPayAdressCellDelegate<NSObject>
@optional
-(void)depositeTransferPayAdressCellSelecteUpframe:(RH_DepositeTransferPayAdressCell *)cell;
@end
@interface RH_DepositeTransferPayAdressCell : CLTableViewCell
@property(nonatomic,strong)NSString *adressStr;
@property (weak, nonatomic) IBOutlet UITextField *payTextfield;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property(nonatomic,weak)id<DepositeTransferPayAdressCellDelegate>delegate;
@end
