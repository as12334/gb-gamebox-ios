//
//  RH_NavigationUserInfoView.m
//  gameBoxEx
//
//  Created by luis on 2017/12/24.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_NavigationUserInfoView.h"
#import "RH_UserInfoManager.h"
#import "coreLib.h"
#import "RH_MineInfoModel.h"

@interface RH_NavigationUserInfoView ()
@property (nonatomic,strong) IBOutlet UILabel *labUserName ;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

@property (nonatomic,strong) IBOutlet UIButton *btnCover ;
@end

@implementation RH_NavigationUserInfoView

-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.backgroundColor = [UIColor clearColor] ;
    self.moreImageView.whc_RightSpace(0).whc_CenterY(0).whc_Width(3).whc_Height(20);
    self.labUserName.whc_RightSpaceToView(3, self.moreImageView).whc_CenterY(-7).whc_WidthAuto().whc_HeightAuto();
    
    
    
    self.labUserName.textColor = RH_NavigationBar_ForegroundColor ;
    self.labUserName.font = [UIFont systemFontOfSize:10.0f] ;
    self.labBalance.textColor = RH_NavigationBar_ForegroundColor ;
    self.labBalance.font = [UIFont systemFontOfSize:10.0f] ;
    self.labUserName.text = @"";
    self.labBalance.text = @"" ;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotificatin:)
                                                 name:RHNT_UserInfoManagerMineGroupChangedNotification object:nil] ;
    [self updateUI] ;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

-(void)updateUI
{
    RH_MineInfoModel *userInfoModel = MineSettingInfo ;
    if (userInfoModel){
        self.labUserName.text = userInfoModel.mUserName ;
        self.labBalance.whc_RightSpaceToView(3, self.moreImageView).whc_TopSpaceToView(0, self.labUserName).whc_WidthAuto().whc_Height(15);
        self.leftImageView.whc_RightSpaceToView(2, self.labBalance).whc_TopSpaceToView(4, self.labUserName).whc_Width(6).whc_Height(6);
        if ([userInfoModel.showTotalAssets isEqualToString:@"0.00"]) {
            self.labBalance.text =  [NSString stringWithFormat:@"%@%@",userInfoModel.mCurrency,userInfoModel.showTotalAssets] ;
        } else {
            self.labBalance.text = [NSString stringWithFormat:@"%@%@",userInfoModel.mCurrency,[self countNumAndChangeformat:userInfoModel.showTotalAssets]];
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

#pragma mark-
-(UIButton *)buttonCover
{
    return self.btnCover ;
}

#pragma mark-
-(void)handleNotificatin:(NSNotification*)nt
{
    if ([nt.name isEqualToString:RHNT_UserInfoManagerMineGroupChangedNotification]){
        [self performSelectorOnMainThread:@selector(updateUI) withObject:self waitUntilDone:NO] ;
    }
}
@end
