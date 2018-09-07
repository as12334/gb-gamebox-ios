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
        self.labTBalanceValue.text = mineInfoModel.showTotalAssets ;
        self.labTWalletValue.text = mineInfoModel.showWalletBalance ;
    }
}




@end
