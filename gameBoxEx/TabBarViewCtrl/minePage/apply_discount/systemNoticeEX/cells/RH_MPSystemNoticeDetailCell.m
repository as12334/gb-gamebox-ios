//
//  RH_MPSystemNoticeDetailCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPSystemNoticeDetailCell.h"
#import "coreLib.h"
#import "RH_SystemNoticeDetailModel.h"
@interface RH_MPSystemNoticeDetailCell()

@property (weak, nonatomic) IBOutlet UILabel *titelLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@end
@implementation RH_MPSystemNoticeDetailCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    RH_SystemNoticeDetailModel *detaileModel = ConvertToClassPointer(RH_SystemNoticeDetailModel, context);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 0,tableView.frameWidth-16, 0)];
    label.text = detaileModel.mContent;
    label.font = [UIFont systemFontOfSize:12.f];
    NSDictionary *attrs = @{NSFontAttributeName : label.font};
    CGSize maxSize = CGSizeMake(label.frameWidth, MAXFLOAT);
    label.numberOfLines=0;
    CGSize size = [detaileModel.mContent boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    //    CGSize size = CGSizeMake(ceilf(size.width), ceilf(size.height));
    return size.height+60;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.topLine.backgroundColor = colorWithRGB(226, 226, 226);
    self.bottomLine.backgroundColor = colorWithRGB(226, 226, 226);
    self.timeLabel.textColor = colorWithRGB(153, 153, 153);
    self.titelLabel.textColor = colorWithRGB(68, 68, 68);
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_SystemNoticeDetailModel *detailModel = ConvertToClassPointer(RH_SystemNoticeDetailModel, context);
    self.titelLabel.text = detailModel.mContent;
    self.timeLabel.text = dateStringWithFormatter(detailModel.mPublishTime, @"yyyy-MM-dd");
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
