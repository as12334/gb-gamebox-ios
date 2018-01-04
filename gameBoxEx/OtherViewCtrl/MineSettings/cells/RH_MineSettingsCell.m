//
//  RH_MineSettingsCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MineSettingsCell.h"
#import "coreLib.h"
@interface RH_MineSettingsCell()

@property (nonatomic, strong) UISwitch *rightSwitch;

@end

@implementation RH_MineSettingsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UISwitch *)rightSwitch {
    if (_rightSwitch == nil) {
        _rightSwitch = [[UISwitch alloc] init];
        
    }
    return _rightSwitch;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = colorWithRGB(51, 51, 51);
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine;
        self.separatorLineColor = colorWithRGB(242, 242, 242);
        self.separatorLineWidth = 1.0f;
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
        
        [self.contentView addSubview:self.rightSwitch];
        self.rightSwitch.whc_RightSpace(20).whc_CenterY(0).whc_Width(51).whc_Height(31);
        
    }
    return self;
}

- (void)updateCellWithInfo:(NSDictionary *)info context:(id)context {
    
    self.textLabel.text = info[@"title"];
}

@end
