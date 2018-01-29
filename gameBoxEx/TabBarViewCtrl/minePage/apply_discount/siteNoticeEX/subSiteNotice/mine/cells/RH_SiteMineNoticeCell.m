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

@property (weak, nonatomic) IBOutlet UIImageView *readImageView;
@property (weak, nonatomic) IBOutlet UIView *backDropView;
@end
@implementation RH_SiteMineNoticeCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    RH_SiteMyMessageModel *model = ConvertToClassPointer(RH_SiteMyMessageModel,context);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 0,tableView.frameWidth-16, 0)];
    label.text = model.mAdvisoryTitle;
    label.font = [UIFont systemFontOfSize:12.f];
    NSDictionary *attrs = @{NSFontAttributeName : label.font};
    CGSize maxSize = CGSizeMake(label.frameWidth, MAXFLOAT);
    label.numberOfLines=0;
    CGSize size = [model.mAdvisoryTitle boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return 60+size.height;
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
    self.readImageView.layer.cornerRadius = 6;
    self.readImageView.backgroundColor = colorWithRGB(242, 242, 242);
    self.readImageView.layer.masksToBounds = YES;
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
    RH_SiteMyMessageModel *model = ConvertToClassPointer(RH_SiteMyMessageModel, context);
    self.titleLabel.text = self.titleLabel.text = [[NSString stringWithFormat:@"   %@",model.mAdvisoryTitle]stringByRemovingPercentEncoding];
    self.timeLabel.text = dateStringWithFormatter(model.mAdvisoryTime,@"yyyy-MM-dd hh:mm:ss");
    if ([model.number isEqual:@0]) {
        self.readImageView.image =nil;
    }
    else if ([model.number isEqual:@1]){
        self.readImageView.image = [UIImage imageNamed:@"choose"];
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
