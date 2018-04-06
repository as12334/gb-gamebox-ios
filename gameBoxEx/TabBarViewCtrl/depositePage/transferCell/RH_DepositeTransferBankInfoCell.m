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

@end
@implementation RH_DepositeTransferBankInfoCell
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_DepositeTransferListModel *listModel = ConvertToClassPointer(RH_DepositeTransferListModel, context);
    self.bankCardNumLabel.text = [NSString stringWithFormat:@"%@",listModel.mAccount];
    self.bankCardNameLabel.text = listModel.mBankName;
    self.bankAdressLabel.text = listModel.mOpenAcountName;
    [self.infoImageView sd_setImageWithURL:[NSURL URLWithString:listModel.accountImgCover]];
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
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    [pboard setString:self.bankCardNumLabel.text];
//    pboard.string = self.bankCardNumLabel.text;
    showMessage(self, @"复制成功",nil);

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
