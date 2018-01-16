//
//  RH_SiteMessageSystemNoticeController.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SiteMessageSystemNoticeController.h"
#import "RH_MPSiteMessageHeaderView.h"
#import "RH_MPSiteSystemNoticeCell.h"
#import "RH_API.h"
@interface RH_SiteMessageSystemNoticeController ()<MPSiteMessageHeaderViewDelegate>
@property(nonatomic,strong)RH_MPSiteMessageHeaderView *headerView;
@end

@implementation RH_SiteMessageSystemNoticeController
@synthesize headerView = _headerView;
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationBar.hidden = YES;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
     [self setupUI];
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
-(void)setupUI{
    
    self.contentView.frame = CGRectMake(0,0, self.view.frameWidth, self.contentView.frameHeigh);
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
#pragma mark-
#pragma mark-tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

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
    if (self.pageLoadManager.currentDataCount){
        RH_MPSiteSystemNoticeCell *noticeCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_MPSiteSystemNoticeCell defaultReuseIdentifier]] ;
        [noticeCell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    RH_GameNoticeDetailController *detailVC= [RH_GameNoticeDetailController viewControllerWithContext:[self.pageLoadManager dataAtIndexPath:indexPath]];
    //    [self.navigationController pushViewController:detailVC animated:YES];
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
