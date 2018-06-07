//
//  RH_RewardRuleTableViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/13.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_RewardRuleTableViewCell.h"
#import "coreLib.h"
#import "RH_SharePlayerRecommendModel.h"

@interface RH_RewardRuleTableViewCell()
@property(nonatomic,strong)UILabel *contentLab1;
@property(nonatomic,strong)UILabel *contentLab2;
@property(nonatomic,strong) UIView *bottomView ;
@property(nonatomic,strong) UILabel *shareRedLab ;
@end
@implementation RH_RewardRuleTableViewCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return 200;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGRect frame = self.frame;
        frame.size.height = 300;
        self.frame = frame;
        self.contentView.backgroundColor = colorWithRGB(242, 242, 242) ;
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = colorWithRGB(242, 242, 242) ;
        [self.contentView addSubview:topView ];
        topView.whc_LeftSpace(10).whc_RightSpace(10).whc_TopSpace(10).whc_Height(70) ;
        
        topView.layer.borderWidth = 1.f ;
        topView.layer.borderColor = colorWithRGB(204, 204, 204).CGColor ;
        topView.layer.cornerRadius = 5.f;
        topView.layer.masksToBounds = YES ;
        
        UILabel *huhuiLab = [[UILabel alloc] init];
        [self.contentView addSubview:huhuiLab];
        huhuiLab.whc_CenterX(0).whc_TopSpace(0).whc_Height(20).whc_WidthAuto();
        huhuiLab.text = @"互惠奖励";
        huhuiLab.backgroundColor  = colorWithRGB(242, 242, 242) ;
        huhuiLab.font = [UIFont boldSystemFontOfSize:14.f] ;
        
        
        _contentLab1 = [[UILabel alloc] init ];
        [topView addSubview:_contentLab1];
        _contentLab1.whc_TopSpace(20).whc_WidthAuto().whc_CenterX(0) ;
        _contentLab1.textAlignment = NSTextAlignmentCenter ;
        _contentLab1.text = @"推荐好友成功注册并存款满500元";
        _contentLab1.textColor = colorWithRGB(51, 51, 51) ;
        _contentLab1.font = [UIFont systemFontOfSize:14.f] ;
        
        _contentLab2 = [[UILabel alloc] init ];
        [topView addSubview:_contentLab2];
        _contentLab2.whc_TopSpaceToView(5, _contentLab1).whc_WidthAuto().whc_CenterX(0) ;
        _contentLab2.textAlignment = NSTextAlignmentCenter ;
        _contentLab2.text = @"双方各获20元奖励";
        _contentLab2.textColor = colorWithRGB(51, 51, 51) ;
        _contentLab2.font = [UIFont systemFontOfSize:14.f] ;
        
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = colorWithRGB(242, 242, 242) ;
        [self.contentView addSubview:_bottomView];
        _bottomView.whc_LeftSpace(10).whc_RightSpace(10).whc_TopSpaceToView(10, topView).whc_Height(80) ;
        _bottomView.layer.borderWidth = 1.f ;
        _bottomView.layer.borderColor = colorWithRGB(204, 204, 204).CGColor ;
        _bottomView.layer.cornerRadius = 5.f;
        _bottomView.layer.masksToBounds = YES ;
        
        _shareRedLab = [[UILabel alloc] init];
        [self.contentView addSubview:_shareRedLab];
        _shareRedLab.whc_TopSpaceToView(0, topView).whc_CenterX(0).whc_Height(20).whc_WidthAuto();
        _shareRedLab.text = @"分享红利";
        _shareRedLab.backgroundColor  = colorWithRGB(242, 242, 242) ;
        _shareRedLab.font = [UIFont boldSystemFontOfSize:14.f] ;
        
        UILabel *lab1 = [[UILabel alloc] init];
        [_bottomView addSubview:lab1];
        lab1.whc_TopSpace(10).whc_CenterX(0).whc_WidthAuto().whc_Height(20);
        lab1.text = @"红利=分享好友的有效投注额*分享红利比例";
        lab1.textColor = colorWithRGB(51, 51, 51) ;
        lab1.font = [UIFont systemFontOfSize:14.f] ;
        
        UIView *smallBottomView = [[UIView alloc] init];
        [_bottomView addSubview:smallBottomView];
        smallBottomView.whc_LeftSpace(9).whc_RightSpace(9).whc_TopSpaceToView(10, lab1).whc_Height(30);
        smallBottomView.layer.borderWidth = 1.f;
        smallBottomView.layer.borderColor = [UIColor whiteColor].CGColor;
        smallBottomView.backgroundColor = [UIColor clearColor] ;
        
        UILabel *line3 = [[UILabel alloc] init];
        [smallBottomView addSubview:line3];
        line3.backgroundColor = [UIColor whiteColor] ;
        line3.whc_TopSpace(0).whc_Width(1).whc_CenterX(30).whc_Height(30);
        
        //表格
        UILabel *leftLab1 = [[UILabel alloc] init ];
        [smallBottomView addSubview:leftLab1];
        leftLab1.whc_LeftSpace(0).whc_TopSpace(0).whc_RightSpaceToView(0, line3).whc_BottomSpace(0);
        leftLab1.backgroundColor = colorWithRGB(228, 247, 231) ;
        leftLab1.textColor = colorWithRGB(51, 51, 51) ;
        leftLab1.font = [UIFont systemFontOfSize:14.f] ;
        leftLab1.layer.borderWidth = 1.f;
        leftLab1.layer.borderColor = [UIColor whiteColor].CGColor;
        leftLab1.text = @"分享好友有效投注人数";
        leftLab1.textAlignment = NSTextAlignmentCenter ;

        
        UILabel *rightLab1 = [[UILabel alloc] init ];
        [smallBottomView addSubview:rightLab1];
        rightLab1.whc_TopSpace(0).whc_RightSpace(0).whc_LeftSpaceToView(0, line3).whc_BottomSpace(0) ;
        rightLab1.backgroundColor = colorWithRGB(228, 247, 231) ;
        rightLab1.textColor = colorWithRGB(51, 51, 51) ;
        rightLab1.font = [UIFont systemFontOfSize:14.f] ;
        rightLab1.layer.borderColor = [UIColor whiteColor].CGColor ;
        rightLab1.text = @"分享红利比例";
        rightLab1.textAlignment = NSTextAlignmentCenter ;
        
        
        if ([THEMEV3 isEqualToString:@"green"]){
             _shareRedLab.textColor = RH_NavigationBar_BackgroundColor_Green;
             huhuiLab.textColor = RH_NavigationBar_BackgroundColor_Green;
        }else if ([THEMEV3 isEqualToString:@"red"]){
            _shareRedLab.textColor = RH_NavigationBar_BackgroundColor_Red;
            huhuiLab.textColor = RH_NavigationBar_BackgroundColor_Red;
        }else if ([THEMEV3 isEqualToString:@"black"]){
            _shareRedLab.textColor = RH_NavigationBar_BackgroundColor_Black;
            huhuiLab.textColor =RH_NavigationBar_BackgroundColor_Black;
        }else{
            _shareRedLab.textColor =  RH_NavigationBar_BackgroundColor;
            huhuiLab.textColor = RH_NavigationBar_BackgroundColor;
        }
        
     }
    return self ;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_SharePlayerRecommendModel *model = ConvertToClassPointer(RH_SharePlayerRecommendModel, context) ;
   //推荐好友成功注册并存款满${witchWithdraw}元
    _contentLab1.text = [NSString stringWithFormat:@"推荐好友成功注册并存款满%@元",model.mWitchWithdraw];
    // mReward 满足存款条件后谁获利：1 表示双方获取奖励 2表示你将会得到 其他表示你推荐的好友会获取到
    if ([model.mReward isEqualToString:@"1"])
    {
        _contentLab2.text = [NSString stringWithFormat:@"双方各获%@元奖励",model.mMoney];
    }else if ([model.mReward isEqualToString:@"2"])
    {
        _contentLab2.text = [NSString stringWithFormat:@"你将会获得%@元奖励",model.mMoney];
    }else
    {
         _contentLab2.text = [NSString stringWithFormat:@"推荐的好友将会获得%@元奖励",model.mMoney];
    }
    if (!model.mIsBonus) {
        _shareRedLab.hidden = YES;
        _bottomView.hidden = YES ;
    }else
    {
        _shareRedLab.hidden = NO;
        _bottomView.hidden = NO ;
    }
        
    
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
