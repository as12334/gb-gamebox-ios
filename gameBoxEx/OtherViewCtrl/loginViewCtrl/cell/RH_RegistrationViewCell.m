//
//  RH_RegistrationViewCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_RegistrationViewCell.h"
#import "coreLib.h"
@implementation RH_RegistrationViewCell
{
    UILabel *label_Title;
    UITextField *textField;
    UIButton *button_Check;
    
    UIImageView *imageView_VerifyCode;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context {
    return 60;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        label_Title = [UILabel new];
        [self.contentView addSubview:label_Title];
        label_Title.whc_TopSpace(2).whc_LeftSpace(20).whc_Height(18).whc_WidthAuto();
        label_Title.font = [UIFont systemFontOfSize:13];
        label_Title.textColor = colorWithRGB(131, 131, 131);
        label_Title.textAlignment = NSTextAlignmentCenter;
        
        textField = [UITextField new];
        [self.contentView addSubview:textField];
        textField.whc_TopSpaceToView(1, label_Title).whc_LeftSpace(20).whc_RightSpace(20).whc_Height(38);
        textField.layer.borderColor = colorWithRGB(234, 234, 234).CGColor;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.layer.borderWidth = 1;
        textField.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

- (void)updateCellWithInfo:(NSDictionary *)info context:(id)context {
    label_Title.text = info[@"title"];
    textField.placeholder = info[@"content"];
    if ([info[@"cellType"] isEqualToString:@"password"]) {
        button_Check = [UIButton new];
        [self.contentView addSubview:button_Check];
        button_Check.whc_CenterYToView(0, textField).whc_RightSpace(50).whc_Width(25).whc_Height(20);
    }
}

@end
