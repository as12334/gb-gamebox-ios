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
#import "CLLabel.h"

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
        self.layer.cornerRadius = 5.f ;
        self.layer.masksToBounds = YES ;
        self.contentView.backgroundColor = [UIColor clearColor] ;
        topView = [[UIView alloc] init ];
        topView.backgroundColor = colorWithRGB(255, 255, 255) ;
        [self.contentView addSubview:topView];
        
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
        self.myShareAwardLab.text = @"我的分享奖励256元" ;
        
        bottomView = [[UIView alloc] init ];
        bottomView.backgroundColor = colorWithRGB(242, 242, 242) ;
        [self.contentView addSubview:bottomView];
        
        self.friendReciprocalCountLab = [[UILabel alloc] init ];
        [bottomView addSubview:self.friendReciprocalCountLab ];
        self.friendReciprocalCountLab.textAlignment = NSTextAlignmentLeft ;
        self.friendReciprocalCountLab.whc_LeftSpace(20).whc_Width((screenSize().width-40)/2.0).whc_CenterY(0);
        self.friendReciprocalCountLab.text = @"好友互惠达成数56人";
        
        self.myShareBonusLab = [[UILabel alloc] init];
        [bottomView addSubview:self.myShareBonusLab];
        self.myShareBonusLab.textAlignment = NSTextAlignmentRight ;
        self.myShareBonusLab.whc_RightSpace(20).whc_Width((screenSize().width-40)/2.0).whc_CenterY(0);
        self.myShareBonusLab.text = @"我的分享红利256元" ;
    }
    return self ;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_SharePlayerRecommendModel *recommendModel = ConvertToClassPointer(RH_SharePlayerRecommendModel, context) ;
   
    if (recommendModel) {
        NSMutableString *firstStr = [NSMutableString stringWithFormat:@"我的分享好友%@人", recommendModel.mRemmendModel.mUser] ;
        NSRange range = [firstStr rangeOfString: recommendModel.mRemmendModel.mUser];
        //    设置变换颜色，以及变换范围(4,7)
        NSDictionary *dic = @{NSForegroundColorAttributeName:[UIColor redColor], NSKernAttributeName:@0.f
                              };
//        [self.myShareFriendCountLab ]
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
