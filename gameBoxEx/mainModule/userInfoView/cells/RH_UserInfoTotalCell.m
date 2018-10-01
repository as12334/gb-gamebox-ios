//
//  RH_UserInfoTotalCell.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/25.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_UserInfoTotalCell.h"
#import "coreLib.h"
#import "RH_MineInfoModel.h"

@interface RH_UserInfoTotalCell()
@property (weak, nonatomic) IBOutlet CLBorderView  *tBalanceView  ;
@property (weak, nonatomic) IBOutlet UIView  *balanceBGView  ;
@property (weak, nonatomic) IBOutlet UILabel  *labTBalance  ;
@property (weak, nonatomic) IBOutlet UILabel  *labTBalanceValue ;
@property (weak, nonatomic) IBOutlet CLBorderView  *tWalletView  ;
@property (weak, nonatomic) IBOutlet UIView  *walletBGView    ;
@property (weak, nonatomic) IBOutlet UILabel  *labTWallet  ;
@property (weak, nonatomic) IBOutlet UILabel  *labTWalletValue ;

@end
@implementation RH_UserInfoTotalCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return 68.0f;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor clearColor] ;
    self.tBalanceView.backgroundColor = [UIColor clearColor] ;
    self.tBalanceView.borderMask = CLBorderMarkBottom ;
    self.tBalanceView.borderColor = [UIColor lightGrayColor] ;
    self.tBalanceView.borderLineInset = UIEdgeInsetsMake(0, 0, 0, 0) ;
    
    self.tWalletView.backgroundColor = [UIColor clearColor] ;
    self.tWalletView.borderMask = CLBorderMarkBottom ;
    self.tWalletView.borderColor = [UIColor lightGrayColor] ;
    self.tWalletView.borderLineInset = UIEdgeInsetsMake(0, 0, 0, 0) ;
    
//    self.balanceBGView.layer.cornerRadius = 5.0f ;
//    self.balanceBGView.layer.masksToBounds = YES ;

    self.balanceBGView.backgroundColor = colorWithRGB(68, 68, 68);
    
    self.labTBalance.textColor = [UIColor lightGrayColor] ;
    self.labTBalance.font = [UIFont systemFontOfSize:12.0f] ;
    
    self.walletBGView.backgroundColor = colorWithRGB(68, 68, 68) ;
//    self.walletBGView.layer.cornerRadius = 5.0f ;
//    self.walletBGView.layer.masksToBounds = YES ;
    self.labTWallet.textColor = [UIColor lightGrayColor] ;
    self.labTWallet.font = [UIFont systemFontOfSize:12.0f] ;
    
    self.labTBalance.text = @"总余额" ;   //
    self.labTBalanceValue.text = @"" ;
    self.labTWallet.text = @"中心钱包"    ;  //
    self.labTWalletValue.text = @""  ;   //
    
    self.tWalletView.backgroundColor = colorWithRGB(68, 68, 68) ;
    self.tBalanceView.backgroundColor = colorWithRGB(68, 68, 68) ;
    
    self.labTBalanceValue.textColor =   [UIColor lightGrayColor];
    self.labTWalletValue.textColor = [UIColor lightGrayColor];
    
//    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine ;
//    self.separatorLineColor = colorWithRGB(204, 204, 204) ;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_MineInfoModel *mineInfoModel = ConvertToClassPointer(RH_MineInfoModel, context) ;
    if (mineInfoModel){
        
        if ([mineInfoModel.showTotalAssets isEqualToString:@"0.00"]) {
                    self.labTBalanceValue.text = [NSString stringWithFormat:@"¥%@",mineInfoModel.showTotalAssets] ;
        } else {
            self.labTBalanceValue.text = [NSString stringWithFormat:@"¥%@",[self countNumAndChangeformat:mineInfoModel.showTotalAssets]];
        }
        
        if ([mineInfoModel.showWalletBalance isEqualToString:@"0.00"]) {
                    self.labTWalletValue.text = [NSString stringWithFormat:@"¥%@",mineInfoModel.showWalletBalance] ;
        } else {
            self.labTWalletValue.text = [NSString stringWithFormat:@"¥%@",[self countNumAndChangeformat:mineInfoModel.showWalletBalance]];
        }
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
