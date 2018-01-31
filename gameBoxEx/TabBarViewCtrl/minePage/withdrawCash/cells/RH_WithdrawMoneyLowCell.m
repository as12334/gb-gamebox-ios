//
//  RH_WithdrawMoneyLowCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_WithdrawMoneyLowCell.h"
#import "coreLib.h"

@interface RH_WithdrawMoneyLowCell()
@property (weak, nonatomic) IBOutlet UILabel *label_Notice;

@property (weak, nonatomic) IBOutlet UIButton *button_Save;

@end

@implementation RH_WithdrawMoneyLowCell

+ (CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context {
    return 300;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.label_Notice.whc_Center(0, 20).whc_LeftSpace(20).whc_RightSpace(20).whc_Height(60);
    self.button_Save.whc_TopSpaceToView(20, self.label_Notice).whc_CenterX(0).whc_Width(100).whc_Height(44);
    self.label_Notice.text = @"取款金额至少为100.00元\n您当前钱包余额不足!";
    self.label_Notice.textColor = RH_Label_DefaultTextColor;
    self.button_Save.layer.cornerRadius = 5.0;
    self.clipsToBounds = YES;
    [self.button_Save addTarget:self action:@selector(buttonDidClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)buttonDidClick {
    ifRespondsSelector(self.delegate, @selector(withdrawMoneyLowCellDidTouchQuickButton:)){
        [self.delegate withdrawMoneyLowCellDidTouchQuickButton:self] ;
    }
}

@end
