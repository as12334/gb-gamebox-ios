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
#import "RH_DepositeTransferChannelModel.h"
@interface RH_DepositeTransferPayWayCell()<UITextFieldDelegate>



@property (weak, nonatomic) IBOutlet CLBorderView *upLineView;
@property (weak, nonatomic) IBOutlet CLBorderView *downLineView;
@property (nonatomic,strong)NSString *nameString;
@end
@implementation RH_DepositeTransferPayWayCell
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    NSArray *array = ConvertToClassPointer(NSArray, context);
    self.nameString = array[2];
    self.payNumTextfield.delegate=self;
    if ([self.nameString isEqualToString:@"other"]) {
        self.payWayLabel.text = @"您的其他方式账号";
        self.payNumTextfield.placeholder = @"请填写其他方式账号";
    }
    else if ([self.nameString isEqualToString:@"company"]){
        self.payWayLabel.text = @"存款方式";
        self.payNumTextfield.placeholder = @"网银存款";
        self.payNumTextfield.userInteractionEnabled = NO;
    }
    else if ([self.nameString isEqualToString:@"wechat"]){
        self.payWayLabel.text = @"您的微信昵称";
        self.payNumTextfield.placeholder = @"如：陈XX";
    }
    else if ([self.nameString isEqualToString:@"alipay"]){
        self.payWayLabel.text = @"您的支付户名";
        self.payNumTextfield.placeholder = @"请填写存款时的真实姓名";
    }
    else if ([self.nameString isEqualToString:@"qq"]){
        self.payWayLabel.text = @"您的QQ钱包账号";
        self.payNumTextfield.placeholder = @"请填写QQ号码";
    }
    else if ([self.nameString isEqualToString:@"jd"]){
        self.payWayLabel.text = @"您的京东账号";
        self.payNumTextfield.placeholder = @"请填写京东账号";
    }
    else if ([self.nameString isEqualToString:@"bd"]){
        self.payWayLabel.text = @"您的百度账号";
        self.payNumTextfield.placeholder = @"请填写百度账号";
    }
    else if ([self.nameString isEqualToString:@"onecodepay"]){
        self.payWayLabel.text = @"订单后五位";
        self.payNumTextfield.placeholder = @"请填写商户订单号(非必填)";
    }
    else if ([self.nameString isEqualToString:@"counter"]){
        self.payWayLabel.text = @"存款方式";
        self.payNumTextfield.placeholder = ((RH_DepositeTansferCounterModel *)(array[3][0])).mName;
        if ([self.transferLabel.text isEqualToString:@""]) {
            self.transferLabel.text =((RH_DepositeTansferCounterModel *)(array[3][0])).mName;
        }
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
