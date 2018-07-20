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
#import "RH_ShareRecordModel.h"
#import "RH_ShowShareRecordViewCell.h"



@interface RH_ShareRecordTableViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong,readonly)RH_ShareSeletedDateView *startShareDateCell;
@property(nonatomic,strong,readonly)RH_ShareSeletedDateView *endShareDateCell;
@property(nonatomic,strong)RH_ShareRecordModel *shareRecordModel;
//分享记录列表
@property(nonatomic,strong,readonly)UITableView *recordTableView;
@end

@implementation RH_ShareRecordTableViewCell
@synthesize startShareDateCell = _startShareDateCell ;
@synthesize endShareDateCell = _endShareDateCell ;
@synthesize recordTableView = _recordTableView;
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
        touzhuLab.text = @"注册时间:";
        touzhuLab.textColor = colorWithRGB(51, 51, 51) ;
        touzhuLab.font = [UIFont systemFontOfSize:12.f] ;
        
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [topView addSubview:searchBtn];
        searchBtn.whc_RightSpace(10).whc_Width(44).whc_CenterY(0).whc_Height(30);
        [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        searchBtn.backgroundColor = colorWithRGB(23, 102, 187) ;
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        searchBtn.layer.cornerRadius = 5.f;
        [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        searchBtn.showsTouchWhenHighlighted=YES;
        
        if ([THEMEV3 isEqualToString:@"green"]){
             searchBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
        }else if ([THEMEV3 isEqualToString:@"red"]){
            searchBtn.backgroundColor =RH_NavigationBar_BackgroundColor_Red;
        }else if ([THEMEV3 isEqualToString:@"black"]){
            searchBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
        }else{
            searchBtn.backgroundColor =  RH_NavigationBar_BackgroundColor;
        }
        
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
        bottomView.whc_TopSpaceToView(10, topView).whc_LeftSpace(10).whc_RightSpace(10).whc_BottomSpace(0);
        bottomView.backgroundColor = colorWithRGB(228, 247, 231) ;
        bottomView.layer.borderWidth = 1.f ;
        bottomView.layer.borderColor = [UIColor whiteColor].CGColor ;
        //竖线
        UILabel *line1 = [[UILabel alloc] init];
        [bottomView addSubview:line1];
        line1.backgroundColor = [UIColor whiteColor] ;
        line1.whc_LeftSpace((screenSize().width-60)/4.0).whc_TopSpace(0).whc_BottomSpace(0).whc_Width(1) ;
        
        UILabel *line2 = [[UILabel alloc] init];
        [bottomView addSubview:line2];
        line2.backgroundColor = [UIColor whiteColor] ;
        line2.whc_CenterX(0).whc_TopSpace(0).whc_BottomSpace(0).whc_Width(1) ;
        
        UILabel *line3 = [[UILabel alloc] init];
        [bottomView addSubview:line3];
        line3.backgroundColor = [UIColor whiteColor] ;
        line3.whc_LeftSpaceToView((screenSize().width-60)/4.0, line2).whc_TopSpace(0).whc_BottomSpace(0).whc_Width(1) ;

        UILabel *titleLba1 = [[UILabel alloc] init ];
        [bottomView addSubview:titleLba1];
        titleLba1.whc_LeftSpace(0).whc_TopSpace(0).whc_RightSpaceToView(0, line1).whc_Height(30) ;
        titleLba1.text = @"好友账号";
        titleLba1.textColor = colorWithRGB(68, 68, 68) ;
        titleLba1.backgroundColor = colorWithRGB(228, 247, 231) ;
        titleLba1.font = [UIFont systemFontOfSize:14.f] ;
        titleLba1.textAlignment = NSTextAlignmentCenter ;
        
        UILabel *titleLba2 = [[UILabel alloc] init ];
        [bottomView addSubview:titleLba2];
        titleLba2.whc_LeftSpaceToView(0, line1).whc_TopSpace(0).whc_RightSpaceToView(0, line2).whc_Height(30) ;
        titleLba2.text = @"注册时间";
        titleLba2.textColor = colorWithRGB(68, 68, 68) ;
        titleLba2.backgroundColor = colorWithRGB(228, 247, 231) ;
        titleLba2.font = [UIFont systemFontOfSize:14.f] ;
        titleLba2.textAlignment = NSTextAlignmentCenter ;
        
        UILabel *titleLba3 = [[UILabel alloc] init ];
        [bottomView addSubview:titleLba3];
        titleLba3.whc_LeftSpaceToView(0, line2).whc_TopSpace(0).whc_RightSpaceToView(0, line3).whc_Height(30) ;
        titleLba3.text = @"状态";
        titleLba3.textColor = colorWithRGB(68, 68, 68) ;
        titleLba3.backgroundColor = colorWithRGB(228, 247, 231) ;
        titleLba3.font = [UIFont systemFontOfSize:14.f] ;
        titleLba3.textAlignment = NSTextAlignmentCenter ;
        
        
        UILabel *titleLba4 = [[UILabel alloc] init ];
        [bottomView addSubview:titleLba4];
        titleLba4.whc_LeftSpaceToView(0, line3).whc_RightSpace(0).whc_TopSpace(0).whc_Height(30) ;
        titleLba4.text = @"推荐奖励";
        titleLba4.textColor = colorWithRGB(68, 68, 68) ;
        titleLba4.backgroundColor = colorWithRGB(228, 247, 231) ;
        titleLba4.font = [UIFont systemFontOfSize:14.f] ;
        titleLba4.textAlignment = NSTextAlignmentCenter ;
        
        [self.contentView addSubview:self.recordTableView];
        //监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadShareRecordTableView:) name:@"loadShareRecordTableView" object:nil];
    }
    return self ;
}
-(UITableView *)recordTableView
{
    if (!_recordTableView) {
        _recordTableView =  [[UITableView alloc]initWithFrame:CGRectMake(10,100,MainScreenW-60, 180) style:UITableViewStylePlain];
        _recordTableView.delegate = self;
        _recordTableView.dataSource= self;
    }
    return _recordTableView;
}
//监听通知
-(void)loadShareRecordTableView:(NSNotification *)notification{
    [self.recordTableView reloadData];
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.shareRecordModel = ConvertToClassPointer(RH_ShareRecordModel, context);
    [self.recordTableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView ==_recordTableView) {
        return 30;
    }
    else
    {
        return 300;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shareRecordModel.mCommand.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cellID";
    RH_ShowShareRecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[RH_ShowShareRecordViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (self.shareRecordModel.mCommand.count>0) {
        [cell updateCellWithInfo:nil context:self.shareRecordModel.mCommand[indexPath.item]];
    }
    cell.layer.cornerRadius = 5.f;
    cell.contentView.layer.cornerRadius= 5.f;
    return cell;
}
#pragma mark --搜索按钮点击代理
-(void)searchBtnClick
{
    ifRespondsSelector(self.delegate, @selector(shareRecordTableViewSearchBtnDidTouch:)){
        [self.delegate shareRecordTableViewSearchBtnDidTouch:self];
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
-(void)setStartDate:(NSDate *)startDate
{
    _startDate = startDate;
    [self.startShareDateCell updateUIWithDate:startDate];
}
-(void)setEndDate:(NSDate *)endDate
{
    _endDate = endDate;
    [self.endShareDateCell updateUIWithDate:endDate];
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

@end
