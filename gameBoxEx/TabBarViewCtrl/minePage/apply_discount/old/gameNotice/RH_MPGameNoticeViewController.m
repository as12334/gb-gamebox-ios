//
//  RH_MPGameNoticeViewController.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPGameNoticeViewController.h"
#import "RH_MPGameNoticeCell.h"
#import "RH_MPGameNoticHeaderView.h"
@interface RH_MPGameNoticeViewController ()
@property (nonatomic,strong,readonly)RH_MPGameNoticeCell *gameNoticeCell;
@property (nonatomic,strong,readonly)RH_MPGameNoticHeaderView *headerView;
@end

@implementation RH_MPGameNoticeViewController
@synthesize gameNoticeCell = _gameNoticeCell;
@synthesize headerView = _headerView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationBar setHidden:YES];
    [self setupUI];
}
-(void)setupUI{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO] ;
    self.contentTableView.frame = CGRectMake(0,-64, self.view.frameWidth, self.contentView.frameHeigh-114);
    self.contentTableView.delegate = self ;
    self.contentTableView.dataSource = self ;
    [self.contentTableView registerCellWithClass:[RH_MPGameNoticeCell class]] ;
    [self.contentView addSubview:self.contentTableView] ;
    [self.contentTableView reloadData] ;
}
#pragma  mark headerView
-(RH_MPGameNoticHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [RH_MPGameNoticHeaderView createInstance];
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
    RH_MPGameNoticeCell *noticeCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_MPGameNoticeCell defaultReuseIdentifier]];
    return noticeCell ;
}


@end
