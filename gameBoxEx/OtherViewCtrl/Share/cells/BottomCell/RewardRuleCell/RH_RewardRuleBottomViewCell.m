//
//  RH_BottomDataListViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_RewardRuleBottomViewCell.h"
#import "coreLib.h"
#import "RH_SharePlayerRecommendModel.h"

@interface RH_RewardRuleBottomViewCell()
@property(nonatomic,strong)UILabel *leftLab ;
@property(nonatomic,strong)UILabel *rightLab ;
@end
@implementation RH_RewardRuleBottomViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = colorWithRGB(242, 242, 242) ;
        self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine ;
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        self.separatorLineColor = [UIColor whiteColor];

        UIView *bgView = [[UIView alloc] init];
        [self.contentView addSubview:bgView];
        bgView.whc_LeftSpace(10).whc_RightSpace(10).whc_TopSpace(10).whc_Height(30) ;
        bgView.backgroundColor =  colorWithRGB(242, 242, 242) ;
        
        UILabel *leftLine = [[UILabel alloc] init];
        [bgView addSubview:leftLine];
        leftLine.backgroundColor = [UIColor whiteColor] ;
        leftLine.whc_TopSpace(0).whc_Width(1).whc_LeftSpace(0).whc_Height(30);
        
        UILabel *rightLine = [[UILabel alloc] init];
        [bgView addSubview:rightLine];
        rightLine.backgroundColor = [UIColor whiteColor] ;
        rightLine.whc_TopSpace(0).whc_Width(1).whc_RightSpace(0).whc_Height(30);
        
        UILabel *middleLine = [[UILabel alloc] init];
        [bgView addSubview:middleLine];
        middleLine.backgroundColor = [UIColor whiteColor] ;
        middleLine.whc_TopSpace(0).whc_Width(1).whc_CenterX(30).whc_Height(30);
        
        _leftLab = [[UILabel alloc] init];
        [bgView addSubview:_leftLab];
        _leftLab.whc_TopSpace(0).whc_LeftSpaceToView(0, leftLine).whc_RightSpaceToView(0, middleLine).whc_Height(30);
        _leftLab.textColor = colorWithRGB(51, 51, 51) ;
        _leftLab.font = [UIFont systemFontOfSize:14.f] ;
        _leftLab.backgroundColor = colorWithRGB(228, 235, 247);
        _leftLab.textAlignment = NSTextAlignmentCenter ;
        _leftLab.text = @"1以上";
        
        _rightLab = [[UILabel alloc] init];
        [bgView addSubview:_rightLab];
        _rightLab.whc_TopSpace(0).whc_LeftSpaceToView(0, middleLine).whc_RightSpaceToView(0, rightLine).whc_Height(30);
        _rightLab.textColor = colorWithRGB(51, 51, 51) ;
        _rightLab.font = [UIFont systemFontOfSize:14.f] ;
        _rightLab.backgroundColor = colorWithRGB(228, 235, 247);
        _rightLab.textAlignment = NSTextAlignmentCenter ;
        _rightLab.text = @"0.02%";
        
    }
    return self ;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    
    NSArray *arr = ConvertToClassPointer(NSArray , context) ;
    NSArray *dataArr = [self dataWithArr:arr] ;
    for (RH_GradientTempArrayListModel *model in dataArr) {
          _rightLab.text = [[NSString stringWithFormat:@"%@",model.mProportion] stringByAppendingString:@"%"];
         _leftLab.text = [NSString stringWithFormat:@"%@以上",model.mPlayerNum] ;
    }
}

-(NSArray *)dataWithArr:(NSArray *)arr
{
    NSMutableArray *mArr = [NSMutableArray array] ;
    for (RH_GradientTempArrayListModel *model in arr) {
        [mArr addObject:model];
    }
    return mArr ;
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
