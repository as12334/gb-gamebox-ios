//
//  RH_DepositeTransferBankInfoCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeTransferBankInfoCell.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_DepositeTransferChannelModel.h"
#import "RH_CustomServiceSubViewController.h"
@interface RH_DepositeTransferBankInfoCell()
@property (weak, nonatomic) IBOutlet UIView *bankInfoView;
@property (weak, nonatomic) IBOutlet UIButton *copBtn;
@property (weak, nonatomic) IBOutlet UIButton *copBtnTwo;
@property (weak, nonatomic) IBOutlet UIButton *copBtnThr;
@property (weak, nonatomic) IBOutlet UILabel *bankCardNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankCardNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankAdressLabel;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *accountInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;
@property (weak, nonatomic) IBOutlet UILabel *payNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property(nonatomic,strong) RH_DepositeTransferListModel *listModel;
@end
@implementation RH_DepositeTransferBankInfoCell
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    NSArray *array = ConvertToClassPointer(NSArray, context);
   bool mHide = [array[1] boolValue];
    RH_DepositeTransferListModel *listModel =array[0];
    self.listModel = listModel;
    if (mHide) {
        [self.copBtn setTitle:@"联系客服" forState:UIControlStateNormal];
        self.copBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        self.bankCardNumLabel.text = [NSString stringWithFormat:@"账号代码：%@",listModel.mCode];
    }else{
        self.bankCardNumLabel.text = [NSString stringWithFormat:@"%@",listModel.mAccount];
    }
    self.bankCardNameLabel.text = listModel.mFullName;
    self.bankAdressLabel.text = listModel.mOpenAcountName;
    self.payNameLabel.text = listModel.mPayName;
    if (listModel.mRemark) {
        self.remarkLabel.text = listModel.mRemark;
    }
    
    [self.infoImageView sd_setImageWithURL:[NSURL URLWithString:listModel.showCover] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bankInfoView.layer.cornerRadius = 5.f;
    self.bankInfoView.layer.masksToBounds=YES;
    self.bankInfoView.backgroundColor = colorWithRGB(242, 242, 242);
    self.colorView.backgroundColor = colorWithRGB(23, 102, 204);
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
- (IBAction)cardNumCopySelect:(id)sender {
    
    if (self.listModel.mHide) {
        [self showViewController:[RH_CustomServiceSubViewController viewController]];
    }else{
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        if (self.bankCardNumLabel.text.length==0) {
            return;
        }
        [pboard setString:self.bankCardNumLabel.text];
        //    pboard.string = self.bankCardNumLabel.text;
        showMessage(self, @"复制成功",nil);
    }
    
    

}
- (IBAction)pernameSelect:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    if (self.bankCardNameLabel.text.length==0) {
        return;
    }
    pboard.string = self.bankCardNameLabel.text;
    showMessage(self, @"复制成功",nil);
}
- (IBAction)bankAdressSelect:(id)sender {
    if (self.bankAdressLabel.text.length == 0) {
        return ;
    }
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.bankAdressLabel.text;
    showMessage(self, @"复制成功",nil);
}

@end
