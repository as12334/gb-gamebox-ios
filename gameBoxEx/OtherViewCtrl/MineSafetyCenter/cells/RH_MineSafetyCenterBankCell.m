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
    return 44;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine;
    self.separatorLineWidth = 1.0f;
    self.separatorLineColor = colorWithRGB(226, 226, 226);
    self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0) ;
    self.backgroundColor = colorWithRGB(242, 242, 242);
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionOption = CLSelectionOptionHighlighted;
    self.selectionColor = RH_Cell_DefaultHolderColor;
    self.bankImage.whc_LeftSpaceToView(0, self.leftBankTitle).whc_TopSpace(12).whc_Width(100).whc_Height(20);
    self.bankCardNumber.whc_LeftSpaceToView(5, self.bankImage).whc_CenterY(0).whc_Width(60).whc_TopSpace(12);
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    
    RH_BankCardModel *bankModel = ConvertToClassPointer(RH_BankCardModel, context);
    if (!bankModel) {
        return;
    }
    [self.bankImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",bankModel.mbankUrl]]];
    self.bankCardNumber.text = [NSString stringWithFormat:@"%@",[bankModel.mBankCardNumber substringFromIndex:bankModel.mBankCardNumber.length-9]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
