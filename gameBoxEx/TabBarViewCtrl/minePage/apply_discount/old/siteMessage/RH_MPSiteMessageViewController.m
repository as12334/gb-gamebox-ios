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
#import "RH_SiteMessageModel.h"
#import "RH_API.h"
@interface RH_MPSiteMessageViewController ()<MPSiteSystemNoticeCellDelegate,MPSiteMessageHeaderViewDelegate>
@property(nonatomic,strong)RH_MPSiteMessageHeaderView *headerView;
@property(nonatomic,strong,readonly)RH_SiteSendMessageView *sendView;
@property(nonatomic,strong)NSMutableArray *btnArray;
@property(nonatomic,strong)UIButton *chooseBtn;
@property(nonatomic,strong)RH_SiteMessageModel *messageModel;
@property (nonatomic,strong) NSMutableArray *modelArray;
//存放将要删除的数据
@property(nonatomic,strong)NSMutableArray  *deleteArray;

@property(nonatomic,strong)NSMutableArray *indexpPathArray;
@end

@implementation RH_MPSiteMessageViewController
{
    NSInteger _indexPathRow;
    NSIndexPath  *_markIndexPath;
}
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
    _deleteArray = [NSMutableArray array];
    _indexpPathArray =[NSMutableArray array];
    [self setupUI];
    
}

- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}
#pragma mark tableView的上部分的选择模块
-(RH_MPSiteMessageHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [RH_MPSiteMessageHeaderView createInstance];
        _headerView.frame = CGRectMake(0, 100, self.view.frameWidth, 40);
        _headerView.delegate=self;
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
    self.contentView.frame = CGRectMake(0, 40, self.view.frameWidth, self.contentView.frameHeigh-40);
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO] ;
    self.contentTableView.frame = CGRectMake(0,0, self.view.frameWidth, self.contentView.frameHeigh);
    self.contentTableView.delegate = self ;
    self.contentTableView.dataSource = self ;
//    self.contentTableView.editing = YES;
    [self.contentTableView registerCellWithClass:[RH_MPSiteSystemNoticeCell class]] ;
    self.contentTableView.contentInset = UIEdgeInsetsMake(0, 0,0, 0);
    [self.contentView addSubview:self.contentTableView] ;
    [self.contentTableView reloadData] ;
    [self setupPageLoadManager] ;
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

#pragma mark-
#pragma mark-tableView
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1 ;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX(1, self.pageLoadManager.currentDataCount) ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        return [RH_MPSiteSystemNoticeCell heightForCellWithInfo:nil tableView:tableView context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
    }else{
        CGFloat height = MainScreenH - tableView.contentInset.top - tableView.contentInset.bottom ;
        return height ;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount&&self.modelArray.count>0){
        RH_MPSiteSystemNoticeCell *noticeCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_MPSiteSystemNoticeCell defaultReuseIdentifier]] ;
        [noticeCell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
        noticeCell.delegate = self;
        RH_SiteMessageModel *model = [self.modelArray objectAtIndex:indexPath.row];
        noticeCell.selectedStatus = model.isSelected;
        __weak typeof (self)weakSelf = self;
        noticeCell.ChooseBtnBlock = ^(__weak UITableViewCell *tapCell,BOOL selected){
            NSIndexPath *path = [weakSelf.contentTableView indexPathForCell:tapCell ];
            RH_SiteMessageModel *siteModel = [weakSelf.modelArray objectAtIndex:path.row];
            siteModel.isSelected = selected;
            [weakSelf.deleteArray addObject:siteModel];
            if (!selected) {
                weakSelf.headerView.allChoseBtn.selected = selected;
                [weakSelf.deleteArray removeObject:siteModel];
            }
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:path.row inSection:1];
            
            [_indexpPathArray addObject:indexPath];
            [weakSelf calculateWhetherFutureGenerations];
        };
        
        return noticeCell ;
    }else{
        return self.loadingIndicateTableViewCell ;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}
