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
    return 88.0f;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor clearColor] ;
    self.tBalanceView.backgroundColor = [UIColor clearColor] ;
    self.tBalanceView.borderMask = CLBorderMarkBottom ;
    self.tBalanceView.borderColor = colorWithRGB(242, 242, 242) ;
    self.tBalanceView.borderLineInset = UIEdgeInsetsMake(0, 0, 0, 0) ;
    
    self.tWalletView.backgroundColor = [UIColor clearColor] ;
    self.tWalletView.borderMask = CLBorderMarkBottom ;
    self.tWalletView.borderColor = colorWithRGB(242, 242, 242) ;
    self.tWalletView.borderLineInset = UIEdgeInsetsMake(0, 0, 0, 0) ;
    
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
    
    self.labTBalanceValue.font = [UIFont systemFontOfSize:15.0f] ;
    self.labTWalletValue.textColor = colorWithRGB(14, 195, 146) ;
    self.labTWalletValue.font = [UIFont systemFontOfSize:15.0f] ;
    
    self.labTBalance.text = @"总资产" ;   //
    self.labTBalanceValue.text = @"" ;
    self.labTWallet.text = @"钱包"    ;  //
    self.labTWalletValue.text = @""  ;   //

    if ([THEMEV3 isEqualToString:@"green"]){
        self.balanceBGView.backgroundColor = colorWithRGB(35, 119, 214);
        //        self.labTBalanceValue.textColor = RH_NavigationBar_BackgroundColor_Black;
        self.labTBalanceValue.textColor =   colorWithRGB(23, 102, 187);
        self.tWalletView.backgroundColor = colorWithRGB(68, 68, 68) ;
        self.tBalanceView.backgroundColor = colorWithRGB(68, 68, 68) ;
        self.tWalletView.borderColor = colorWithRGB(85, 85, 85) ;
        self.tBalanceView.borderColor = colorWithRGB(85, 85, 85) ;
    }else if ([THEMEV3 isEqualToString:@"red"]){
        self.balanceBGView.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
        self.labTBalanceValue.textColor = RH_NavigationBar_BackgroundColor_Red;
        self.tWalletView.backgroundColor = colorWithRGB(68, 68, 68) ;
        self.tBalanceView.backgroundColor = colorWithRGB(68, 68, 68) ;
        self.tWalletView.borderColor = colorWithRGB(85, 85, 85) ;
        self.tBalanceView.borderColor = colorWithRGB(85, 85, 85) ;
    }else if ([THEMEV3 isEqualToString:@"black"]){
        self.balanceBGView.backgroundColor = colorWithRGB(35, 119, 214);
//        self.labTBalanceValue.textColor = RH_NavigationBar_BackgroundColor_Black;
        self.labTBalanceValue.textColor =   colorWithRGB(23, 102, 187);
        self.tWalletView.backgroundColor = colorWithRGB(68, 68, 68) ;
        self.tBalanceView.backgroundColor = colorWithRGB(68, 68, 68) ;
        self.tWalletView.borderColor = colorWithRGB(85, 85, 85) ;
        self.tBalanceView.borderColor = colorWithRGB(85, 85, 85) ;
    }else if ([THEMEV3 isEqualToString:@"blue"]){
        self.balanceBGView.backgroundColor = RH_NavigationBar_BackgroundColor_Blue;
        //        self.labTBalanceValue.textColor = RH_NavigationBar_BackgroundColor_Black;
        self.labTBalanceValue.textColor =   colorWithRGB(23, 102, 187);
        self.tWalletView.backgroundColor = colorWithRGB(68, 68, 68) ;
        self.tBalanceView.backgroundColor = colorWithRGB(68, 68, 68) ;
        self.tWalletView.borderColor = colorWithRGB(85, 85, 85) ;
        self.tBalanceView.borderColor = colorWithRGB(85, 85, 85) ;
    }else if ([THEMEV3 isEqualToString:@"orange"]){
        self.balanceBGView.backgroundColor = RH_NavigationBar_BackgroundColor_Orange;
        //        self.labTBalanceValue.textColor = RH_NavigationBar_BackgroundColor_Black;
        self.labTBalanceValue.textColor =   colorWithRGB(23, 102, 187);
        self.tWalletView.backgroundColor = colorWithRGB(68, 68, 68) ;
        self.tBalanceView.backgroundColor = colorWithRGB(68, 68, 68) ;
        self.tWalletView.borderColor = colorWithRGB(85, 85, 85) ;
        self.tBalanceView.borderColor = colorWithRGB(85, 85, 85) ;
    }else if ([THEMEV3 isEqualToString:@"red_white"]){
        self.balanceBGView.backgroundColor = RH_NavigationBar_BackgroundColor_Red_White;
        self.labTBalanceValue.textColor = RH_NavigationBar_BackgroundColor;
    }else if ([THEMEV3 isEqualToString:@"green_white"]){
        self.balanceBGView.backgroundColor = RH_NavigationBar_BackgroundColor_Green_White;
        self.labTBalanceValue.textColor = RH_NavigationBar_BackgroundColor;
    }else if ([THEMEV3 isEqualToString:@"orange_white"]){
        self.balanceBGView.backgroundColor = RH_NavigationBar_BackgroundColor_Orange_White;
        self.labTBalanceValue.textColor = RH_NavigationBar_BackgroundColor;
    }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
        self.balanceBGView.backgroundColor = RH_NavigationBar_BackgroundColor_Coffee_White;
        self.labTBalanceValue.textColor = RH_NavigationBar_BackgroundColor;
    }else{
        self.balanceBGView.backgroundColor = RH_NavigationBar_BackgroundColor;
        self.labTBalanceValue.textColor = RH_NavigationBar_BackgroundColor;
    }
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
