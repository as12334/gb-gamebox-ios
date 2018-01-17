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

@end
@implementation RH_MPSystemNoticeCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return 80;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_SystemNoticeModel *systemModel = ConvertToClassPointer(RH_SystemNoticeModel, context);
    self.noticeLabel.text = systemModel.mContent;
    self.timeLabel.text = dateStringWithFormatter(systemModel.mPublishTime, @"yyyy-MM-dd");
}


@end