#pragma mark cell代理
-(void)chooseSiteSystemNoticeCellEditBtn:(UIButton *)button
{
    //选中cell上的button改变cell的状态
    UITableViewCell *cell = (UITableViewCell*)[[[button superview]superview] superview];
    NSIndexPath *path = [self.contentTableView indexPathForCell:cell];
    _indexPathRow = path.row;
    [self.contentTableView reloadData];
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    RH_GameNoticeDetailController *detailVC= [RH_GameNoticeDetailController viewControllerWithContext:[self.pageLoadManager dataAtIndexPath:indexPath]];
//    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark 删除按钮时间
-(void)siteMessageHeaderViewDeleteCell:(RH_MPSiteMessageHeaderView *)view
{
    for (RH_SiteMessageModel *model in self.modelArray) {
        model.isSelected = 0;
    }
    [self.pageLoadManager removeDataAtIndexPaths:self.indexpPathArray];
    for (NSIndexPath *path in self.indexpPathArray) {
        if (path.section>0) {
        [self.contentTableView deleteRowsAtIndexPaths:self.indexpPathArray withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    [self.contentTableView reloadData];
    [self.indexpPathArray removeAllObjects];
    
}
#pragma mark 全选代理
-(void)siteMessageHeaderViewAllChoseBtn:(RH_MPSiteMessageHeaderView *)view
{
    self.headerView.allChoseBtn.selected = !self.headerView.allChoseBtn.selected;
    for (int i =0; i<self.modelArray.count; i++) {
        RH_SiteMessageModel *model = [self.modelArray objectAtIndex:i];
        model.isSelected =self.headerView.allChoseBtn.selected;
    }
    [self.contentTableView reloadData];
}
//计算是否全选
-(void)calculateWhetherFutureGenerations
{
    NSInteger totalSelected = 0;
    for (int i = 0; i<self.modelArray.count; i++) {
        RH_SiteMessageModel *model = [self.modelArray objectAtIndex:i];
        if (model.isSelected) {
            totalSelected ++;
        }
    }
    if (totalSelected == self.modelArray.count) {
        self.headerView.allChoseBtn.selected  = YES;
    }
    else{
        self.headerView.allChoseBtn.selected = NO;
    }
}

#pragma mark 数据请求
-(RH_LoadingIndicateView*)contentLoadingIndicateView
{
    return self.loadingIndicateTableViewCell.loadingIndicateView ;
}


- (CLPageLoadManagerForTableAndCollectionView *)createPageLoadManager
{
    return [[CLPageLoadManagerForTableAndCollectionView alloc] initWithScrollView:self.contentTableView
                                                          pageLoadControllerClass:nil
                                                                         pageSize:[self defaultPageSize]
                                                                     startSection:0
                                                                         startRow:0
                                                                   segmentedCount:1] ;
}

-(BOOL)showNotingIndicaterView
{
    [self.loadingIndicateView showNothingWithImage:ImageWithName(@"empty_searchRec_image")
                                             title:nil
                                        detailText:@"您暂无相关数据记录"] ;
    return YES ;
    
}
#pragma mark-
-(void)netStatusChangedHandle
{
    if (NetworkAvailable()){
        [self startUpdateData] ;
    }
}
#pragma mark- 请求回调
-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
    [self.serviceRequest startV3LoadSystemMessageWithpageNumber:page pageSize:pageSize];
}
-(void)cancelLoadDataHandle
{
    [self.serviceRequest cancleAllServices] ;
}

#pragma mark-
- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self startUpdateData] ;
}


#pragma mark-
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3SiteMessage){
        NSDictionary *dictTmp = ConvertToClassPointer(NSDictionary, data) ;
        [self loadDataSuccessWithDatas:[dictTmp arrayValueForKey:RH_GP_SYSTEMNOTICE_LIST]
                            totalCount:[dictTmp integerValueForKey:RH_GP_SYSTEMNOTICE_TOTALNUM]] ;
        for (id siteModel in [dictTmp objectForKey:@"list"]) {
            RH_SiteMessageModel *model  = ConvertToClassPointer(RH_SiteMessageModel, siteModel);
            model.isSelected = 0;
            [self.modelArray addObject:model];
        }
        [self.contentTableView reloadData];
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3SiteMessage){
        [self loadDataFailWithError:error] ;
    }
}
@end
