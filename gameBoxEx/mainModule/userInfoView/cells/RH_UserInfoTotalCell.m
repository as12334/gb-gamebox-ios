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
    self.tBalanceView.borderColor = colorWithRGB(204, 204, 204) ;
    self.tBalanceView.borderLineInset = UIEdgeInsetsMake(0, 10, 0, 0) ;
    
    self.tWalletView.backgroundColor = [UIColor clearColor] ;
    self.tWalletView.borderMask = CLBorderMarkBottom ;
    self.tWalletView.borderColor = colorWithRGB(204, 204, 204)  ;
    self.tWalletView.borderLineInset = UIEdgeInsetsMake(0, 0, 0, 0) ;
    
    self.balanceBGView.backgroundColor = colorWithRGB(27, 117, 217) ;
    self.balanceBGView.layer.cornerRadius = 5.0f ;
    self.balanceBGView.layer.masksToBounds = YES ;

    
    self.labTBalance.textColor = [UIColor whiteColor] ;
    self.labTBalance.font = [UIFont systemFontOfSize:12.0f] ;
    
    self.labTBalanceValue.font = [UIFont systemFontOfSize:12.f];
    self.labTBalanceValue.textColor = colorWithRGB(27, 117, 217);
    
    self.walletBGView.backgroundColor = colorWithRGB(14, 195, 146) ;
    self.walletBGView.layer.cornerRadius = 5.0f ;
    self.walletBGView.layer.masksToBounds = YES ;
    self.labTWallet.textColor = [UIColor whiteColor] ;
    self.labTWallet.font = [UIFont systemFontOfSize:12.0f] ;
    
    self.labTBalanceValue.textColor = colorWithRGB(27, 117, 217) ;
    self.labTBalanceValue.font = [UIFont systemFontOfSize:15.0f] ;
    self.labTWalletValue.textColor = colorWithRGB(14, 195, 146) ;
    self.labTWalletValue.font = [UIFont systemFontOfSize:12.0f] ;
    
    self.labTBalance.text = @"总资产" ;   //
    self.labTBalanceValue.text = @"" ;
    self.labTWallet.text = @"钱包"    ;  //
    self.labTWalletValue.text = @""  ;   //

//    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine ;
//    self.separatorLineColor = colorWithRGB(204, 204, 204) ;
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
