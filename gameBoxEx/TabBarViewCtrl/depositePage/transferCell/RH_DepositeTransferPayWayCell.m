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
@interface RH_DepositeTransferPayWayCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *payWayLabel;

@property (weak, nonatomic) IBOutlet UITextField *transferTextField;
@property (weak, nonatomic) IBOutlet CLBorderView *upLineView;
@property (weak, nonatomic) IBOutlet CLBorderView *downLineView;

@end
@implementation RH_DepositeTransferPayWayCell
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    NSString *nameString = ConvertToClassPointer(NSString, context);
    self.payNumTextfield.delegate=self;
    if ([nameString isEqualToString:@"other"]) {
        self.payWayLabel.text = @"您的其他方式账号";
        self.payNumTextfield.placeholder = @"请填写其他方式账号";
    }
    else if ([nameString isEqualToString:@"company"]){
        self.payWayLabel.text = @"存款方式";
        self.payNumTextfield.placeholder = @"网银存款";
    }
    else if ([nameString isEqualToString:@"wechat"]){
        self.payWayLabel.text = @"您的微信昵称";
        self.payNumTextfield.placeholder = @"如：陈XX";
    }
    else if ([nameString isEqualToString:@"alipay"]){
        self.payWayLabel.text = @"您的支付户名";
        self.payNumTextfield.placeholder = @"请填写存款时的真实姓名";
    }
    else if ([nameString isEqualToString:@"qq"]){
        self.payWayLabel.text = @"您的QQ钱包账号";
        self.payNumTextfield.placeholder = @"请填写QQ号码";
    }
    else if ([nameString isEqualToString:@"jd"]){
        self.payWayLabel.text = @"您的京东账号";
        self.payNumTextfield.placeholder = @"请填写京东账号";
    }
    else if ([nameString isEqualToString:@"bd"]){
        self.payWayLabel.text = @"您的百度账号";
        self.payNumTextfield.placeholder = @"请填写百度账号";
    }
    else if ([nameString isEqualToString:@"onecodepay"]){
        self.payWayLabel.text = @"订单后五位";
        self.payNumTextfield.placeholder = @"请填写商户订单号";
    }
    else if ([nameString isEqualToString:@"counter"]){
        self.payWayLabel.text = @"存款方式";
        self.payNumTextfield.placeholder = @"柜台现金存款";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pulldownListView)];
        self.transferLabel.userInteractionEnabled = YES;
        [self.transferLabel addGestureRecognizer:tap];
        [self.transferLabel setHidden:NO];
        [self.transferTextField setHidden:YES];
    }
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.paywayString = self.payNumTextfield.text;
    NSLog(@"%@",self.paywayString);
    return YES;
}
-(void)pulldownListView{
    ifRespondsSelector(self.delegate, @selector(depositeTransferPaywayCellSelectePullDownView:)){
        [self.delegate depositeTransferPaywayCellSelectePullDownView:self.transferLabel.frame];
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    ifRespondsSelector(self.delegate, @selector(depositeTransferPaywayCellSelecteUpframe:)){
        [self.delegate depositeTransferPaywayCellSelecteUpframe:self];
    }
    return YES;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.upLineView.backgroundColor = colorWithRGB(242, 242, 242);
    self.downLineView.backgroundColor = colorWithRGB(242, 242, 242);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
