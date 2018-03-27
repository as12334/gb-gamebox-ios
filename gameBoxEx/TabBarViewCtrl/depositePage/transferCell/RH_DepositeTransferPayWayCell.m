//
//  RH_DepositeTransferPayWayCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeTransferPayWayCell.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_DepositePayAccountModel.h"
#import "RH_DepositeTransferModel.h"
@interface RH_DepositeTransferPayWayCell()
@property (weak, nonatomic) IBOutlet UILabel *payWayLabel;
@property (weak, nonatomic) IBOutlet UITextField *payNumTextfield;

@end
@implementation RH_DepositeTransferPayWayCell
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    NSArray *array = ConvertToClassPointer(NSArray, context);
    RH_DepositePayAccountModel *accountModel = ConvertToClassPointer(RH_DepositePayAccountModel, array[1]);
    if ([array[0] isEqualToString:@"other"]) {
        self.payWayLabel.text = @"您的其他方式账号";
        self.payNumTextfield.placeholder = @"请填写其他方式账号";
    }
    else if ([array[0] isEqualToString:@"company"]){
        self.payWayLabel.text = @"存款方式";
        self.payNumTextfield.placeholder = @"网银存款";
    }
    else if ([array[0] isEqualToString:@"wechat"]){
        self.payWayLabel.text = @"您的微信昵称";
        self.payNumTextfield.placeholder = @"如：陈XX";
    }
    else if ([array[0] isEqualToString:@"alipay"]){
        self.payWayLabel.text = @"您的支付户名";
        self.payNumTextfield.placeholder = @"请填写存款时的真实姓名";
    }
    else if ([array[0] isEqualToString:@"qqWallet"]){
        self.payWayLabel.text = @"您的QQ钱包账号";
        self.payNumTextfield.placeholder = @"请填写QQ号码";
    }
    else if ([array[0] isEqualToString:@"jdPay"]){
        self.payWayLabel.text = @"您的京东账号";
        self.payNumTextfield.placeholder = @"请填写京东账号";
    }
    else if ([array[0] isEqualToString:@"baifuPay"]){
        self.payWayLabel.text = @"您的百度账号";
        self.payNumTextfield.placeholder = @"请填写百度账号";
    }
    else if ([array[0] isEqualToString:@"oneCodePay"]){
        self.payWayLabel.text = @"订单后五位";
        self.payNumTextfield.placeholder = @"请填写商户订单号";
    }
    else if ([array[0] isEqualToString:@"counter"]){
        self.payWayLabel.text = @"存款方式";
        self.payNumTextfield.placeholder = @"柜台现金存款";
    }
  
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
