//
//  RH_MPGameNoticeCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPSystemNoticeCell.h"
#import "coreLib.h"
#import "RH_SystemNoticeModel.h"
@interface RH_MPSystemNoticeCell()
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gamenameLabel;
@property (weak, nonatomic) IBOutlet UIView *backDropView;
@property (weak, nonatomic) IBOutlet UIImageView *mearkImageView;

@end
@implementation RH_MPSystemNoticeCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    RH_SystemNoticeModel *model = ConvertToClassPointer(RH_SystemNoticeModel,context);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(41, 21,tableView.frameWidth-82, 0)];
    label.text = model.mContent;
    label.font = [UIFont systemFontOfSize:12.f];
    NSDictionary *attrs = @{NSFontAttributeName : label.font};
    CGSize maxSize = CGSizeMake(label.frameWidth, MAXFLOAT);
    label.numberOfLines=0;
    CGSize size = [model.mContent boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    //    CGSize size = CGSizeMake(ceilf(size.width), ceilf(size.height));
    return 85+size.height;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = colorWithRGB(242, 242, 242);
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backDropView.layer.cornerRadius = 3.f;
    self.backDropView.layer.borderWidth = 1.f;
    self.backDropView.layer.borderColor =colorWithRGB(226, 226, 226).CGColor;
    self.backDropView.layer.masksToBounds = YES;
    self.timeLabel.textColor = colorWithRGB(153, 153, 153);
//    self.gamenameLabel.textColor = colorWithRGB(200, 200, 200);
    [self.gamenameLabel setHidden:YES];
    self.noticeLabel.textColor = colorWithRGB(51, 51, 51);
    self.noticeLabel.font = [UIFont systemFontOfSize:12.f];
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_SystemNoticeModel *systemModel = ConvertToClassPointer(RH_SystemNoticeModel, context);
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
    if (systemModel.mContent&&systemModel.mContent.length <20) {
        NSString *contentStr = [NSString stringWithFormat:@"%@",systemModel.mContent];
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:contentStr attributes:dic];
        self.noticeLabel.attributedText = attributeStr;
    }
    else if (systemModel.mContent&&systemModel.mContent.length >40) {
        NSString *contentStr = [NSString stringWithFormat:@"    %@...",[systemModel.mContent substringToIndex:40]];
         NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:contentStr attributes:dic];
        self.noticeLabel.attributedText = attributeStr;
    }else
    {
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"    %@",systemModel.mContent] attributes:dic];
        self.noticeLabel.attributedText = attributeStr;
    }
    self.timeLabel.text = dateStringWithFormatter(systemModel.mPublishTime, @"yyyy-MM-dd HH:mm:ss");
//    self.gamenameLabel.text = systemModel.m;
    if (systemModel.mReadmark==0) {
        self.mearkImageView.image = [UIImage imageNamed:@""];
    }
    else if (systemModel.mReadmark ==1)
    {
        self.mearkImageView.image = [UIImage imageNamed:@"mearkRead"];
    }
}


@end
