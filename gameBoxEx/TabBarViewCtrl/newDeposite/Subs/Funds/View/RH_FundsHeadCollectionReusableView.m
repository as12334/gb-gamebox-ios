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
    self.totalMoneyLab.text = [NSString stringWithFormat:@"￥%@",MineSettingInfo.showTotalAssets];
    self.walletBalanceLab.text =[NSString stringWithFormat:@"￥%@",MineSettingInfo.showWalletBalance];
}

@end
