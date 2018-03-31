//
//  RH_DepositeMoneyNumberCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeMoneyNumberCell.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_DepositeTransferChannelModel.h"
@interface RH_DepositeMoneyNumberCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *decimalsBtn;

@end
@implementation RH_DepositeMoneyNumberCell
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
   RH_DepositeTransferListModel  *listModel = ConvertToClassPointer(RH_DepositeTransferListModel, context);
    self.payMoneyNumLabel.placeholder = [NSString stringWithFormat:@"%ld~%ld",listModel.mSingleDepositMin,listModel.mSingleDepositMax];
    self.moneyNumMin = listModel.mSingleDepositMin;
    self.moneyNumMax = listModel.mSingleDepositMax;
    self.payMoneyNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.decimalsBtn setTitle:[NSString stringWithFormat:@"%0.2f",(float)(1+arc4random()%99)/100] forState:UIControlStateNormal];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
