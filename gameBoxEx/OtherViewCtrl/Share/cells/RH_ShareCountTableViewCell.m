//
//  RH_ShareCountTableViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ShareCountTableViewCell.h"
#import "coreLib.h"
#import "RH_SharePlayerRecommendModel.h"



@implementation RH_ShareCountTableViewCell
{
    UIView *topView ;
    UIView *bottomView ;
}

+ (CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context {
    
    return 80.f;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor] ;
        self.contentView.backgroundColor = [UIColor clearColor] ;
        
        UIView *bgView = [[UIView alloc] init ];
        [self.contentView addSubview:bgView];
        bgView.layer.cornerRadius = 5.f;
        bgView.layer.masksToBounds = YES ;
        bgView.whc_TopSpace(0).whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0) ;
        
        topView = [[UIView alloc] init ];
        topView.backgroundColor = colorWithRGB(255, 255, 255) ;
        [bgView addSubview:topView];
        topView.whc_LeftSpace(0).whc_TopSpace(0).whc_RightSpace(0).whc_Height(40) ;
        
        self.myShareFriendCountLab = [[UILabel alloc] init] ;
        [topView addSubview:self.myShareFriendCountLab ];
        self.myShareFriendCountLab.textAlignment = NSTextAlignmentLeft ;
        self.myShareFriendCountLab.whc_LeftSpace(20).whc_Width((screenSize().width-40)/2.0).whc_CenterY(0);
        self.myShareFriendCountLab.textColor = colorWithRGB(51, 51, 51) ;
        self.myShareFriendCountLab.font = [UIFont systemFontOfSize:12.f] ;
        self.myShareFriendCountLab.text = @"我的分享好友56人";
        
        self.myShareAwardLab = [[UILabel alloc] init];
        [topView addSubview:self.myShareAwardLab];
        self.myShareAwardLab.textAlignment = NSTextAlignmentRight ;
        self.myShareAwardLab.whc_RightSpace(20).whc_Width((screenSize().width-40)/2.0).whc_CenterY(0);
        self.myShareAwardLab.textColor = colorWithRGB(51, 51, 51) ;
        self.myShareAwardLab.font = [UIFont systemFontOfSize:12.f] ;
        self.myShareAwardLab.text = @"我的分享奖励256元" ;
        
        bottomView = [[UIView alloc] init ];
        bottomView.backgroundColor = colorWithRGB(242, 242, 242) ;
        [bgView addSubview:bottomView];
        bottomView.whc_LeftSpace(0).whc_TopSpace(40).whc_RightSpace(0).whc_Height(40) ;
        
        self.friendReciprocalCountLab = [[UILabel alloc] init ];
        [bottomView addSubview:self.friendReciprocalCountLab ];
        self.friendReciprocalCountLab.textAlignment = NSTextAlignmentLeft ;
        self.friendReciprocalCountLab.whc_LeftSpace(20).whc_Width((screenSize().width-40)/2.0).whc_CenterY(0);
        self.friendReciprocalCountLab.textColor = colorWithRGB(51, 51, 51) ;
        self.friendReciprocalCountLab.font = [UIFont systemFontOfSize:12.f] ;
        self.friendReciprocalCountLab.text = @"好友互惠达成数56人";
        
        self.myShareBonusLab = [[UILabel alloc] init];
        [bottomView addSubview:self.myShareBonusLab];
        self.myShareBonusLab.textAlignment = NSTextAlignmentRight ;
        self.myShareBonusLab.whc_RightSpace(20).whc_Width((screenSize().width-40)/2.0).whc_CenterY(0);
        self.myShareBonusLab.textColor = colorWithRGB(51, 51, 51) ;
        self.myShareBonusLab.font = [UIFont systemFontOfSize:12.f] ;
        self.myShareBonusLab.text = @"我的分享红利256元" ;
    }
    return self ;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.backgroundView.frame;
    frame.origin.x += 20;
    frame.size.width -= 40;
    self.backgroundView.frame = frame;
    frame = self.contentView.frame;
    frame.origin.x += 20;
    frame.size.width -= 40;
    self.contentView.frame = frame;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_SharePlayerRecommendModel *model = ConvertToClassPointer(RH_SharePlayerRecommendModel, context) ;
    self.myShareFriendCountLab.text = [NSString stringWithFormat:@"我分享的好友数%@人",model.mRemmendModel.mUser] ;
    self.myShareAwardLab.text = [NSString stringWithFormat:@"我的分享奖励%@元",model.mRemmendModel.mSingle] ;
    self.friendReciprocalCountLab.text = [NSString stringWithFormat:@"我的奖励次数%@次",model.mRemmendModel.mCount] ;
    self.myShareBonusLab.text =  [NSString stringWithFormat:@"我的分享红利%@元",model.mRemmendModel.mBonus] ;
    NSLog(@"分红 == %@",model.mRemmendModel.mBonus);

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
