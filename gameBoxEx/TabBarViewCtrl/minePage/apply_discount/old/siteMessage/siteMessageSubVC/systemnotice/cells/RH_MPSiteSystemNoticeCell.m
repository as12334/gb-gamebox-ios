//
//  RH_MPSiteSystemNoticeCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/5.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPSiteSystemNoticeCell.h"
#import "coreLib.h"
#import "RH_SiteMessageModel.h"
#import "RH_SiteMessageModel.h"
@interface RH_MPSiteSystemNoticeCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@end
@implementation RH_MPSiteSystemNoticeCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    RH_SiteMessageModel *model = ConvertToClassPointer(RH_SiteMessageModel,context);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 0,tableView.frameWidth-16, 0)];
    label.text = model.mTitle;
    NSDictionary *attrs = @{NSFontAttributeName : label.font};
    CGSize maxSize = CGSizeMake(label.frameWidth, MAXFLOAT);
    label.numberOfLines=0;
    CGSize size = [model.mTitle boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return 40+size.height;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_SiteMessageModel *model = ConvertToClassPointer(RH_SiteMessageModel, context);
    self.titleLabel.text = model.mTitle;
    self.timeLabel.text = self.timeLabel.text = dateStringWithFormatter(model.mPublishTime,@"yyyy-MM-dd");
    if ([model.number isEqual:@0]) {
        [self.editBtn setBackgroundImage:[UIImage imageNamed:@"gesturelLock_normal"] forState:UIControlStateNormal];
    }
    else if ([model.number isEqual:@1]){
        [self.editBtn setBackgroundImage:[UIImage imageNamed:@"gesturelLock_error"] forState:UIControlStateNormal];
    }
}
- (IBAction)chooseEditBtn:(id)sender {
    self.block();
}
-(void)setSelectedStatus:(BOOL)selectedStatus
{
    self.editBtn.selected = selectedStatus;
}
@end
