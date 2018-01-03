//
//  RH_UserInfoTotalCell.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/25.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_UserInfoTotalCell.h"
#import "coreLib.h"
#import "RH_UserBalanceGroupModel.h"

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
    return 88.0f;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor clearColor] ;
    self.tBalanceView.backgroundColor = [UIColor clearColor] ;
    self.tBalanceView.borderMask = CLBorderMarkBottom ;
    self.tBalanceView.borderColor = colorWithRGB(242, 242, 242) ;
    self.tBalanceView.borderLineInset = UIEdgeInsetsMake(0, 15, 0, 0) ;
    
    self.tWalletView.backgroundColor = [UIColor clearColor] ;
    self.tWalletView.borderMask = CLBorderMarkBottom ;
    self.tWalletView.borderColor = colorWithRGB(242, 242, 242)  ;
    self.tWalletView.borderLineInset = UIEdgeInsetsMake(0, 0, 0, 0) ;
    
    self.balanceBGView.backgroundColor = colorWithRGB(153, 153, 153) ;
    self.balanceBGView.layer.cornerRadius = 5.0f ;
    self.balanceBGView.layer.masksToBounds = YES ;
    self.labTBalance.textColor = [UIColor whiteColor] ;
    self.labTBalance.font = [UIFont systemFontOfSize:15.0f] ;
    
    self.walletBGView.backgroundColor = colorWithRGB(153, 153, 153) ;
    self.walletBGView.layer.cornerRadius = 5.0f ;
    self.walletBGView.layer.masksToBounds = YES ;
    self.labTWallet.textColor = [UIColor whiteColor] ;
    self.labTWallet.font = [UIFont systemFontOfSize:19.0f] ;
    
    self.labTBalanceValue.textColor = colorWithRGB(51, 51, 51) ;
    self.labTBalanceValue.font = [UIFont systemFontOfSize:15.0f] ;
    self.labTWalletValue.textColor = colorWithRGB(51, 51, 51) ;
    self.labTWalletValue.font = [UIFont systemFontOfSize:15.0f] ;
    
    self.labTBalance.text = @"总资产" ;
    self.labTBalanceValue.text = @"" ;
    self.labTWallet.text = @"钱包"    ;
    self.labTWalletValue.text = @""  ;
    
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_UserBalanceGroupModel *userBalanceGroupModel = ConvertToClassPointer(RH_UserBalanceGroupModel, context) ;
    if (userBalanceGroupModel){
        self.labTBalanceValue.text = userBalanceGroupModel.mAssets ;
        self.labTWalletValue.text = userBalanceGroupModel.mBalance ;
    }
}


@end
