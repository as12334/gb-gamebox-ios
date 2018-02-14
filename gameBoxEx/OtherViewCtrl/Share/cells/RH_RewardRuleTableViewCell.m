//
//  RH_RewardRuleTableViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/13.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_RewardRuleTableViewCell.h"
#import "coreLib.h"

@implementation RH_RewardRuleTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = colorWithRGB(242, 242, 242) ;
        [self.contentView addSubview:topView ];
        topView.whc_LeftSpace(20).whc_RightSpace(20).whc_TopSpace(20).whc_Height(73) ;
        
        topView.layer.borderWidth = 1.f ;
        topView.layer.borderColor = colorWithRGB(204, 204, 204).CGColor ;
        topView.layer.cornerRadius = 5.f;
        topView.layer.masksToBounds = YES ;
        
        UILabel *huhuiLab = [[UILabel alloc] init];
        [topView addSubview:huhuiLab];
        huhuiLab.whc_CenterX(0).whc_TopSpace(-10).whc_Height(20).whc_WidthAuto();
        huhuiLab.text = @"互惠奖励";
        huhuiLab.textColor = colorWithRGB(27, 117, 217) ;
        huhuiLab.font = [UIFont boldSystemFontOfSize:14.f] ;
        
        UILabel *contentLab1 = [[UILabel alloc] init ];
        [topView addSubview:contentLab1];
        contentLab1.whc_TopSpaceToView(20, huhuiLab).whc_WidthAuto().whc_CenterX(0) ;
        contentLab1.textAlignment = NSTextAlignmentCenter ;
        contentLab1.text = @"推荐好友成功注册并存款满500元";
        contentLab1.textColor = colorWithRGB(51, 51, 51) ;
        contentLab1.font = [UIFont systemFontOfSize:14.f] ;
        
        UILabel *contentLab2 = [[UILabel alloc] init ];
        [topView addSubview:contentLab2];
        contentLab2.whc_TopSpaceToView(20, contentLab1).whc_WidthAuto().whc_CenterX(0) ;
        contentLab2.textAlignment = NSTextAlignmentCenter ;
        contentLab2.text = @"双方各获20元奖励";
        contentLab2.textColor = colorWithRGB(51, 51, 51) ;
        contentLab2.font = [UIFont systemFontOfSize:14.f] ;
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = colorWithRGB(242, 242, 242) ;
        [self.contentView addSubview:bottomView];
        bottomView.layer.borderWidth = 1.f ;
        bottomView.layer.borderColor = colorWithRGB(204, 204, 204).CGColor ;
        bottomView.layer.cornerRadius = 5.f;
        bottomView.layer.masksToBounds = YES ;
        
        UILabel *shareRedLab = [[UILabel alloc] init];
        [bottomView addSubview:shareRedLab];
        shareRedLab.whc_TopSpace(-10).whc_CenterX(0).whc_Height(20).whc_WidthAuto();
        shareRedLab.text = @"分享红利";
        shareRedLab.textColor = colorWithRGB(27, 117, 217) ;
        shareRedLab.font = [UIFont boldSystemFontOfSize:14.f] ;
        
        UILabel *lab1 = [[UILabel alloc] init];
        [bottomView addSubview:lab1];
        lab1.whc_TopSpaceToView(10, shareRedLab).whc_CenterX(0).whc_WidthAuto().whc_Height(20);
        lab1.text = @"红利=分享好友的有效投注额*分享红利比例";
        lab1.textColor = colorWithRGB(51, 51, 51) ;
        lab1.font = [UIFont systemFontOfSize:14.f] ;
        
        
        
        
     }
    return self ;
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
