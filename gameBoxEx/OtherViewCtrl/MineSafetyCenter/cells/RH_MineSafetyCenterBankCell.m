//
//  RH_MineSafetyCenterBankCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MineSafetyCenterBankCell.h"
#import "coreLib.h"
#import "RH_UserInfoManager.h"
#import "RH_BankCardModel.h"


@implementation RH_MineSafetyCenterBankCell

+ (CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context {
    return 40;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine;
    self.separatorLineWidth = 1.0f;
    self.separatorLineColor = colorWithRGB(226, 226, 226);
    self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0) ;
    self.backgroundColor = colorWithRGB(242, 242, 242);
    self.contentView.backgroundColor = colorWithRGB(242, 242, 242); 
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionOption = CLSelectionOptionHighlighted;
    self.selectionColor = RH_Cell_DefaultHolderColor;
    
    self.noBankLabel.font = [UIFont systemFontOfSize:14.f];
    if ([THEMEV3 isEqualToString:@"green"]){
        self.noBankLabel.textColor = RH_NavigationBar_BackgroundColor_Green;
    }else if ([THEMEV3 isEqualToString:@"red"]){
        self.noBankLabel.textColor = RH_NavigationBar_BackgroundColor_Red;
    }else if ([THEMEV3 isEqualToString:@"black"]){
        self.noBankLabel.textColor = RH_NavigationBar_BackgroundColor_Black;
    }else{
        self.noBankLabel.textColor = RH_NavigationBar_BackgroundColor;
    }
    
    self.bankImage.whc_LeftSpaceToView(10, self.leftBankTitle).whc_CenterY(0).whc_Width(80).whc_Height(20);
    self.bankCardNumber.whc_LeftSpaceToView(10, self.bankImage).whc_CenterY(0).whc_WidthAuto().whc_TopSpace(12);
    self.noBankLabel.whc_LeftSpaceToView(0, self.leftBankTitle).whc_TopSpace(12).whc_Width(100).whc_Height(20);
    self.bankCardNumber.font = [UIFont systemFontOfSize:12 * screenSize().width/375.0];

}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_BankCardModel *bankModel = ConvertToClassPointer(RH_BankCardModel, context);
    if (bankModel.mBankCardNumber) {
        [self.bankImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",bankModel.showBankURL]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates];
            if ([THEMEV3 isEqualToString:@"green"]){
                self.bankCardNumber.textColor = RH_NavigationBar_BackgroundColor_Green;
            }else if ([THEMEV3 isEqualToString:@"red"]){
                self.bankCardNumber.textColor = RH_NavigationBar_BackgroundColor_Red;
            }else if ([THEMEV3 isEqualToString:@"black"]){
                self.bankCardNumber.textColor = RH_NavigationBar_BackgroundColor_Black;
            }else{
                self.bankCardNumber.textColor = RH_NavigationBar_BackgroundColor;
            }
            self.bankCardNumber.text =  [NSString stringWithFormat:@"%@",bankModel.mBankCardNumber ];
        self.noBankLabel.hidden = YES;
        self.rightLab.text = @"查看" ;
    }else
    {
        self.bankImage.hidden = YES;
        self.bankCardNumber.hidden = YES;
        self.noBankLabel.text = @"(未绑定银行卡)";
        self.rightLab.text = @"设置" ;
        
    }
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
