//
//  RH_LimitTransferCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_LimitTransferCell.h"
#import "coreLib.h"
#import "RH_UserInfoManager.h"
#import "RH_UserGroupInfoModel.h"

@implementation RH_LimitTransferCell
{
    UILabel *titleLab ; //标题
    UILabel *amountLab; //金额
    UIButton *refreshBtnAndrecycleBtn ; // 单个刷新&回收
    RH_UserApiBalanceModel *userApiBalance ;
}

+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return 40.0f ;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI] ;
    }
    return self ;
}


-(void)setUpUI
{
    titleLab = [[UILabel alloc] init] ;
    [self.contentView addSubview:titleLab];
    titleLab.whc_LeftSpace(10).whc_CenterY(0).whc_WidthAuto().whc_HeightAuto() ;
    titleLab.text = @"";
    titleLab.font = [UIFont systemFontOfSize:14.f] ;
    
    refreshBtnAndrecycleBtn = [[UIButton alloc] init];
    [self.contentView addSubview:refreshBtnAndrecycleBtn];
    refreshBtnAndrecycleBtn.whc_RightSpace(10).whc_CenterY(0).whc_HeightAuto().whc_WidthAuto();
    [refreshBtnAndrecycleBtn setTitleColor:colorWithRGB(153, 153, 153) forState:UIControlStateNormal];
    [refreshBtnAndrecycleBtn addTarget:self action:@selector(refreshBtnAndrecycleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    refreshBtnAndrecycleBtn.titleLabel.font = [UIFont systemFontOfSize:14.f] ;
    if ([THEMEV3 isEqualToString:@"green"]){
        [refreshBtnAndrecycleBtn setTitleColor:colorWithRGB(4, 109, 79) forState:UIControlStateNormal] ;
    }else if ([THEMEV3 isEqualToString:@"red"]){
        [refreshBtnAndrecycleBtn setTitleColor:RH_NavigationBar_BackgroundColor_Red forState:UIControlStateNormal] ;
    }else if ([THEMEV3 isEqualToString:@"black"]){
        [refreshBtnAndrecycleBtn setTitleColor:RH_NavigationBar_BackgroundColor_Black forState:UIControlStateNormal] ;
    }else if ([THEMEV3 isEqualToString:@"red_white"]){
        [refreshBtnAndrecycleBtn setTitleColor:RH_NavigationBar_BackgroundColor_Red_White forState:UIControlStateNormal] ;
    }else if ([THEMEV3 isEqualToString:@"green_white"]){
        [refreshBtnAndrecycleBtn setTitleColor:RH_NavigationBar_BackgroundColor_Green_White forState:UIControlStateNormal] ;
    }else if ([THEMEV3 isEqualToString:@"orange_white"]){
        [refreshBtnAndrecycleBtn setTitleColor:RH_NavigationBar_BackgroundColor_Orange_White forState:UIControlStateNormal] ;
    }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
        [refreshBtnAndrecycleBtn setTitleColor:RH_NavigationBar_BackgroundColor_Coffee_White forState:UIControlStateNormal] ;
    }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
        [refreshBtnAndrecycleBtn setTitleColor:RH_NavigationBar_BackgroundColor_Coffee_Black forState:UIControlStateNormal] ;
    }else{
        [refreshBtnAndrecycleBtn setTitleColor:RH_NavigationBar_BackgroundColor_Black forState:UIControlStateNormal] ;
    }
    
    amountLab = [[UILabel alloc] init] ;
    [self.contentView addSubview:amountLab];
    amountLab.whc_RightSpaceToView(10, refreshBtnAndrecycleBtn).whc_CenterY(0).whc_HeightAuto().whc_WidthAuto() ;
    amountLab.text = @"";
    amountLab.font = [UIFont systemFontOfSize:14.f] ;
    amountLab.textColor = colorWithRGB(153, 153, 153) ;
    
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine;
    self.separatorLineWidth = 1.0f;
    self.separatorLineColor = colorWithRGB(226, 226, 226);
    self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0) ;
    
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_MineInfoModel *infoModel = [RH_UserInfoManager shareUserManager].mineSettingInfo;
    
    userApiBalance = ConvertToClassPointer(RH_UserApiBalanceModel, context) ;
    if (userApiBalance){
        titleLab.text = userApiBalance.mApiName ;
        
        if (![userApiBalance.mStatus isEqualToString:@""]) {
            amountLab.text = userApiBalance.mStatus ;
        }else
        {
//            amountLab.text = [NSString stringWithFormat:@"%.2f",userApiBalance.mBalance] ;
            CGFloat balance = userApiBalance.mBalance;
            NSString *balanceStr = [NSString stringWithFormat:@"%.2f",balance];
            amountLab.text = [self countNumAndChangeformat:balanceStr];
        }
    }
    if (infoModel) {
        if (infoModel.mIsAutoPay) {
            [refreshBtnAndrecycleBtn setTitle:@"回收" forState:UIControlStateNormal];
        }else
        {
            [refreshBtnAndrecycleBtn setImage:ImageWithName(@"mine_refresh_icon") forState:UIControlStateNormal];
             [refreshBtnAndrecycleBtn setTitle:nil forState:UIControlStateNormal];
        }
    }
}
-(void)updateCellWithInfoModel:(RH_UserApiBalanceModel *)model
{
    dispatch_async(dispatch_get_main_queue(), ^{
//     amountLab.text = [NSString stringWithFormat:@"%.2f",model.mBalance] ;
        CGFloat balance = model.mBalance;
        NSString *balanceStr = [NSString stringWithFormat:@"%.2f",balance];
        amountLab.text = [self countNumAndChangeformat:balanceStr];
    });
    
}
-(void)updateRecoryDataCellWithInfoContext:(id)context
{
    RH_UserApiBalanceModel *model = ConvertToClassPointer(RH_UserApiBalanceModel, context) ;
    if (model){
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat balance = model.mBalance;
            NSString *balanceStr = [NSString stringWithFormat:@"%.2f",balance];
            amountLab.text = [self countNumAndChangeformat:balanceStr];
//            amountLab.text = [NSString stringWithFormat:@"%.2f",model.mBalance] ;
        });
    }
}
#pragma mark -- 刷新&回收按钮点击
-(void)refreshBtnAndrecycleBtnClick:(UIButton *)sender
{
    ifRespondsSelector(self.delegate, @selector(limitTransferCelRecoryAndRefreshBtnDidTouch:withBtn:withModel:)){
        [self.delegate limitTransferCelRecoryAndRefreshBtnDidTouch:self withBtn:sender withModel:userApiBalance] ;
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
