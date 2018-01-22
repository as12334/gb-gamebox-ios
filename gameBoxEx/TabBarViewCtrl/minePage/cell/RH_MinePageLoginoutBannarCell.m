//
//  RH_MinePageLoginoutBannarCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/21.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MinePageLoginoutBannarCell.h"

@implementation RH_MinePageLoginoutBannarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)loginClick:(id)sender {
    self.block();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
