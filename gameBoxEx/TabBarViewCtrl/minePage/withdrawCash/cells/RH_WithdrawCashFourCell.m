//
//  RH_WithdrawCashFourCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_WithdrawCashFourCell.h"
#import "coreLib.h"
@implementation RH_WithdrawCashFourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = colorWithRGB(27, 117, 217);
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine;
        self.separatorLineWidth = 1.0f;
        self.separatorLineColor = colorWithRGB(226, 226, 226);
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0) ;
        self.backgroundColor = colorWithRGB(255, 255, 255);
        
        self.selectionOption = CLSelectionOptionHighlighted;
        self.selectionColor = RH_Cell_DefaultHolderColor;
        
        UIView *line = [UIView new];
        [self.contentView addSubview:line];
        line.whc_TopSpace(0).whc_LeftSpace(0).whc_RightSpace(0).whc_Height(1);
        line.backgroundColor = colorWithRGB(226, 226, 226);
    }
    return self;
}

- (void)updateCellWithInfo:(NSDictionary *)info context:(id)context {
    
    self.textLabel.text = context[@"title"];
    if ([THEMEV3 isEqualToString:@"green"]){
        self.textLabel.textColor = RH_NavigationBar_BackgroundColor_Green;
    }else if ([THEMEV3 isEqualToString:@"red"]){
        self.textLabel.textColor = RH_NavigationBar_BackgroundColor_Red;
    }else if ([THEMEV3 isEqualToString:@"black"]){
        self.textLabel.textColor = RH_NavigationBar_BackgroundColor_Black;
    }else if ([THEMEV3 isEqualToString:@"blue"]){
        self.textLabel.textColor = RH_NavigationBar_BackgroundColor_Blue;
    }else if ([THEMEV3 isEqualToString:@"orange"]){
        self.textLabel.textColor = RH_NavigationBar_BackgroundColor_Orange;
    }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
        self.textLabel.textColor = RH_NavigationBar_BackgroundColor_Orange;
    }else{
        self.textLabel.textColor = RH_NavigationBar_BackgroundColor;
    }
    self.detailTextLabel.text = context[@"detailTitle"];
    
}

@end
