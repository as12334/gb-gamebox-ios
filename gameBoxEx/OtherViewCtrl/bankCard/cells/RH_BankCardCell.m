//
//  RH_BankCardCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BankCardCell.h"
#import "coreLib.h"
@implementation RH_BankCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.textColor = colorWithRGB(51, 51, 51);
    self.detailTextLabel.textColor = colorWithRGB(153, 153, 153);
    self.detailTextLabel.font = [UIFont systemFontOfSize:14];
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine;
    self.separatorLineWidth = 1;
    self.separatorLineColor = colorWithRGB(234, 234, 234);
    self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
