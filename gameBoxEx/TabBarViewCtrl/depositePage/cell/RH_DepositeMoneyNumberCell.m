//
//  RH_DepositeMoneyNumberCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeMoneyNumberCell.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_DepositeTransferChannelModel.h"
@interface RH_DepositeMoneyNumberCell()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UILabel *deposieLabel;
@property (weak, nonatomic) IBOutlet CLBorderView *uplineView;
@property (weak, nonatomic) IBOutlet CLBorderView *downLineView;

@end
@implementation RH_DepositeMoneyNumberCell

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
   RH_DepositeTransferListModel  *listModel = ConvertToClassPointer(RH_DepositeTransferListModel, context);
    self.payMoneyNumLabel.placeholder = [NSString stringWithFormat:@"%ld~%ld",listModel.mSingleDepositMin,listModel.mSingleDepositMax];
    self.payMoneyNumLabel.delegate = self;
    self.moneyNumMin = listModel.mSingleDepositMin;
    self.moneyNumMax = listModel.mSingleDepositMax;
    self.payMoneyNumLabel.textAlignment = NSTextAlignmentCenter;
    if (listModel.mRandomAmount==NO) {
        self.decimalsBtn.hidden = YES;
        [self.decimalsBtn setTitle:@"" forState:UIControlStateNormal];
        self.decimalsBtn.titleLabel.text = nil;
    }
    else if(listModel.mRandomAmount==YES)
    {
        self.decimalsBtn.hidden = NO;
        [self.decimalsBtn setTitle:[NSString stringWithFormat:@"%0.2f",(float)(1+arc4random()%99)/100] forState:UIControlStateNormal];
    }
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    CGFloat sum = [self.payMoneyNumLabel.text integerValue]+[self.decimalsBtn.titleLabel.text floatValue];
    NSString *string = [NSString stringWithFormat:@"%0.2f",sum];
    self.payMoneyString = string;
    return YES;
}
- (IBAction)clickChangedNum:(id)sender {
    [self.decimalsBtn setTitle:[NSString stringWithFormat:@"%0.2f",(float)(1+arc4random()%99)/100] forState:UIControlStateNormal];
}
-(void)setupViewWithContext:(id)context
{
    RH_DepositeTransferListModel  *listModel = ConvertToClassPointer(RH_DepositeTransferListModel, context);
    self.payMoneyNumLabel.placeholder = [NSString stringWithFormat:@"%ld~%ld",listModel.mSingleDepositMin,listModel.mSingleDepositMax];
    self.payMoneyNumLabel.delegate = self;
    self.moneyNumMin = listModel.mSingleDepositMin;
    self.moneyNumMax = listModel.mSingleDepositMax;
    self.payMoneyNumLabel.textAlignment = NSTextAlignmentCenter;
    if (listModel.mRandomAmount==NO) {
        self.decimalsBtn.hidden = YES;
        [self.decimalsBtn setTitle:@"" forState:UIControlStateNormal];
        self.decimalsBtn.titleLabel.text = nil;
    }
    else if(listModel.mRandomAmount==YES)
    {
        self.decimalsBtn.hidden = NO;
        [self.decimalsBtn setTitle:[NSString stringWithFormat:@"%0.2f",(float)(1+arc4random()%99)/100] forState:UIControlStateNormal];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.deposieLabel setTextColor:colorWithRGB(102, 102, 102)];
    self.uplineView.backgroundColor = colorWithRGB(242, 242, 242);
    self.downLineView.backgroundColor = colorWithRGB(242, 242, 242);
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
