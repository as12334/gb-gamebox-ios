//
//  RH_DepositeTransferPayAdressCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/26.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeTransferPayAdressCell.h"
#import "RH_DepositePayAccountModel.h"
#import "coreLib.h"
@interface RH_DepositeTransferPayAdressCell()
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UITextField *payTextfield;

@end
@implementation RH_DepositeTransferPayAdressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    NSArray *array = ConvertToClassPointer(NSArray, context);
    RH_DepositePayAccountModel *accountModel = ConvertToClassPointer(RH_DepositePayAccountModel, array[1]);
    if ([array[0] isEqualToString:@"other"]) {
        self.payLabel.text = @"订单号后五位";
        self.payTextfield.placeholder = @"请填“订单号”，非商户订单号";
    }
    else if ([array[0] isEqualToString:@"company"]){
        self.payLabel.text = @"存款人";
        self.payTextfield.placeholder = @"转账账号对应的姓名";
    }
    else if ([array[0] isEqualToString:@"wechat"]){
        self.payLabel.text = @"订单号后五位";
        self.payTextfield.placeholder = @"请填写“商户订单号”";
    }
    else if ([array[0] isEqualToString:@"alipay"]){
        self.payLabel.text = @"订单号后五位";
        self.payTextfield.placeholder = @"请填入“商户订单号”";
    }
    else if ([array[0] isEqualToString:@"qqWallet"]){
        self.payLabel.text = @"订单号后五位";
        self.payTextfield.placeholder = @"请填写“商户订单号”";
    }
    else if ([array[0] isEqualToString:@"jdPay"]){
        self.payLabel.text = @"订单号后五位";
        self.payTextfield.placeholder = @"请填写“商户订单号”";
    }
    else if ([array[0] isEqualToString:@"baifuPay"]){
        self.payLabel.text = @"订单号后五位";
        self.payTextfield.placeholder = @"请填写“商户订单号”";
    }
    else if ([array[0] isEqualToString:@"oneCodePay"]){
        self.payLabel.text = @"订单后五位";
        self.payTextfield.placeholder = @"请填写商户订单号";
    }
    else if ([array[0] isEqualToString:@"counter"]){
        self.payLabel.text = @"存款地点";
        self.payTextfield.placeholder = @"请填入存款地点";
    }
    
}

@end
