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
{
    UILabel *label_Input;
}
+ (CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context {
    
    return 100;
}

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
        self.textV = [[UITextView alloc] init];
        [self.contentView addSubview:self.textV];
        self.textV.whc_RightSpace(10).whc_TopSpace(5).whc_BottomSpace(5).whc_LeftSpace(100);
        self.textV.font = [UIFont systemFontOfSize:14];
        self.textV.textColor = colorWithRGB(153, 153, 153);
        self.textV.backgroundColor = colorWithRGB(239, 239, 239);
        
        label_Input = [[UILabel alloc] init];
        [self.contentView addSubview:label_Input];
        label_Input.whc_TopSpaceEqualView(self.textV).whc_LeftSpace(5).whc_RightSpaceToView(5, self.textV).whc_Height(30);
        label_Input.textColor = RH_Label_DefaultTextColor;
        label_Input.font = [UIFont systemFontOfSize:13];
        label_Input.text = @"Bit地址:";
        label_Input.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (void)updateCellWithInfo:(NSDictionary *)info context:(id)context {
    self.textV.text = ConvertToClassPointer(NSString, context) ;
}

-(BOOL)isEditing
{
    return self.textV.isFirstResponder ;
}

-(BOOL)endEditing:(BOOL)force
{
    return [self.textV resignFirstResponder] ;
}

@end
