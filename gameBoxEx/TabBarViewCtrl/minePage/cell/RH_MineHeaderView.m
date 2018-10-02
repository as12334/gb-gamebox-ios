//
//  RH_MineHeaderView.m
//  gameBoxEx
//
//  Created by paul on 2018/9/30.
//  Copyright © 2018 luis. All rights reserved.
//

#import "RH_MineHeaderView.h"
#import "coreLib.h"
#import "RH_UserInfoManager.h"
@implementation RH_MineHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)createInstanceMineHeaderView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}
-(void)awakeFromNib{
    [super  awakeFromNib];
    if (iPhoneX||iPhoneXR||iPhoneXSM) {
        self.topViewConstraintHeight.constant = 24;
        [self layoutIfNeeded];
    }
    
}
- (IBAction)buttonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mineHeaderViewButtonClickWithTag:)]) {
        [self.delegate mineHeaderViewButtonClickWithTag:sender.tag];
    }
}
-(void)updateCell
{
    self.userName_label.text = MineSettingInfo.mUserName ;
    CGFloat totalMoney = MineSettingInfo.mTotalAssets;
    NSString *totalMoneyStr = [NSString stringWithFormat:@"¥ %.2f",totalMoney];
    self.totalAmount_label.text = [self countNumAndChangeformat:totalMoneyStr];
    
    CGFloat walletBalance = MineSettingInfo.mWalletBalance;
    NSString *walletBalanceStr = [NSString stringWithFormat:@"¥ %.2f",walletBalance];
    self.balance_label.text = [self countNumAndChangeformat:walletBalanceStr];
    
    //    self.label_TotalMoney.text = [NSString stringWithFormat:@"¥ %.2f",MineSettingInfo.mTotalAssets];
    //    self.label_leftMoney.text = [NSString stringWithFormat:@"¥ %.2f",MineSettingInfo.mWalletBalance];
    self.logonTime_label.text = MineSettingInfo.mLoginTime ;
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:MineSettingInfo.showAvatalURL]
                            placeholderImage:ImageWithName(@"touxiang") options:SDWebImageAllowInvalidSSLCertificates] ;
}

-(NSString *)countNumAndChangeformat:(NSString *)num
{
    if([num rangeOfString:@"."].location !=NSNotFound) //这个判断是判断有没有小数点如果有小数点，需特别处理，经过处理再拼接起来
    {
        //        NSString *losttotal = [NSString stringWithFormat:@"%.2f",[num floatValue]];//小数点后只保留两位
        NSArray *array = [num componentsSeparatedByString:@"."];
        //小数点前:array[0]
        //小数点后:array[1]
        int count = 0;
        num = array[0];
        long long int a = num.longLongValue;
        while (a != 0)
        {
            count++;
            a /= 10;
        }
        NSMutableString *string = [NSMutableString stringWithString:num];
        NSMutableString *newstring = [NSMutableString string];
        while (count > 3) {
            count -= 3;
            NSRange rang = NSMakeRange(string.length - 3, 3);
            NSString *str = [string substringWithRange:rang];
            [newstring insertString:str atIndex:0];
            [newstring insertString:@"," atIndex:0];
            [string deleteCharactersInRange:rang];
        }
        [newstring insertString:string atIndex:0];
        NSMutableString *newString = [NSMutableString string];
        newString =[NSMutableString stringWithFormat:@"%@.%@",newstring,array[1]];
        return newString;
    }else {
        int count = 0;
        long long int a = num.longLongValue;
        while (a != 0)
        {
            count++;
            a /= 10;
        }
        NSMutableString *string = [NSMutableString stringWithString:num];
        NSMutableString *newstring = [NSMutableString string];
        while (count > 3) {
            count -= 3;
            NSRange rang = NSMakeRange(string.length - 3, 3);
            NSString *str = [string substringWithRange:rang];
            [newstring insertString:str atIndex:0];
            [newstring insertString:@"," atIndex:0];
            [string deleteCharactersInRange:rang];
        }
        [newstring insertString:string atIndex:0];
        newstring =[NSMutableString stringWithFormat:@"%@.00",newstring];
        return newstring;
    }
}

@end
