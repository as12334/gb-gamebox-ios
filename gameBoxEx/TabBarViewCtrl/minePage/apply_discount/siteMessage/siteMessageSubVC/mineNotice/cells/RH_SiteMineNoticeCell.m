//
//  RH_SiteMineNoticeCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SiteMineNoticeCell.h"
#import "RH_SiteMyMessageModel.h"
#import "coreLib.h"
@interface RH_SiteMineNoticeCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end
@implementation RH_SiteMineNoticeCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    RH_SiteMyMessageModel *model = ConvertToClassPointer(RH_SiteMyMessageModel,context);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 0,tableView.frameWidth-16, 0)];
    label.text = model.mAdvisoryTitle;
    NSDictionary *attrs = @{NSFontAttributeName : label.font};
    CGSize maxSize = CGSizeMake(label.frameWidth, MAXFLOAT);
    label.numberOfLines=0;
    CGSize size = [model.mAdvisoryTitle boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return 40+size.height;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_SiteMyMessageModel *model = ConvertToClassPointer(RH_SiteMyMessageModel, context);
    self.titleLabel.text = model.mAdvisoryTitle;
    self.timeLabel.text = dateStringWithFormatter(model.mAdvisoryTime,@"yyyy-MM-dd");
    if ([model.number isEqual:@0]) {
        [self.editBtn setBackgroundImage:[UIImage imageNamed:@"gesturelLock_normal"] forState:UIControlStateNormal];
    }
    else if ([model.number isEqual:@1]){
        [self.editBtn setBackgroundImage:[UIImage imageNamed:@"gesturelLock_error"] forState:UIControlStateNormal];
    }
    if (model.mIsRead==YES) {
        [self.titleLabel setTextColor:[UIColor redColor]];
    }
    else if (model.mIsRead==NO)
    {
        [self.titleLabel setTextColor:[UIColor blackColor]];
    }
}

- (IBAction)choseEdinBtnClick:(id)sender {
    self.block();
}

@end
