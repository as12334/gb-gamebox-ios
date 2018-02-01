//
//  RH_WithdrawCashThreeCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_WithdrawCashThreeCell.h"
#import "coreLib.h"
@implementation RH_WithdrawCashThreeCell

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
        self.detailTextLabel.textColor = colorWithRGB(153, 153, 153);
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = colorWithRGB(51, 51, 51);
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine;
        self.separatorLineWidth = 1.0f;
        self.separatorLineColor = colorWithRGB(226, 226, 226);
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0) ;
        self.backgroundColor = colorWithRGB(255, 255, 255);
        
        self.selectionOption = CLSelectionOptionHighlighted;
        self.selectionColor = RH_Cell_DefaultHolderColor;
    }
    return self;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.textLabel.text = info.myTitle ;
    self.detailTextLabel.text = ConvertToClassPointer(NSString, context) ;
//    self.detailTextLabel.text = ConvertToClassPointer(NSString, context) ;
}

@end
