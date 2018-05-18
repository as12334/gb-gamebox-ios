//
//  RH_ShowShareRecordViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/19.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ShowShareRecordViewCell.h"
#import "coreLib.h"
#import "RH_SharePlayerRecommendModel.h"

@interface RH_ShowShareRecordViewCell()
//竖线
@property(nonatomic,strong)UILabel *line1 ;
@property(nonatomic,strong)UILabel *line2 ;
@property(nonatomic,strong)UILabel *line3 ;
// 显示内容左至右
@property(nonatomic,strong)UILabel *contentLab1 ;
@property(nonatomic,strong)UILabel *contentLab2 ;
@property(nonatomic,strong)UILabel *contentLab3 ;
@property(nonatomic,strong)UILabel *contentLab4 ;
@end

@implementation RH_ShowShareRecordViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = colorWithRGB(242, 242, 242) ;
        _topView = [[UIView alloc] init];
        [self.contentView addSubview:_topView];
        _topView.layer.borderWidth = 1.f ;
        _topView.layer.borderColor = [UIColor whiteColor].CGColor;
        _topView.whc_TopSpace(0).whc_RightSpace(10).whc_LeftSpace(10).whc_Height(35);
        //竖线
        _line1 = [[UILabel alloc] init];
        [_topView addSubview:_line1];
        _line1.backgroundColor = [UIColor whiteColor] ;
        _line1.whc_LeftSpace((screenSize().width-60)/4.0).whc_TopSpace(0).whc_BottomSpace(0).whc_Width(1) ;
        
        _line2 = [[UILabel alloc] init];
        [_topView addSubview:_line2];
        _line2.backgroundColor = [UIColor whiteColor] ;
        _line2.whc_CenterX(0).whc_TopSpace(0).whc_BottomSpace(0).whc_Width(1) ;
        
        _line3 = [[UILabel alloc] init];
        [_topView addSubview:_line3];
        _line3.backgroundColor = [UIColor whiteColor] ;
        _line3.whc_LeftSpaceToView((screenSize().width-60)/4.0, _line2).whc_TopSpace(0).whc_BottomSpace(0).whc_Width(1) ;
        _contentLab1 = [[UILabel alloc] init];
        [_topView addSubview:_contentLab1];
        _contentLab1.whc_LeftSpace(0).whc_TopSpace(0).whc_RightSpaceToView(0, _line1).whc_BottomSpace(0) ;
        _contentLab1.textColor = colorWithRGB(68, 68, 68) ;
        _contentLab1.font = [UIFont systemFontOfSize:14.f] ;
        _contentLab1.textAlignment = NSTextAlignmentCenter ;
        
        _contentLab2 = [[UILabel alloc] init];
        [_topView addSubview:_contentLab2];
        _contentLab2.whc_LeftSpaceToView(0, _line1).whc_TopSpace(0).whc_RightSpaceToView(0, _line2).whc_BottomSpace(0) ;
        _contentLab2.textColor = colorWithRGB(68, 68, 68) ;
        _contentLab2.font = [UIFont systemFontOfSize:14.f] ;
        _contentLab2.textAlignment = NSTextAlignmentCenter ;
        
        _contentLab3 = [[UILabel alloc] init];
        [_topView addSubview:_contentLab3];
        _contentLab3.whc_LeftSpaceToView(0, _line2).whc_TopSpace(0).whc_RightSpaceToView(0, _line3).whc_BottomSpace(0) ;
        _contentLab3.textColor = colorWithRGB(68, 68, 68) ;
        _contentLab3.font = [UIFont systemFontOfSize:14.f] ;
        _contentLab3.textAlignment = NSTextAlignmentCenter ;
        
        _contentLab4 = [[UILabel alloc] init];
        [_topView addSubview:_contentLab4];
        _contentLab4.whc_LeftSpaceToView(0, _line3).whc_TopSpace(0).whc_RightSpace(0).whc_BottomSpace(0) ;
        _contentLab4.textColor = colorWithRGB(68, 68, 68) ;
        _contentLab4.font = [UIFont systemFontOfSize:14.f] ;
        _contentLab4.textAlignment = NSTextAlignmentCenter ;
    }
    return self ;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_SharePlayerRecommendModel *recommendModel = ConvertToClassPointer(RH_SharePlayerRecommendModel, context) ;
//    _contentLab1.text = [NSString stringWithFormat:@"111"];
//    _contentLab2.text = [NSString stringWithFormat:@"222"];
//    _contentLab3.text = [NSString stringWithFormat:@"333"];
//    _contentLab4.text = [NSString stringWithFormat:@"444"];
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
