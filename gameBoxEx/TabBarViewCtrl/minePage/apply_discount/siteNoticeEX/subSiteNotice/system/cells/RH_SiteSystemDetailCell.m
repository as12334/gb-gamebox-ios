//
//  RH_SiteSystemDetailCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/26.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SiteSystemDetailCell.h"
#import "coreLib.h"
#import "RH_SiteMsgSysMsgModel.h"
@interface RH_SiteSystemDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *backDropView;

@end
@implementation RH_SiteSystemDetailCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    RH_SiteMsgSysMsgModel *model = ConvertToClassPointer(RH_SiteMsgSysMsgModel,context);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 0,tableView.frameWidth-15, 0)];
    label.text = model.mTitle;
    label.font = [UIFont systemFontOfSize:15.f];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 6; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *attrs = @{NSFontAttributeName : label.font};
    CGSize maxSize = CGSizeMake(label.frameWidth, MAXFLOAT);
    label.numberOfLines=0;
    CGSize size = [model.mTitle boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    UILabel *label_1 = [[UILabel alloc]initWithFrame:CGRectMake(7.5, 0,tableView.frameWidth-15, 0)];
    label_1.text = model.mContent;
    label_1.font = [UIFont systemFontOfSize:12.f];
    NSDictionary *attrs_1 = @{NSFontAttributeName : label_1.font,NSParagraphStyleAttributeName:paraStyle,};
    CGSize maxSize_1 = CGSizeMake(label_1.frameWidth, MAXFLOAT);
    label.numberOfLines=0;
    CGSize size_1 = [model.mContent boundingRectWithSize:maxSize_1 options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs_1 context:nil].size;
    return 90+size.height+size_1.height>screenSize().height?220+size.height+size_1.height:100+size.height+size_1.height;
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_SiteMsgSysMsgModel *model = ConvertToClassPointer(RH_SiteMsgSysMsgModel,context);
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 6; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@.0f
                          };
    NSString *contentStrTitle = [NSString stringWithFormat:@"%@",model.mTitle];
    NSAttributedString *attributeStrTitle = [[NSAttributedString alloc] initWithString:contentStrTitle attributes:dic];
    self.titleLabel.attributedText = attributeStrTitle;
    NSString *contentStr = [NSString stringWithFormat:@"%@",model.mContent];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:contentStr attributes:dic];
    self.contextLabel.attributedText = attributeStr;
    self.timeLabel.text = dateStringWithFormatter(model.mPublishTime, @"yyyy-MM-dd HH:mm:ss");
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.textColor = colorWithRGB(51, 51, 51);
    self.contextLabel.textColor = colorWithRGB(102, 102, 102);
    self.timeLabel.textColor = colorWithRGB(153, 153, 153);
    self.backDropView.layer.cornerRadius= 3.f;
    self.backDropView.layer.borderColor = colorWithRGB(180, 180, 180).CGColor;
    self.backDropView.layer.borderWidth = 1.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
