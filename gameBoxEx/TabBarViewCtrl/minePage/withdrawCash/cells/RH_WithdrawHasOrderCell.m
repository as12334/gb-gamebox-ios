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

    
    image_View = [[UIImageView alloc] init];
    [self.contentView addSubview:image_View];
    image_View.whc_Center(0, -40).whc_Width(80).whc_Height(80);
    image_View.image = ImageWithName(@"icon-text");
    label_Notice = [[UILabel alloc] init];
    [self.contentView addSubview:label_Notice];
    label_Notice.numberOfLines = 0 ;
    label_Notice.whc_TopSpaceToView(10, image_View).whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(10);
    label_Notice.textColor = RH_Label_DefaultTextColor;
    label_Notice.font = [UIFont systemFontOfSize:12.f];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineSpacing = 6; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@.0f
                          };
    NSString *contentStrTitle = [NSString stringWithFormat:@"%@",@"当前已有取款订单正在审核，\n请在该订单结束后再继续取款。"];
    NSAttributedString *attributeStrTitle = [[NSAttributedString alloc] initWithString:contentStrTitle attributes:dic];
    label_Notice.attributedText = attributeStrTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
