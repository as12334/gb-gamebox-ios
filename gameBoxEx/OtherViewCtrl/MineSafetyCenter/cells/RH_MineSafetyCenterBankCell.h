//
//  RH_MineSafetyCenterBankCell.h
//  gameBoxEx
//
//  Created by Lenny on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"

@interface RH_MineSafetyCenterBankCell : CLTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bankImage;
@property (weak, nonatomic) IBOutlet UILabel *leftBankTitle;
@property (weak, nonatomic) IBOutlet UILabel *noBankLabel;

@property (weak, nonatomic) IBOutlet UILabel *bankCardNumber;

@property (weak, nonatomic) IBOutlet UILabel *rightLab;


@end
