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
@interface RH_DepositeTransferPayAdressCell()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet CLBorderView *downLineView;

@end
@implementation RH_DepositeTransferPayAdressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.downLineView.backgroundColor =colorWithRGB(242, 242, 242);
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    NSString *nameStr = ConvertToClassPointer(NSString, context);
    self.payTextfield.delegate = self;
    if ([nameStr isEqualToString:@"other"]) {
        self.payLabel.text = @"订单号后五位";
        self.payTextfield.placeholder = @"请填“订单号”，非商户订单号";
    }
    else if ([nameStr isEqualToString:@"company"]){
        self.payLabel.text = @"存款人";
        self.payTextfield.placeholder = @"转账账号对应的姓名";
    }
    else if ([nameStr isEqualToString:@"wechat"]){
        self.payLabel.text = @"订单号后五位";
        self.payTextfield.placeholder = @"请填写“商户订单号”";
    }
    else if ([nameStr isEqualToString:@"alipay"]){
        self.payLabel.text = @"订单号后五位";
        self.payTextfield.placeholder = @"请填入“商户订单号”";
    }
    else if ([nameStr isEqualToString:@"qq"]){
        self.payLabel.text = @"订单号后五位";
        self.payTextfield.placeholder = @"请填写“商户订单号”";
    }
    else if ([nameStr isEqualToString:@"jd"]){
        self.payLabel.text = @"订单号后五位";
        self.payTextfield.placeholder = @"请填写“商户订单号”";
    }
    else if ([nameStr isEqualToString:@"bd"]){
        self.payLabel.text = @"订单号后五位";
        self.payTextfield.placeholder = @"请填写“商户订单号”";
    }
    else if ([nameStr isEqualToString:@"oneCodePay"]){
        self.payLabel.text = @"订单号后五位";
        self.payTextfield.placeholder = @"请填写商户订单号";
    }
    else if ([nameStr isEqualToString:@"counter"]){
        self.payLabel.text = @"存款地点";
        self.payTextfield.placeholder = @"请填入存款地点";
    }
    
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.adressStr = self.payTextfield.text;
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    ifRespondsSelector(self.delegate, @selector(depositeTransferPayAdressCellSelecteUpframe:)){
        [self.delegate depositeTransferPayAdressCellSelecteUpframe:self];
    }
    return YES;
}
@end
