//
//  RH_LimitTransferCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_LimitTransferCell.h"
#import "coreLib.h"
#import "RH_UserApiBalanceModel.h"
#import "RH_UserInfoManager.h"
#import "RH_UserGroupInfoModel.h"

@implementation RH_LimitTransferCell
{
    UILabel *titleLab ; //标题
    UILabel *amountLab; //金额
    UIButton *refreshBtnAndrecycleBtn ; // 单个刷新&回收
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
    titleLab.text = @"新霸电子6:";
    titleLab.font = [UIFont systemFontOfSize:14.f] ;
    
    refreshBtnAndrecycleBtn = [[UIButton alloc] init];
    [self.contentView addSubview:refreshBtnAndrecycleBtn];
    refreshBtnAndrecycleBtn.whc_RightSpace(10).whc_CenterY(0).whc_HeightAuto().whc_WidthAuto();
//    [refreshBtnAndrecycleBtn setTitle:@"回收" forState:UIControlStateNormal];
    [refreshBtnAndrecycleBtn setTitleColor:colorWithRGB(153, 153, 153) forState:UIControlStateNormal];
    [refreshBtnAndrecycleBtn addTarget:self action:@selector(refreshBtnAndrecycleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    refreshBtnAndrecycleBtn.titleLabel.font = [UIFont systemFontOfSize:14.f] ;
    if ([THEMEV3 isEqualToString:@"green"]){
        [refreshBtnAndrecycleBtn setTitleColor:RH_NavigationBar_BackgroundColor_Green forState:UIControlStateNormal] ;
    }else if ([THEMEV3 isEqualToString:@"red"]){
        [refreshBtnAndrecycleBtn setTitleColor:RH_NavigationBar_BackgroundColor_Red forState:UIControlStateNormal] ;
    }else if ([THEMEV3 isEqualToString:@"black"]){
        [refreshBtnAndrecycleBtn setTitleColor:RH_NavigationBar_BackgroundColor_Black forState:UIControlStateNormal] ;
    }else{
        [refreshBtnAndrecycleBtn setTitleColor:RH_NavigationBar_BackgroundColor_Black forState:UIControlStateNormal] ;
    }
    
    amountLab = [[UILabel alloc] init] ;
    [self.contentView addSubview:amountLab];
    amountLab.whc_RightSpaceToView(10, refreshBtnAndrecycleBtn).whc_CenterY(0).whc_HeightAuto().whc_WidthAuto() ;
    amountLab.text = @"0.00";
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
    
    RH_UserApiBalanceModel *userApiBalance = ConvertToClassPointer(RH_UserApiBalanceModel, context) ;
    if (userApiBalance){
        titleLab.text = userApiBalance.mApiName ;
        
        if (![userApiBalance.mStatus isEqualToString:@""]) {
            amountLab.text = userApiBalance.mStatus ;
        }else
        {
            amountLab.text = [NSString stringWithFormat:@"%.2f",userApiBalance.mBalance] ;
        }
    }
    
    if (infoModel) {
        if (infoModel.mIsAutoPay) {
            [refreshBtnAndrecycleBtn setTitle:@"回收" forState:UIControlStateNormal];
        }else
        {
            [refreshBtnAndrecycleBtn setImage:ImageWithName(@"home_markcell_image") forState:UIControlStateNormal];
        }
    }
    
}

#pragma mark -- 刷新&回收按钮点击
-(void)refreshBtnAndrecycleBtnClick:(UIButton *)sender
{
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
