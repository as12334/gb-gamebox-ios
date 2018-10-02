//
//  RH_DepositeTransferWXinInfoCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeTransferWXinInfoCell.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_DepositeTransferChannelModel.h"
@interface RH_DepositeTransferWXinInfoCell ()
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UIButton *accountInfo;
@property (weak, nonatomic) IBOutlet UIView *accountInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *bankIconImage;
@property (weak, nonatomic) IBOutlet UILabel *personIdNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
@property (weak, nonatomic) IBOutlet CLBorderView *downLineView;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *customBankLabel;
@property (weak, nonatomic) IBOutlet UILabel *aliasNameLabel;

@end
@implementation RH_DepositeTransferWXinInfoCell
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_DepositeTransferListModel *listModel = ConvertToClassPointer(RH_DepositeTransferListModel, context);
    self.personIdNumLabel.text = [NSString stringWithFormat:@"%@",listModel.mAccount] ;
    self.customBankLabel.text = listModel.mAliasName;
    self.aliasNameLabel.text = listModel.mCustomBankName;
    if (listModel.mAccount.length>15) {
        self.personIdNumLabel.font = [UIFont systemFontOfSize:10.f];
    }
    else{
        self.personIdNumLabel.font = [UIFont systemFontOfSize:14.f];
    }
    self.personNameLabel.text = listModel.mFullName;
     [self.bankIconImage sd_setImageWithURL:[NSURL URLWithString:listModel.showCover] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.accountInfo.layer.cornerRadius = 5.f;
    self.accountInfo.layer.masksToBounds = YES;
    self.accountInfoView.layer.cornerRadius = 10.f;
    self.accountInfoView.layer.masksToBounds = YES;
    
    self.btn.layer.cornerRadius = 10.f;
    self.btn.layer.masksToBounds = YES;
    
    self.btn2.layer.cornerRadius = 10.f;
    self.btn2.layer.masksToBounds = YES;
    
    self.btn3.layer.cornerRadius = 10.f;
    self.btn3.layer.masksToBounds = YES;
    
    self.accountInfoView.backgroundColor = colorWithRGB(242, 242, 242);
    self.colorView.backgroundColor = colorWithRGB(23, 102, 204);
    self.downLineView.backgroundColor = colorWithRGB(242, 242, 242);
    [self.personIdNumLabel setTextColor:colorWithRGB(51, 51, 51)];
}
- (IBAction)bankNumCopyClick:(id)sender {
    if (self.personIdNumLabel.text.length==0) {
        return;
    }
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    [pboard setString:self.personIdNumLabel.text];
    UIImage *successImage = [UIImage imageNamed:@"icon_success"];
    showMessageWithImage(self, @"复制成功", nil, successImage);
    
}
- (IBAction)personNameCopyClick:(id)sender {
    if (self.personNameLabel.text.length==0) {
        return;
    }
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    [pboard setString:self.personNameLabel.text];
    UIImage *successImage = [UIImage imageNamed:@"icon_success"];
    showMessageWithImage(self, @"复制成功", nil, successImage);
}
- (IBAction)customCopyBtn:(id)sender {
    if (self.customBankLabel.text.length==0) {
        return;
    }
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    [pboard setString:self.customBankLabel.text];
    UIImage *successImage = [UIImage imageNamed:@"icon_success"];
    showMessageWithImage(self, @"复制成功", nil, successImage);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
