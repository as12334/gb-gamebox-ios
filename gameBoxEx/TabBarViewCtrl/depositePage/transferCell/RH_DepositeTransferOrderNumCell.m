//
//  RH_DepositeTransferOrderNumCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/26.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeTransferOrderNumCell.h"
#import "coreLib.h"
#import "RH_DepositePayAccountModel.h"
@interface RH_DepositeTransferOrderNumCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *payforWayLabel;
@property (weak, nonatomic) IBOutlet UITextField *orderNumTextfiled;

@end
@implementation RH_DepositeTransferOrderNumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    NSString *nameStr = ConvertToClassPointer(NSString, context);
    
    self.orderNumTextfiled.delegate = self;
    if ([nameStr isEqualToString:@"other"]) {
        self.payforWayLabel.text = @"订单号后五位";
        self.orderNumTextfiled.placeholder = @"请填“订单号”，非商户订单号";
    }
    else if ([nameStr isEqualToString:@"company"]){
        self.payforWayLabel.text = @"存款人";
        self.orderNumTextfiled.placeholder = @"转账账号对应的姓名";
    }
    else if ([nameStr isEqualToString:@"wechat"]){
        self.payforWayLabel.text = @"订单号后五位";
        self.orderNumTextfiled.placeholder = @"请填写“商户订单号”";
    }
    else if ([nameStr isEqualToString:@"alipay"]){
        self.payforWayLabel.text = @"您的支付宝账号";
        self.orderNumTextfiled.placeholder = @"请填写支付宝账号";
    }
    else if ([nameStr isEqualToString:@"qq"]){
        self.payforWayLabel.text = @"订单号后五位";
        self.orderNumTextfiled.placeholder = @"请填写“商户订单号”";
    }
    else if ([nameStr isEqualToString:@"jd"]){
        self.payforWayLabel.text = @"订单号后五位";
        self.orderNumTextfiled.placeholder = @"请填写“商户订单号”";
    }
    else if ([nameStr isEqualToString:@"bd"]){
        self.payforWayLabel.text = @"订单号后五位";
        self.orderNumTextfiled.placeholder = @"请填写“商户订单号”";
    }
    else if ([nameStr isEqualToString:@"oneCodePay"]){
        self.payforWayLabel.text = @"订单后五位";
        self.orderNumTextfiled.placeholder = @"请填写商户订单号";
    }
    else if ([nameStr isEqualToString:@"counter"]){
        self.payforWayLabel.text = @"存款人";
        self.orderNumTextfiled.placeholder = @"转账账号对应的姓名";
    }
    
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.self.transferOrderString = self.orderNumTextfiled.text;
    return YES;
}
@end
