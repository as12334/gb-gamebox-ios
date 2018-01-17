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
@end
@implementation RH_MPSystemNoticeDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
