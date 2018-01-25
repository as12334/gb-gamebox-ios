//
//  RH_MPGameNoticeCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPGameNoticeCell.h"
#import "coreLib.h"
#import "RH_GameNoticeModel.h"

@interface RH_MPGameNoticeCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *backDropView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *gamenameLabel;
@end
@implementation RH_MPGameNoticeCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    ListModel *model = ConvertToClassPointer(ListModel,context);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(41, 21,tableView.frameWidth-82,0)];
    label.text = model.mContext;
    label.font = [UIFont systemFontOfSize:12.f];
    NSDictionary *attrs = @{NSFontAttributeName : label.font};
    CGSize maxSize = CGSizeMake(label.frameWidth, MAXFLOAT);
    label.numberOfLines=0;
    CGSize size = [model.mContext boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
//    CGSize size = CGSizeMake(ceilf(size.width), ceilf(size.height));
    return 75+size.height;
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
    self.timeLabel.textColor = colorWithRGB(200, 200, 200);
    self.gamenameLabel.textColor = colorWithRGB(200, 200, 200);
    self.titleLabel.textColor = colorWithRGB(51, 51, 51);
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    ListModel *model = ConvertToClassPointer(ListModel,context);
    self.titleLabel.text = model.mContext;
    self.timeLabel.text = dateStringWithFormatter(model.mPublishTime,@"yyyy-MM-dd");
    self.gamenameLabel.text = model.mGameName;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
