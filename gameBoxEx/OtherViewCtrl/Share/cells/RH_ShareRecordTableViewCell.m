//
//  RH_ShareRecordTableViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/13.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ShareRecordTableViewCell.h"
#import "coreLib.h"

@implementation RH_ShareRecordTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = colorWithRGB(242, 242, 242) ;
        UIView *topView = [[UIView alloc] init];
        [self.contentView addSubview:topView];
        topView.backgroundColor = [UIColor whiteColor] ;
        topView.layer.cornerRadius = 5.f;
        topView.layer.masksToBounds = YES ;
        topView.whc_TopSpace(0).whc_RightSpace(10).whc_LeftSpace(10).whc_Height(55);
        
        UILabel *touzhuLab = [[UILabel alloc] init];
        [topView addSubview:touzhuLab];
        touzhuLab.whc_LeftSpace(10).whc_CenterY(0).whc_Height(30).whc_Width(100);
        touzhuLab.text = @"投注日期:";
        touzhuLab.textColor = colorWithRGB(51, 51, 51) ;
        touzhuLab.font = [UIFont systemFontOfSize:12.f] ;
        
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [topView addSubview:searchBtn];
        searchBtn.whc_RightSpace(10).whc_Width(44).whc_CenterY(0).whc_Height(30);
        [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        searchBtn.backgroundColor = colorWithRGB(23, 102, 187) ;
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self ;
}
#pragma mark --搜索按钮点击代理
-(void)searchBtnClick
{
    ifRespondsSelector(self.delegate, @selector(shareRecordTableViewSearchBtnDidTouchBackButton:)){
        [self.delegate shareRecordTableViewSearchBtnDidTouchBackButton:self];
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
