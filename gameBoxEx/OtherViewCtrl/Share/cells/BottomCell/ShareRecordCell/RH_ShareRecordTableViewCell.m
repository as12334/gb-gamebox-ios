//
//  RH_ShareRecordTableViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/13.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ShareRecordTableViewCell.h"
#import "coreLib.h"
#import "RH_ShareSeletedDateView.h"

/***smallCell***/
#import "RH_SmallHeadView.h"
#import "RH_SmallShareTableViewCell.h"



@interface RH_ShareRecordTableViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong,readonly)RH_ShareSeletedDateView *startShareDateCell;
@property(nonatomic,strong,readonly)RH_ShareSeletedDateView *endShareDateCell;
@property(nonatomic,strong,readonly)RH_SmallHeadView *smallHeadView ;
@end

@implementation RH_ShareRecordTableViewCell
@synthesize startShareDateCell = _startShareDateCell ;
@synthesize endShareDateCell = _endShareDateCell ;
@synthesize smallHeadView = _smallHeadView;
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
        touzhuLab.whc_LeftSpace(10).whc_CenterY(0).whc_Height(30).whc_WidthAuto();
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
        
       WHC_StackView *stackView = [[WHC_StackView alloc] init];
        [topView addSubview:stackView];
         stackView.whc_LeftSpaceToView(0, touzhuLab).whc_TopSpaceEqualView(touzhuLab).whc_RightSpaceToView(5, searchBtn).whc_HeightEqualView(searchBtn);
        stackView.whc_Column = 2;
        stackView.whc_HSpace = 20;
        stackView.whc_VSpace = 0;
        stackView.whc_Orientation = Horizontal;
        [stackView addSubview:self.startShareDateCell];
        [stackView addSubview:self.endShareDateCell];
        stackView.whc_Edge = UIEdgeInsetsMake(0, 0, 0, 0);
        [stackView whc_StartLayout];
        
        UILabel *label_ = [[UILabel alloc] init];
        [stackView addSubview:label_];
        label_.whc_Center(0, 0).whc_Width(30);
        label_.text = @"~";
        label_.textAlignment = NSTextAlignmentCenter;
        
        UIView *bottomView = [[UIView alloc] init];
        [self.contentView addSubview:bottomView];
        bottomView.backgroundColor = [UIColor redColor] ;
        bottomView.whc_TopSpaceToView(10, topView).whc_LeftSpace(10).whc_RightSpace(10).whc_BottomSpace(5);
        
        
        _smallHeadView = [[RH_SmallHeadView alloc] init];
         [bottomView addSubview:_smallHeadView];
        _smallHeadView.whc_LeftSpace(0).whc_TopSpace(0).whc_RightSpace(0).whc_Height(30) ;

       
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

-(RH_ShareSeletedDateView *)startShareDateCell
{
    if (!_startShareDateCell) {
        _startShareDateCell = [RH_ShareSeletedDateView createInstance];
        [_startShareDateCell updateUIWithDate:_startDate] ;
        [_startShareDateCell addTarget:self Selector:@selector(startShareDateCellHandle)] ;
    }
    return _startShareDateCell ;
}
-(void)startShareDateCellHandle
{
    ifRespondsSelector(self.delegate, @selector(shareRecordTableViewWillSelectedStartDate:DefaultDate:)){
        [self.delegate shareRecordTableViewWillSelectedStartDate:self DefaultDate:_startDate] ;
    }
}

-(RH_ShareSeletedDateView *)endShareDateCell
{
    if (!_endShareDateCell) {
        _endShareDateCell = [RH_ShareSeletedDateView createInstance];        
        [_endShareDateCell updateUIWithDate:_endDate];
        [_endShareDateCell addTarget:self action:@selector(endShareDateCellHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endShareDateCell;
}



-(void)endShareDateCellHandle
{
    ifRespondsSelector(self.delegate, @selector(shareRecordTableViewWillSelectedEndDate:DefaultDate:)){
        [self.delegate shareRecordTableViewWillSelectedEndDate:self DefaultDate:_endDate] ;
    }
}
#pragma mark - tableViewDelegate
#pragma mark-
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return 30.f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RH_SmallShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RH_SmallShareTableViewCell defaultReuseIdentifier]] ;
    return cell;

}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    return _smallHeadView;
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
