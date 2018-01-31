//
//  RH_GameNoticeDetailCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_GameNoticeDetailCell.h"
#import "coreLib.h"
#import "RH_GameNoticeDetailModel.h"
@interface RH_GameNoticeDetailCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@end
@implementation RH_GameNoticeDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.timeLabel.textColor = colorWithRGB(153, 153, 153);
    self.titleLabel.textColor = colorWithRGB(102, 102, 102);
    self.topLine.backgroundColor = colorWithRGB(226, 226, 226);
    self.bottomLine.backgroundColor = colorWithRGB(226, 226, 226);
}
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    RH_GameNoticeDetailModel *detaileModel = ConvertToClassPointer(RH_GameNoticeDetailModel, context);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 17,tableView.frameWidth-16, 0)];
    label.text = detaileModel.mContext;
    label.font = [UIFont systemFontOfSize:12.f];
    NSDictionary *attrs = @{NSFontAttributeName : label.font};
    CGSize maxSize = CGSizeMake(label.frameWidth, MAXFLOAT);
    label.numberOfLines=0;
    CGSize size = [detaileModel.mContext boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    //    CGSize size = CGSizeMake(ceilf(size.width), ceilf(size.height));
    return 60+size.height;
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_GameNoticeDetailModel *detaileModel = ConvertToClassPointer(RH_GameNoticeDetailModel, context);
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 6; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.f
                          };
    if (detaileModel.mContext&&detaileModel.mContext.length <20) {
        NSString *contentStr = [NSString stringWithFormat:@"%@",detaileModel.mContext];
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:contentStr attributes:dic];
        self.titleLabel.attributedText = attributeStr;
    }
    else if (detaileModel.mContext&&detaileModel.mContext.length >40) {
        NSString *contentStr = [NSString stringWithFormat:@"    %@...",[detaileModel.mContext substringToIndex:40]];
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:contentStr attributes:dic];
        self.titleLabel.attributedText = attributeStr;
    }else
    {
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"    %@",detaileModel.mContext] attributes:dic];
        self.titleLabel.attributedText = attributeStr;
    }
    self.timeLabel.text = dateStringWithFormatter(detaileModel.mPublishTime, @"yyyy-MM-dd hh:mm:ss");
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
