//
//  RH_MPSiteMessageViewController.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPSiteMessageViewController.h"
#import "RH_MPSiteMessageTopChooseView.h"
#import "RH_MPSiteSystemNoticeCell.h"
#include "coreLib.h"
@interface RH_MPSiteMessageViewController ()
@property(nonatomic,strong,readonly)RH_MPSiteMessageTopChooseView *chooseView;
@end

@implementation RH_MPSiteMessageViewController
@synthesize chooseView = _chooseView;
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBar.hidden = YES ;
//    self.hiddenTabBar = YES ;
//    self.hiddenStatusBar = YES ;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.chooseView];
     [self setupUI];
}
#pragma mark tableView的上部分的选择模块
-(RH_MPSiteMessageTopChooseView *)chooseView
{
    if (!_chooseView) {
        _chooseView = [RH_MPSiteMessageTopChooseView createInstance];
        _chooseView.frame = CGRectMake(0, 0, self.view.frameWidth, 80);
    }
    return _chooseView;
    
}
-(void)setupUI{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO] ;
    self.contentTableView.frame = CGRectMake(0,80, self.view.frameWidth, self.view.frameHeigh -80);
    self.contentTableView.delegate = self ;
    self.contentTableView.dataSource = self ;
    [self.contentTableView registerCellWithClass:[RH_MPSiteSystemNoticeCell class]] ;
    
    [self.contentView addSubview:self.contentTableView] ;
    [self.contentTableView reloadData] ;
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RH_MPSiteSystemNoticeCell *noticeCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_MPSiteSystemNoticeCell defaultReuseIdentifier]];
    return noticeCell ;
}
@end
