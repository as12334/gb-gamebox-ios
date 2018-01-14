//
//  RH_GameNoticeDetailCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_GameNoticeDetailCell.h"
@interface RH_GameNoticeDetailCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
@implementation RH_GameNoticeDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
