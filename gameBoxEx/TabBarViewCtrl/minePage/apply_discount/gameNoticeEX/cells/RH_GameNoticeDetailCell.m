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
    self.titleLabel.textColor = colorWithRGB(51, 51, 51);
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
    self.titleLabel.text = detaileModel.mContext;
    self.timeLabel.text = dateStringWithFormatter(detaileModel.mPublishTime, @"yyyy-MM-dd");
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
