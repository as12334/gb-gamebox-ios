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
@interface RH_MPSiteSystemNoticeCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *readMarkImageView;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIView *backDropView;
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
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = colorWithRGB(242, 242, 242);
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.readMarkImageView.layer.cornerRadius = 6;
    self.readMarkImageView.backgroundColor = colorWithRGB(242, 242, 242);
    self.readMarkImageView.layer.masksToBounds = YES;
    self.titleLabel.font = [UIFont systemFontOfSize:12.f];
    self.titleLabel.textColor = colorWithRGB(51, 51, 51);
    self.timeLabel.textColor = colorWithRGB(153, 153, 153);
    
    self.backDropView.layer.cornerRadius = 4.f;
    self.backDropView.layer.borderColor = colorWithRGB(226, 226,226).CGColor;
    self.backDropView.layer.borderWidth=1.f;
    self.backDropView.layer.masksToBounds = YES;
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_SiteMessageModel *model = ConvertToClassPointer(RH_SiteMessageModel, context);
    self.titleLabel.text = [NSString stringWithFormat:@"   %@",model.mTitle];
    self.timeLabel.text = dateStringWithFormatter(model.mPublishTime,@"yyyy-MM-dd");
    if ([model.number isEqual:@0]) {
        self.readMarkImageView.image = nil;
    }
    else if ([model.number isEqual:@1]){
        self.readMarkImageView.image = [UIImage imageNamed:@"choose"];
    }
    if (model.mRead==YES) {
        [self.titleLabel setTextColor:[UIColor redColor]];
    }
    else if (model.mRead==NO)
    {
        [self.titleLabel setTextColor:[UIColor blackColor]];
    }
}
- (IBAction)chooseEditBtn:(id)sender {
    self.block();
}

@end
