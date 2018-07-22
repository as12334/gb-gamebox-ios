//
//  RH_BasicAlertViewCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/2/5.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicAlertViewCell.h"
#import "coreLib.h"
@implementation RH_BasicAlertViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentLabel = [UILabel new];
        [self.contentView addSubview:self.contentLabel];
        self.contentLabel.whc_TopSpace(5).whc_BottomSpace(5).whc_LeftSpace(20).whc_RightSpace(20);
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return self;
}

@end
