//
//  RH_MPGameNoticeViewController.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPSystemNoticeViewController.h"
#import "RH_MPSystemNoticeCell.h"
#import "RH_MPSystemNoticHeaderView.h"
#import "RH_MPGameNoticePulldownView.h"
@interface RH_MPSystemNoticeViewController ()<MPSystemNoticHeaderViewDelegate>
@property (nonatomic,strong,readonly)RH_MPSystemNoticeCell *systemNoticeCell;
@property (nonatomic,strong,readonly)RH_MPSystemNoticHeaderView *headerView;
@property (nonatomic,strong,readonly)RH_MPGameNoticePulldownView *listView;
@end

@implementation RH_MPSystemNoticeViewController
@synthesize systemNoticeCell = _gameNoticeCell;
@synthesize headerView = _headerView;
@synthesize listView = _listView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    [self setupUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationBar.hidden = YES;
}
-(void)setupUI{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self ;
    self.contentTableView.dataSource = self ;
    [self.contentTableView registerCellWithClass:[RH_MPSystemNoticeCell class]] ;
    self.contentTableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
    [self.contentView addSubview:self.contentTableView] ;
    [self.contentTableView reloadData] ;
     self.needObserverTapGesture = YES ;
}
#pragma  mark headerView
-(RH_MPSystemNoticHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [RH_MPSystemNoticHeaderView createInstance];
        _headerView.frame  = CGRectMake(0, 0, self.view.frameWidth, 50);
        _headerView.delegate=self;
    }
    return _headerView;
}
#pragma mark - CapitalRecordHeaderViewDelegate
-(void)gameSystemHeaderViewStartDateSelected:(RH_MPSystemNoticHeaderView *)view DefaultDate:(NSDate *)defaultDate
{
    [self showCalendarView:@"设置开始日期"
            initDateString:dateStringWithFormatter(defaultDate, @"yyyy-MM-dd")
              comfirmBlock:^(NSDate *returnDate) {
                  view.startDate = returnDate ;
              }] ;
}
-(void)gameSystemHeaderViewEndDateSelected:(RH_MPSystemNoticHeaderView *)view DefaultDate:(NSDate *)defaultDate
{
    [self showCalendarView:@"设置结止日期"
            initDateString:dateStringWithFormatter(defaultDate, @"yyyy-MM-dd")
              comfirmBlock:^(NSDate *returnDate) {
                  view.endDate = returnDate ;
              }] ;
}
#pragma mark-
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    return [RH_MPGameNoticeCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    __block RH_MPSystemNoticeViewController *weakSelf = self;
    self.headerView.block = ^(CGRect frame){
        [weakSelf selectedHeaderViewGameType:frame];
    };
    return self.headerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RH_MPSystemNoticeCell *noticeCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_MPSystemNoticeCell defaultReuseIdentifier]];
    return noticeCell ;
}
#pragma mark 点击headerview的游戏类型
-(RH_MPGameNoticePulldownView *)listView
{
    if (!_listView) {
        _listView = [[RH_MPGameNoticePulldownView alloc]init];
    }
    return _listView;
}
-(void)selectedHeaderViewGameType:(CGRect )frame
{
    if (!self.listView.superview) {
        frame.origin.y +=self.topView.frameY+self.topView.frameHeigh+frame.size.height;
        self.listView.frame = frame;
        [self.view addSubview:self.listView];
        [UIView animateWithDuration:.2f animations:^{
            CGRect framee = self.listView.frame;
            framee.size.height = 200;
            self.listView.frame = framee;
        }];
    }
    else
    {
        [UIView animateWithDuration:.2f animations:^{
            CGRect framee = self.listView.frame;
            framee.size.height = 0;
            self.listView.frame = framee;
        } completion:^(BOOL finished) {
            [self.listView removeFromSuperview];
        }];
    }
}
#pragma mark- observer Touch gesture
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.listView.superview?YES:NO ;
}

-(void)tapGestureRecognizerHandle:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if (self.listView.superview){
        [UIView animateWithDuration:0.2f animations:^{
            CGRect framee = self.listView.frame;
            framee.size.height = 0;
            self.listView.frame = framee;
        } completion:^(BOOL finished) {
            [self.listView removeFromSuperview];
        }];
    }
}
@end

