//
//  RH_UserInfoTotalCell.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/25.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_UserInfoTotalCell.h"
#import "coreLib.h"

@interface RH_UserInfoTotalCell()
@property (weak, nonatomic) IBOutlet CLBorderView  *tBalanceView  ;
@property (weak, nonatomic) IBOutlet CLLabel  *labTBalance  ;
@property (weak, nonatomic) IBOutlet UILabel  *labTBalanceValue ;
@property (weak, nonatomic) IBOutlet CLBorderView  *tWalletView  ;
@property (weak, nonatomic) IBOutlet CLLabel  *labTWallet  ;
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
    
    self.labTBalance.intrinsicSizeExpansionLength = CGSizeMake(5, 5) ;
    self.labTBalance.backgroundColor = colorWithRGB(153, 153, 153) ;
    self.labTBalance.textColor = [UIColor whiteColor] ;
    self.labTBalance.font = [UIFont systemFontOfSize:19.0f] ;
    self.labTBalance.layer.cornerRadius = 6.0f ;
    
    self.labTWallet.intrinsicSizeExpansionLength = CGSizeMake(5, 5) ;
    self.labTWallet.backgroundColor = colorWithRGB(153, 153, 153) ;
    self.labTWallet.textColor = [UIColor whiteColor] ;
    self.labTWallet.font = [UIFont systemFontOfSize:19.0f] ;
    self.labTWallet.layer.cornerRadius = 6.0f ;
    
    self.labTBalanceValue.textColor = [UIColor blackColor] ;
    self.labTBalanceValue.font = [UIFont systemFontOfSize:19.0f] ;
    self.labTWalletValue.textColor = [UIColor blackColor] ;
    self.labTWalletValue.font = [UIFont systemFontOfSize:19.0f] ;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
