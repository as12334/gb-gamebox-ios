//
//  RH_BankCardCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BankCardCell.h"
#import "coreLib.h"
#import "RH_UserInfoManager.h"
#import "RH_BankCardModel.h"

@implementation RH_BankCardCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] ;
    if (self){
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.textColor = colorWithRGB(51, 51, 51);
        self.detailTextLabel.textColor = colorWithRGB(153, 153, 153);
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine;
        self.separatorLineWidth = 1.0;
        self.separatorLineColor = colorWithRGB(226, 226, 226);
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        self.selectionOption = CLSelectionOptionHighlighted ;
        self.selectionColor = RH_Cell_DefaultHolderColor ;
    }
    
    return self ;
}


-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.textLabel.text = info.myTitle ;
    RH_MineInfoModel *infoModel = [RH_UserInfoManager shareUserManager].mineSettingInfo;
    RH_BankCardModel *bankModek = infoModel.mBankCard;
    self.detailTextLabel.text = ConvertToClassPointer(NSString, context) ;
}



@end
