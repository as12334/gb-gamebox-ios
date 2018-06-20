//
//  RH_FirstBigViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/13.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_FirstBigViewCell.h"
#import "coreLib.h"
#import "RH_FirstBigCellHeadView.h"
#import "RH_RewardRuleTableViewCell.h"
#import "RH_ShareRecordTableViewCell.h"
#import "RH_SharePlayerRecommendModel.h"
#import "RH_ShareRecordModel.h"
#import "RH_DatePickerView.h"
@interface RH_FirstBigViewCell ()<firstBigCellHeadViewDelegate,CLPageViewDelegate,CLPageViewDatasource,UITableViewDelegate,UITableViewDataSource,RH_ShareRecordTableViewCellDelegate>
@property(nonatomic,strong,readonly)RH_FirstBigCellHeadView *headView ;
@property(nonatomic,strong)RH_SharePlayerRecommendModel *recommendModel;
@property(nonatomic,strong)RH_ShareRecordModel *shareRecordModel;
@property(nonatomic,strong)UITableView *bigTableView;
@property(nonatomic,assign)NSInteger selectIndex;
@end
@implementation RH_FirstBigViewCell
@synthesize headView = _headView ;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
#pragma mark ==============获取数据================
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    NSArray *array = ConvertToClassPointer(NSArray, context);
    
    self.recommendModel = array[0];
    self.shareRecordModel = array[1];
    [self.bigTableView reloadData];
}
#pragma mark ==============创建UI================

-(void)createUI{
    [self.contentView addSubview:self.headView];
    self.bigTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, self.headView.frameHeigh+20,MainScreenW-40,300.f/375*screenSize().width-self.headView.frameHeigh+30) style:UITableViewStylePlain];
    self.bigTableView.delegate = self   ;
    self.bigTableView.dataSource = self ;
    self.bigTableView.sectionFooterHeight = 10.0f;
    self.bigTableView.sectionHeaderHeight = 10.0f ;
    self.bigTableView.backgroundColor = [UIColor clearColor];
    self.bigTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bigTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.frameWidth, 0.1f)] ;
    self.bigTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.frameWidth, 0.1f)] ;
    self.bigTableView.layer.cornerRadius = 5.f;
    self.bigTableView.scrollEnabled = NO;
    [self.contentView addSubview:self.bigTableView];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_bigTableView) {
        return 300;
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
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectIndex==0) {
        static NSString *ID = @"cellID";
        RH_RewardRuleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[RH_RewardRuleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        [cell updateCellWithInfo:nil context:self.recommendModel];
        cell.layer.cornerRadius = 5.f;
        cell.contentView.layer.cornerRadius= 5.f;
        return cell;
    }
    else if(self.selectIndex==1){
        static NSString *ID = @"cell";
        RH_ShareRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[RH_ShareRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        [cell updateCellWithInfo:nil context:self.shareRecordModel];
        cell.layer.cornerRadius = 5.f;
        cell.contentView.layer.cornerRadius= 5.f;
        cell.delegate = self;
        return cell;
    }
    return nil;
    
}

#pragma mark --- 头视图
-(RH_FirstBigCellHeadView *)headView
{
    if (!_headView) {
        _headView = [[RH_FirstBigCellHeadView alloc]initWithFrame:CGRectMake(0, 10,MainScreenW, 50)];
        _headView.delegate= self;
    }
    return _headView;
}

#pragma mark - firstBigCellHeadViewDelegate
-(void)firstBigCellHeadViewDidChangedSelectedIndex:(RH_FirstBigCellHeadView *)firstBigCellHeadView SelectedIndex:(NSInteger)selectedIndex
{
    self.selectIndex= selectedIndex ;
    [self.bigTableView reloadData];
}
#pragma mark ==============shareRecordDlegate================
-(void)shareRecordTableViewWillSelectedStartDate:(RH_ShareRecordTableViewCell *)shareRecordTableView DefaultDate:(NSDate *)defaultDate
{
    RH_DatePickerView *datePickerView = [RH_DatePickerView shareCalendarView:@"设置开始日期" defaultDate:nil];
    ;
    datePickerView.chooseDateBlock = ^(NSDate *date) {
        shareRecordTableView.startDate = date;
    };
    [[UIApplication sharedApplication].keyWindow addSubview:datePickerView.coverView];
    [[UIApplication sharedApplication].keyWindow addSubview:datePickerView];
}
-(void)shareRecordTableViewWillSelectedEndDate:(RH_ShareRecordTableViewCell *)shareRecordTableView DefaultDate:(NSDate *)defaultDate
{
    RH_DatePickerView *datePickerView = [RH_DatePickerView shareCalendarView:@"设置结束日期" defaultDate:nil];
    ;
    datePickerView.chooseDateBlock = ^(NSDate *date) {
        shareRecordTableView.endDate = date;
    };
    [[UIApplication sharedApplication].keyWindow addSubview:datePickerView.coverView];
    [[UIApplication sharedApplication].keyWindow addSubview:datePickerView];
}
#pragma mark ==============searchDelegate================
-(void)shareRecordTableViewSearchBtnDidTouch:(RH_ShareRecordTableViewCell *)shareRecordTableViewCell
{
ifRespondsSelector(self.delegate, @selector(firstBigViewCellSearchSharelist:endDate:))
    {
        [self.delegate firstBigViewCellSearchSharelist:shareRecordTableViewCell.startDate endDate:shareRecordTableViewCell.endDate];
    }
}
@end
