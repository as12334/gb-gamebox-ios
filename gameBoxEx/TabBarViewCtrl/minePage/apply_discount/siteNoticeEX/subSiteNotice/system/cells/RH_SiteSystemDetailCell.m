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
    return 80+size.height+size_1.height;
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_SiteMsgSysMsgModel *model = ConvertToClassPointer(RH_SiteMsgSysMsgModel,context);
    self.titleLabel.text = model.mTitle;
    self.contextLabel.text = model.mContent;
    self.timeLabel.text = dateStringWithFormatter(model.mPublishTime, @"yyyy-MM-dd hh:mm:ss");
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.textColor = colorWithRGB(68, 68, 68);
    self.contextLabel.textColor = colorWithRGB(68, 68, 68);
    self.backDropView.layer.cornerRadius= 3.f;
    self.backDropView.layer.borderColor = colorWithRGB(180, 180, 180).CGColor;
    self.backDropView.layer.borderWidth = 1.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
