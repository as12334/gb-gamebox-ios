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
@interface RH_MPSystemNoticeViewController ()
@property (nonatomic,strong,readonly)RH_MPSystemNoticeCell *systemNoticeCell;
@property (nonatomic,strong,readonly)RH_MPSystemNoticHeaderView *headerView;
@end

@implementation RH_MPSystemNoticeViewController
@synthesize systemNoticeCell = _gameNoticeCell;
@synthesize headerView = _headerView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    [self setupUI];
}
-(void)setupUI{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self ;
    self.contentTableView.dataSource = self ;
    [self.contentTableView registerCellWithClass:[RH_MPSystemNoticeCell class]] ;
    
    [self.contentView addSubview:self.contentTableView] ;
    [self.contentTableView reloadData] ;
}
#pragma  mark headerView
-(RH_MPSystemNoticHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [RH_MPSystemNoticHeaderView createInstance];
        _headerView.frame  = CGRectMake(0, 0, self.view.frameWidth, 50);
    }
    return _headerView;
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
    
    return self.headerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RH_MPSystemNoticeCell *noticeCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_MPSystemNoticeCell defaultReuseIdentifier]];
    return noticeCell ;
}


@end

