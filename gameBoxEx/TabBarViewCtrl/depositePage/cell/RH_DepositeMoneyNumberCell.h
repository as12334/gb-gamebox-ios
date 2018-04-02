//
//  RH_DepositeMoneyNumberCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"

@interface RH_DepositeMoneyNumberCell : CLTableViewCell
@property (weak, nonatomic) IBOutlet UITextField *payMoneyNumLabel;
@property (nonatomic,strong)NSString *payMoneyString;
@property (nonatomic,assign)NSInteger moneyNumMin;
@property (nonatomic,assign)NSInteger moneyNumMax;
@end
