//
//  RH_BitCoinCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BitCoinCell.h"
#import "coreLib.h"

@implementation RH_BitCoinCell

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
        self.textF = [[UITextField alloc] init];
        [self.contentView addSubview:self.textF];
        self.textF.whc_RightSpace(10).whc_TopSpace(5).whc_BottomSpace(5).whc_LeftSpace(100);
        self.textF.font = [UIFont systemFontOfSize:14];
        self.textF.textColor = colorWithRGB(153, 153, 153);
        self.textF.borderStyle = UITextBorderStyleRoundedRect;
    }
    return self;
}

- (void)updateCellWithInfo:(NSDictionary *)info context:(id)context {
    
    self.textF.placeholder = info[@"detailTitle"];
}

-(BOOL)isEditing
{
    return self.textF.isEditing ;
}

-(BOOL)endEditing:(BOOL)force
{
    return [self.textF resignFirstResponder] ;
}

@end
