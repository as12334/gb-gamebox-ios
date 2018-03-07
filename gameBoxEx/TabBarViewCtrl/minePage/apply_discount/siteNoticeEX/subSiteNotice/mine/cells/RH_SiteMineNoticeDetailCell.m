//
//  RH_SiteMineNoticeDetailCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/26.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SiteMineNoticeDetailCell.h"
#import "coreLib.h"
#import "RH_SiteMyMessageDetailModel.h"
@interface RH_SiteMineNoticeDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *backDropView;
@end
@implementation RH_SiteMineNoticeDetailCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    RH_SiteMyMessageDetailModel *model = ConvertToClassPointer(RH_SiteMyMessageDetailModel,context);
    RH_SiteMyMessageDetailListModel *listModel = ConvertToClassPointer(RH_SiteMyMessageDetailListModel, context);
    
    if (model) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(14, 33,tableView.frameWidth-28, 0)];
        label.text = model.mAdvisoryContent;
        label.font = [UIFont systemFontOfSize:13.f];
        NSDictionary *attrs = @{NSFontAttributeName : label.font};
        CGSize maxSize = CGSizeMake(label.frameWidth, MAXFLOAT);
        label.numberOfLines=0;
        CGSize size = [model.mAdvisoryContent boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        UILabel *label_1 = [[UILabel alloc]initWithFrame:CGRectMake(14, 33,tableView.frameWidth-28, 0)];
        label_1.text = model.mAdvisoryTitle;
        label_1.font = [UIFont systemFontOfSize:15.f];
        NSDictionary *attrs_1 = @{NSFontAttributeName : label.font};
        CGSize maxSize_1 = CGSizeMake(label_1.frameWidth, MAXFLOAT);
        label_1.numberOfLines=0;
        CGSize size_1 = [model.mAdvisoryTitle boundingRectWithSize:maxSize_1 options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs_1 context:nil].size;
        return size.height+size_1.height +50;
//        CGSize size = caculaterLabelTextDrawSize(model.mAdvisoryContent,[UIFont systemFontOfSize:12.f],tableView.frameWidth-32);
//        CGSize size_1 = caculaterLabelTextDrawSize(model.mAdvisoryTitle,[UIFont systemFontOfSize:15.f],tableView.frameWidth-32) ;

    }else
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(14, 33,tableView.frameWidth-28, 0)];
        label.text = listModel.mReplyContent;
        label.font = [UIFont systemFontOfSize:12.5f];
        NSDictionary *attrs = @{NSFontAttributeName : label.font};
        CGSize maxSize = CGSizeMake(label.frameWidth, MAXFLOAT);
        label.numberOfLines=0;
        CGSize size = [listModel.mReplyContent boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;

        UILabel *label_1 = [[UILabel alloc]initWithFrame:CGRectMake(14, 33,tableView.frameWidth-28, 0)];
        label_1.text = listModel.mReplyTitle;
        label_1.font = [UIFont systemFontOfSize:15.f];
        NSDictionary *attrs_1 = @{NSFontAttributeName : label.font};
        CGSize maxSize_1 = CGSizeMake(label_1.frameWidth, MAXFLOAT);
        label_1.numberOfLines=0;
        CGSize size_1 = [listModel.mReplyTitle boundingRectWithSize:maxSize_1 options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs_1 context:nil].size;
        return size.height+size_1.height +50;
//        CGSize size = caculaterLabelTextDrawSize(listModel.mReplyContent,[UIFont systemFontOfSize:12.f],tableView.frameWidth-32);
//        CGSize size_1 = caculaterLabelTextDrawSize(listModel.mReplyTitle,[UIFont systemFontOfSize:15.f],tableView.frameWidth-32) ;
//        return size.height+size_1.height ;
    }
   
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_SiteMyMessageDetailModel *model = ConvertToClassPointer(RH_SiteMyMessageDetailModel,context);
    RH_SiteMyMessageDetailListModel *listModel = ConvertToClassPointer(RH_SiteMyMessageDetailListModel, context);
    if (model) {
        self.timeLabel.text = dateStringWithFormatter(model.mAdvisoryTime, @"yyyy-MM-dd HH:mm:ss");
        self.titleLabel.text = model.mAdvisoryTitle;
        self.contextLabel.text = model.mAdvisoryContent;
    }
    else
    {
        self.timeLabel.text = dateStringWithFormatter(listModel.mReplyTime, @"yyyy-MM-dd HH:mm:ss");
        self.titleLabel.text = listModel.mReplyTitle;
        self.contextLabel.text = listModel.mReplyContent;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.textColor = colorWithRGB(68, 68, 68);
    self.titleLabel.font = [UIFont systemFontOfSize:15.f] ;
    self.contextLabel.textColor = colorWithRGB(68, 68, 68);
    self.contextLabel.font = [UIFont systemFontOfSize:12.f] ;
    self.backDropView.layer.cornerRadius= 3.f;
    self.backDropView.layer.borderColor = colorWithRGB(180, 180, 180).CGColor;
    self.backDropView.layer.borderWidth = 1.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString *)changeDateReturnStrFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    return currentDateString;
}

@end
