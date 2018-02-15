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
        topView.whc_LeftSpace(10).whc_RightSpace(10).whc_TopSpace(20).whc_Height(70) ;
        
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
        contentLab1.whc_TopSpaceToView(10, huhuiLab).whc_WidthAuto().whc_CenterX(0) ;
        contentLab1.textAlignment = NSTextAlignmentCenter ;
        contentLab1.text = @"推荐好友成功注册并存款满500元";
        contentLab1.textColor = colorWithRGB(51, 51, 51) ;
        contentLab1.font = [UIFont systemFontOfSize:14.f] ;
        
        UILabel *contentLab2 = [[UILabel alloc] init ];
        [topView addSubview:contentLab2];
        contentLab2.whc_TopSpaceToView(5, contentLab1).whc_WidthAuto().whc_CenterX(0) ;
        contentLab2.textAlignment = NSTextAlignmentCenter ;
        contentLab2.text = @"双方各获20元奖励";
        contentLab2.textColor = colorWithRGB(51, 51, 51) ;
        contentLab2.font = [UIFont systemFontOfSize:14.f] ;
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = colorWithRGB(242, 242, 242) ;
        [self.contentView addSubview:bottomView];
        bottomView.whc_LeftSpace(10).whc_RightSpace(10).whc_TopSpaceToView(10, topView).whc_Height(145) ;
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
        
        UIView *smallBottomView = [[UIView alloc] init];
        [bottomView addSubview:smallBottomView];
        smallBottomView.whc_LeftSpace(9).whc_RightSpace(9).whc_TopSpaceToView(10, lab1).whc_Height(87);
        smallBottomView.layer.borderWidth = 1.f;
        smallBottomView.layer.borderColor = [UIColor whiteColor].CGColor;
        smallBottomView.backgroundColor = [UIColor clearColor] ;
        
        //线条
        UILabel *line1 = [[UILabel alloc] init];
        [smallBottomView addSubview:line1];
        line1.backgroundColor = [UIColor whiteColor] ;
        line1.whc_LeftSpace(0).whc_RightSpace(0).whc_Height(1).whc_TopSpace(29);
        
        UILabel *line2 = [[UILabel alloc] init];
        [smallBottomView addSubview:line2];
        line2.backgroundColor = [UIColor whiteColor] ;
        line2.whc_LeftSpace(0).whc_RightSpace(0).whc_Height(1).whc_TopSpace(58);
        
        UILabel *line3 = [[UILabel alloc] init];
        [smallBottomView addSubview:line3];
        line3.backgroundColor = [UIColor whiteColor] ;
        line3.whc_TopSpace(0).whc_BottomSpace(0).whc_Width(1).whc_CenterX(30);
        
        //表格
        UILabel *leftLab1 = [[UILabel alloc] init ];
        [smallBottomView addSubview:leftLab1];
        leftLab1.whc_LeftSpace(0).whc_TopSpace(0).whc_RightSpaceToView(0, line3).whc_BottomSpaceToView(0, line1);
        leftLab1.backgroundColor = colorWithRGB(228, 247, 231) ;
        leftLab1.textColor = colorWithRGB(51, 51, 51) ;
        leftLab1.font = [UIFont systemFontOfSize:14.f] ;
        leftLab1.layer.borderWidth = 1.f;
        leftLab1.layer.borderColor = [UIColor whiteColor].CGColor;
        leftLab1.text = @"分享好友有效投注人数";
        leftLab1.textAlignment = NSTextAlignmentCenter ;
        
        UILabel *leftLab2 = [[UILabel alloc] init ];
        [smallBottomView addSubview:leftLab2];
        leftLab2.whc_LeftSpace(0).whc_TopSpaceToView(0, line1).whc_RightSpaceToView(0, line3).whc_BottomSpaceToView(0, line2);
        leftLab2.backgroundColor = colorWithRGB(228, 235, 247) ;
        leftLab2.textColor = colorWithRGB(51, 51, 51) ;
        leftLab2.font = [UIFont systemFontOfSize:14.f] ;
        leftLab2.layer.borderColor = [UIColor whiteColor].CGColor ;
        leftLab2.text = @"1以上";
        leftLab2.textAlignment = NSTextAlignmentCenter ;
        
        
        UILabel *leftLab3 = [[UILabel alloc] init ];
        [smallBottomView addSubview:leftLab3];
        leftLab3.whc_LeftSpace(0).whc_TopSpaceToView(0, line2).whc_RightSpaceToView(0, line3).whc_BottomSpace(0);
        leftLab3.backgroundColor = colorWithRGB(228, 235, 247) ;
        leftLab3.textColor = colorWithRGB(51, 51, 51) ;
        leftLab3.font = [UIFont systemFontOfSize:14.f] ;
        leftLab3.layer.borderColor = [UIColor whiteColor].CGColor ;
        leftLab3.text = @"3以上";
        leftLab3.textAlignment = NSTextAlignmentCenter ;
        
        UILabel *rightLab1 = [[UILabel alloc] init ];
        [smallBottomView addSubview:rightLab1];
        rightLab1.whc_TopSpace(0).whc_RightSpace(0).whc_LeftSpaceToView(0, line3).whc_BottomSpaceToView(0, line1) ;
        rightLab1.backgroundColor = colorWithRGB(228, 247, 231) ;
        rightLab1.textColor = colorWithRGB(51, 51, 51) ;
        rightLab1.font = [UIFont systemFontOfSize:14.f] ;
        rightLab1.layer.borderColor = [UIColor whiteColor].CGColor ;
        rightLab1.text = @"分享红利比例";
        rightLab1.textAlignment = NSTextAlignmentCenter ;
        
        UILabel *rightLab2 = [[UILabel alloc] init ];
        [smallBottomView addSubview:rightLab2];
        rightLab2.whc_TopSpaceToView(0, line1).whc_LeftSpaceToView(0, line3).whc_RightSpace(0).whc_BottomSpaceToView(0,line2);
        rightLab2.backgroundColor = colorWithRGB(228, 235, 247) ;
        rightLab2.textColor = colorWithRGB(51, 51, 51) ;
        rightLab2.font = [UIFont systemFontOfSize:14.f] ;
        rightLab2.layer.borderColor = [UIColor whiteColor].CGColor ;
        rightLab2.text = @"0.02%";
        rightLab2.textAlignment = NSTextAlignmentCenter ;
        
        UILabel *rightLab3 = [[UILabel alloc] init ];
        [smallBottomView addSubview:rightLab3];
        rightLab3.whc_LeftSpaceToView(0, line3).whc_TopSpaceToView(0, line2).whc_RightSpace(0).whc_BottomSpace(0);
        rightLab3.backgroundColor = colorWithRGB(228, 235, 247) ;
        rightLab3.textColor = colorWithRGB(51, 51, 51) ;
        rightLab3.font = [UIFont systemFontOfSize:14.f] ;
        rightLab3.layer.borderColor = [UIColor whiteColor].CGColor ;
        rightLab3.text = @"0.05%";
        rightLab3.textAlignment = NSTextAlignmentCenter ;
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
