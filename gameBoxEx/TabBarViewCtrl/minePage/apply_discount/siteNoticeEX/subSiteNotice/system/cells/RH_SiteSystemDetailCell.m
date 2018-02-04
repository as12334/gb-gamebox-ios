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
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 0,tableView.frameWidth-16, 0)];
    label.text = model.mTitle;
    label.font = [UIFont systemFontOfSize:14.f];
    NSDictionary *attrs = @{NSFontAttributeName : label.font};
    CGSize maxSize = CGSizeMake(label.frameWidth, MAXFLOAT);
    label.numberOfLines=0;
    CGSize size = [model.mTitle boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    UILabel *label_1 = [[UILabel alloc]initWithFrame:CGRectMake(8, 0,tableView.frameWidth-16, 0)];
    label_1.text = model.mContent;
    label_1.font = [UIFont systemFontOfSize:12.f];
    NSDictionary *attrs_1 = @{NSFontAttributeName : label_1.font};
    CGSize maxSize_1 = CGSizeMake(label_1.frameWidth, MAXFLOAT);
    label.numberOfLines=0;
    CGSize size_1 = [model.mContent boundingRectWithSize:maxSize_1 options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs_1 context:nil].size;
    return 120+size.height+size_1.height;
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
    if (model.mTitle&&model.mTitle.length <20) {
        NSString *contentStr = [NSString stringWithFormat:@"%@",model.mTitle];
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:contentStr attributes:dic];
        self.titleLabel.attributedText = attributeStr;
    }
    else if (model.mTitle&&model.mTitle.length >40) {
        NSString *contentStr = [NSString stringWithFormat:@"%@...",[model.mTitle substringToIndex:40]];
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:contentStr attributes:dic];
        self.titleLabel.attributedText = attributeStr;
    }else
    {
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",model.mTitle] attributes:dic];
        self.titleLabel.attributedText = attributeStr;
    }
    
    if (model.mContent&&model.mContent.length <20) {
        NSString *contentStr = [NSString stringWithFormat:@"%@",model.mContent];
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:contentStr attributes:dic];
        self.contextLabel.attributedText = attributeStr;
    }
    else if (model.mTitle&&model.mTitle.length >40) {
        NSString *contentStr = [NSString stringWithFormat:@"    %@...",[model.mContent substringToIndex:40]];
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:contentStr attributes:dic];
        self.contextLabel.attributedText = attributeStr;
    }else
    {
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"    %@",model.mContent] attributes:dic];
        self.contextLabel.attributedText = attributeStr;
    }
    
//    self.titleLabel.text = model.mTitle;
//    self.contextLabel.text = model.mContent;
    self.timeLabel.text = dateStringWithFormatter(model.mPublishTime, @"yyyy-MM-dd hh:mm:ss");
    
    
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
