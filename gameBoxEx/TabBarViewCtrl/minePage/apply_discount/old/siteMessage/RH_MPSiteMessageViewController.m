//
//  RH_MPSiteMessageViewController.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPSiteMessageViewController.h"
#import "RH_MPSiteSystemNoticeCell.h"
#include "coreLib.h"
#import "RH_MPSiteMessageHeaderView.h"
#import "RH_SiteSendMessageView.h"

@interface RH_MPSiteMessageViewController ()
@property(nonatomic,strong)RH_MPSiteMessageHeaderView *headerView;
@property(nonatomic,strong,readonly)RH_SiteSendMessageView *sendView;
@property(nonatomic,strong)NSMutableArray *btnArray;
@property(nonatomic,strong)UIButton *chooseBtn;
@end

@implementation RH_MPSiteMessageViewController
@synthesize headerView = _headerView;
@synthesize sendView = _sendView;
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _btnArray = [NSMutableArray array];
    [self setupUI];
    
}

#pragma mark tableView的上部分的选择模块
-(RH_MPSiteMessageHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [RH_MPSiteMessageHeaderView createInstance];
        _headerView.frame = CGRectMake(0, 100, self.view.frameWidth, 40);
    }
    return _headerView;
}
-(RH_SiteSendMessageView *)sendView
{
    if (!_sendView) {
        _sendView = [RH_SiteSendMessageView createInstance];
        _sendView.frame = CGRectMake(0,40 , self.view.frameWidth, self.view.frameHeigh-40);
    }
    return _sendView;
}
-(void)setupUI{
    //加上三个按钮
    NSArray *btnTitleArray = @[@"系统消息",@"我的消息",@"发送消息"];
    for (int i = 0; i<3; i++) {
        UIButton *btn  =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10+70*i, 10, 60, 30);
        btn.backgroundColor = [UIColor lightGrayColor];
        [btn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:11.f];
        btn.tag  = 10+i;
        [btn addTarget:self action:@selector(selectedChooseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor lightGrayColor]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        if (i==0) {
            btn.backgroundColor = [UIColor blueColor];
            btn.selected = YES;
            self.chooseBtn = btn;
        }
        [self.view addSubview:btn];
    }
  
//        [_btnArray[0] setBackgroundColor:[UIColor blueColor]];
//        [_btnArray[0] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    self.contentView.frame = CGRectMake(0, 40, self.view.frameWidth, self.contentView.frameHeigh-40);
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO] ;
    self.contentTableView.frame = CGRectMake(0,0, self.view.frameWidth, self.contentView.frameHeigh);
    self.contentTableView.delegate = self ;
    self.contentTableView.dataSource = self ;
    [self.contentTableView registerCellWithClass:[RH_MPSiteSystemNoticeCell class]] ;
    self.contentTableView.contentInset = UIEdgeInsetsMake(0, 0,0, 0);
    [self.contentView addSubview:self.contentTableView] ;
    [self.contentTableView reloadData] ;
}
#pragma mark 选择按钮的点击事件
-(void)selectedChooseBtn:(UIButton *)button
{
    if (!button.isSelected) {
        self.chooseBtn.selected = !self.chooseBtn.selected;
        self.chooseBtn.backgroundColor = [UIColor lightGrayColor];
        button.selected = !button.selected;
        button.backgroundColor = [UIColor blueColor];
        self.chooseBtn = button;
        
    }
    if (button.tag==10) {
        [self.sendView removeFromSuperview];
        [self.contentView addSubview:self.contentTableView];
    }
    else if (button.tag==11)
    {
        [self.sendView removeFromSuperview];
        [self.contentView addSubview:self.contentTableView];
    }
    else if (button.tag == 12)
    {
        [self.contentTableView removeFromSuperview];
        [self.view addSubview:self.sendView];
    }
}

#pragma mark- tabelView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    return [RH_MPGameNoticeCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RH_MPSiteSystemNoticeCell *noticeCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_MPSiteSystemNoticeCell defaultReuseIdentifier]];
    return noticeCell ;
}
@end
