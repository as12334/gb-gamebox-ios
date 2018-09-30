//
//  RH_UserInfoGengeralCell.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/25.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_UserInfoGengeralCell.h"
#import "coreLib.h"
#import "RH_UserApiBalanceModel.h"

@interface RH_UserInfoGengeralCell()
@property (weak, nonatomic) IBOutlet UILabel *labTitle          ;
@property (weak, nonatomic) IBOutlet UILabel *labTitleValue     ;

@end
@implementation RH_UserInfoGengeralCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return 30;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor clearColor] ;
    
    // Initialization code
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleNone ;
    
    self.labTitle.text = @"" ;
    self.labTitleValue.text = @"" ;
    if ([THEMEV3 isEqualToString:@"black"]||[THEMEV3 isEqualToString:@"green"]||[THEMEV3 isEqualToString:@"blue"]||[THEMEV3 isEqualToString:@"red"]||[THEMEV3 isEqualToString:@"orange"]||[THEMEV3 isEqualToString:@"coffee_black"]) {
        self.contentView.backgroundColor = colorWithRGB(68, 68, 68) ;
    }
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_UserApiBalanceModel *userApiBalance = ConvertToClassPointer(RH_UserApiBalanceModel, context) ;
    if (userApiBalance.Index == 1) {
        self.contentView.backgroundColor = colorWithRGB(50, 55, 59);
    } else {
        self.contentView.backgroundColor = colorWithRGB(68, 68, 68) ;
    }
    if (userApiBalance){
        self.labTitle.text = userApiBalance.mApiName ;
//        self.labTitleValue.text = [NSString stringWithFormat:@"%.2f",userApiBalance.mBalance] ;
        CGFloat balance =  userApiBalance.mBalance;
        NSString *value = [NSString stringWithFormat:@"%.2f",balance];
        self.labTitleValue.text = [self countNumAndChangeformat:value];
    }
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
