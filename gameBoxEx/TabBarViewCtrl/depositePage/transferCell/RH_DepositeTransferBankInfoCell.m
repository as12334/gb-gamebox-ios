//
//  RH_DepositeTransferBankInfoCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeTransferBankInfoCell.h"
@interface RH_DepositeTransferBankInfoCell()
@property (weak, nonatomic) IBOutlet UIView *bankInfoView;
@property (weak, nonatomic) IBOutlet UIButton *copBtn;
@property (weak, nonatomic) IBOutlet UIButton *copBtnTwo;
@property (weak, nonatomic) IBOutlet UIButton *copBtnThr;

@end
@implementation RH_DepositeTransferBankInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bankInfoView.layer.cornerRadius = 5.f;
    self.bankInfoView.layer.masksToBounds=YES;
    self.bankInfoView.layer.borderWidth = 1.f;
    self.bankInfoView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.copBtn.layer.cornerRadius = 5.f;
    self.copBtn.layer.masksToBounds = YES;
    self.copBtnTwo.layer.cornerRadius = 5.f;
    self.copBtnTwo.layer.masksToBounds = YES;
    self.copBtnThr.layer.cornerRadius = 5.f;
    self.copBtnThr.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
