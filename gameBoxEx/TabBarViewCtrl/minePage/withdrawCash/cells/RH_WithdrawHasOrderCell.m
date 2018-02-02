//
//  RH_WithdrawHasOrderCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/21.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_WithdrawHasOrderCell.h"
#import "coreLib.h"
@implementation RH_WithdrawHasOrderCell
{
    UIImageView *image_View;
    UILabel *label_Notice;
}

+ (CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context {
    return 200;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionOption = CLSelectionOptionHighlighted;
    self.mySeparatorLineInset = UIEdgeInsetsMake(20, 20, 20, 20);
    
    image_View = [[UIImageView alloc] init];
    [self.contentView addSubview:image_View];
    image_View.whc_Center(0, -50).whc_Width(80).whc_Height(80);
    image_View.image = ImageWithName(@"icon-text");
    label_Notice = [[UILabel alloc] init];
    [self.contentView addSubview:label_Notice];
    label_Notice.whc_TopSpaceToView(20, image_View).whc_LeftSpace(20).whc_RightSpace(20).whc_BottomSpace(10);
    label_Notice.textColor = RH_Label_DefaultTextColor;
    label_Notice.font = [UIFont systemFontOfSize:12];
    label_Notice.textAlignment = NSTextAlignmentCenter;
    label_Notice.text = @"当前已有取款订单正在审核，\n 请在该定单结束后再继续取款。";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
