//
//  RH_FundsHeadCollectionReusableView.m
//  gameBoxEx
//
//  Created by jun on 2018/9/28.
//  Copyright © 2018 luis. All rights reserved.
//

#import "RH_FundsHeadCollectionReusableView.h"
#import "RH_UserInfoManager.h"
@interface RH_FundsHeadCollectionReusableView()
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *walletBalanceLab;

@end
@implementation RH_FundsHeadCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSString *totalAssets = [self countNumAndChangeformat:MineSettingInfo.showTotalAssets];
    self.totalMoneyLab.text = [NSString stringWithFormat:@"￥%@",totalAssets];
    
    NSString *walletBalance = [self countNumAndChangeformat:MineSettingInfo.showTotalAssets];
    self.walletBalanceLab.text =[NSString stringWithFormat:@"￥%@",walletBalance];
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
