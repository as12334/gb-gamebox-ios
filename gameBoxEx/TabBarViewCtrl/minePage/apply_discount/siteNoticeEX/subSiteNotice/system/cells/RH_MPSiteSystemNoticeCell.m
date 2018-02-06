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
#define RHNT_AlreadyReadStatusChangeNotification @"AlreadyReadStatusChangeNotification"
@interface RH_MPSiteSystemNoticeCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *readMarkImageView;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIView *backDropView;
@property (weak, nonatomic) IBOutlet UIImageView *readMark;
@property(nonatomic,assign)NSInteger mReadId;
@end
@implementation RH_MPSiteSystemNoticeCell

+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    RH_SiteMessageModel *model = ConvertToClassPointer(RH_SiteMessageModel,context);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 0,tableView.frameWidth-16, 0)];
    label.text = model.mTitle;
    label.font = [UIFont systemFontOfSize:12.f];
    NSDictionary *attrs = @{NSFontAttributeName : label.font};
    CGSize maxSize = CGSizeMake(label.frameWidth, MAXFLOAT);
    label.numberOfLines=0;
    CGSize size = [model.mTitle boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return 90+size.height;
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
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 6; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@.0f
                          };
    if (model.mTitle&&model.mTitle.length <20) {
        NSString *contentStr = [NSString stringWithFormat:@"%@",model.mTitle];
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:contentStr attributes:dic];
        self.titleLabel.attributedText = attributeStr;
    }
    else if (model.mTitle&&model.mTitle.length >40) {
        NSString *contentStr = [NSString stringWithFormat:@"    %@...",[model.mTitle substringToIndex:40]];
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:contentStr attributes:dic];
        self.titleLabel.attributedText = attributeStr;
    }else
    {
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"    %@",model.mTitle] attributes:dic];
        self.titleLabel.attributedText = attributeStr;
    }
    self.timeLabel.text = dateStringWithFormatter(model.mPublishTime,@"yyyy-MM-dd hh:mm:ss");
    if ([model.number isEqual:@0]) {
        self.readMarkImageView.image = nil;
    }
    else if ([model.number isEqual:@1]){
        self.readMarkImageView.image = [UIImage imageNamed:@"choose"];
    }
    if (model.mRead==YES) {
        [self.titleLabel setTextColor:colorWithRGB(153, 153, 153)];
        self.readMark.image = [UIImage imageNamed:@""];
    }
    else if (model.mRead==NO)
    {
        [self.titleLabel setTextColor:colorWithRGB(51, 51, 51)];
        self.readMark.image = [UIImage imageNamed:@"mearkRead"];
    }
    self.mReadId = model.mId;
    [[NSNotificationCenter defaultCenter] addObserverForName:RHNT_AlreadyReadStatusChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        RH_SiteMessageModel *model1 = note.object;
        if (model1.mRead == YES && self.mReadId == model1.mId) {
            
            [self.titleLabel setTextColor:colorWithRGB(153, 153, 153)];
            self.readMark.image = [UIImage imageNamed:@""];
        }
    }];
}
- (IBAction)chooseEditBtn:(id)sender {
    self.block();
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RHNT_AlreadyReadStatusChangeNotification object:nil];
}

@end
