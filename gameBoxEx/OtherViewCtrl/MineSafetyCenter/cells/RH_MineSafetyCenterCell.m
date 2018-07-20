//
//  RH_MineSafetyCenterCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MineSafetyCenterCell.h"
#import "coreLib.h"
#import "RH_UserInfoManager.h"
#import "RH_BankCardModel.h"

@implementation RH_MineSafetyCenterCell

+ (CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context {
    return 40;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTextLabel.textColor = colorWithRGB(153, 153, 153);
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = colorWithRGB(51, 51, 51);
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine;
        self.separatorLineWidth = 1.0f;
        self.separatorLineColor = colorWithRGB(226, 226, 226);
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0) ;
        self.backgroundColor = colorWithRGB(242, 242, 242);
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionOption = CLSelectionOptionHighlighted;
        self.selectionColor = RH_Cell_DefaultHolderColor;
    }
    return self;
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    
    self.detailTextLabel.text = info[@"detailTitle"];
    self.textLabel.text = info[@"title"];
    RH_UserInfoManager *manager = [RH_UserInfoManager shareUserManager] ;
    if ([info[@"targetKey"] isEqualToString:@"RH_ModifySafetyPasswordController"]) {
        self.detailTextLabel.text = manager.isSetSafetySecertPwd?@"修改":@"设置";
    }
    if ([info[@"targetKey"] isEqualToString:@"RH_BitCoinController"]) {
        self.detailTextLabel.text = manager.isBindBitCoin?@"查看":@"设置";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
