//
//  RH_SiteMineNoticeDetailController.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/26.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SiteMineNoticeDetailController.h"
#import "RH_SiteMineNoticeDetailCell.h"
#import "RH_SiteMyMessageDetailModel.h"
#import "RH_SiteMyMessageModel.h"
#import "coreLib.h"
@interface RH_SiteMineNoticeDetailController ()
@property (nonatomic,strong)RH_SiteMyMessageModel *detailModel;
@end

@implementation RH_SiteMineNoticeDetailController

-(BOOL)isSubViewController
{
    return YES;
}
-(void)setupViewContext:(id)context
{
    self.detailModel = ConvertToClassPointer(RH_SiteMyMessageModel, context);
}
+(void)configureNavigationBar:(UINavigationBar *)navigationBar
{
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"] ){
        navigationBar.barStyle = UIBarStyleDefault ;
        if (GreaterThanIOS11System){
            if ([THEMEV3 isEqualToString:@"green"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green ;
            }else if ([THEMEV3 isEqualToString:@"red"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red ;
            }else if ([THEMEV3 isEqualToString:@"black"]){
                navigationBar.barTintColor = ColorWithNumberRGB(0x1766bb) ;
            }else{
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor ;
            }
        }else
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
            [navigationBar insertSubview:backgroundView atIndex:0] ;
            if ([THEMEV3 isEqualToString:@"green"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Green ;
            }else if ([THEMEV3 isEqualToString:@"red"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Red ;
            }else if ([THEMEV3 isEqualToString:@"black"]){
                backgroundView.backgroundColor = ColorWithNumberRGB(0x1766bb) ;
            }else{
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor ;
            }
        }
        
        navigationBar.titleTextAttributes = @{NSFontAttributeName:RH_NavigationBar_TitleFontSize,
                                              NSForegroundColorAttributeName:RH_NavigationBar_ForegroundColor} ;
    }else{
        navigationBar.barStyle = UIBarStyleDefault ;
        if (GreaterThanIOS11System){
            navigationBar.barTintColor = [UIColor blackColor];
        }else
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
            [navigationBar insertSubview:backgroundView atIndex:0] ;
            backgroundView.backgroundColor = [UIColor blackColor] ;
        }
        
        navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0f],
                                              NSForegroundColorAttributeName:[UIColor whiteColor]} ;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的消息详情";
    [self setupUI];
}
-(void)setupUI{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self ;
    self.contentTableView.dataSource = self ;
    self.contentTableView.estimatedRowHeight = 56;
    self.contentTableView.rowHeight = UITableViewAutomaticDimension;
    [self.contentTableView registerCellWithClass:[RH_SiteMineNoticeDetailCell class]] ;
    [self.contentView addSubview:self.contentTableView] ;
    [self.contentTableView reloadData] ;
    self.needObserverTapGesture = YES ;
    [self setupPageLoadManager] ;
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
    
    //    [self.serviceRequest startV3LoadSystemNoticeDetailSearchId:self.systemModel.mID];
    [self.serviceRequest startV3SiteMessageMyMessageDetailWithID:[NSString stringWithFormat:@"%ld",(long)self.detailModel.mId]];
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
    NSMutableArray *array = [NSMutableArray array];
    if (type == ServiceRequestTypeV3SiteMessageMyMessageDetail){
        for (RH_SiteMyMessageDetailModel *model in data) {
            RH_SiteMyMessageDetailModel *detailModel = ConvertToClassPointer(RH_SiteMyMessageDetailModel, model);
            [array addObject:detailModel];
            for (RH_SiteMyMessageDetailListModel *lModel in detailModel.listModel) {
                RH_SiteMyMessageDetailListModel *listModel = ConvertToClassPointer(RH_SiteMyMessageDetailListModel, lModel);
                [array addObject:listModel];
            }
            
        }
        NSArray *modelArray = [array copy];
        [self loadDataSuccessWithDatas:data?modelArray:@[]
                            totalCount:data?1:0] ;
        [self.detailModel updataReadStatus:YES];
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3SiteMessageMyMessageDetail){
        [self loadDataFailWithError:error] ;
    }
}

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
        return [RH_SiteMineNoticeDetailCell heightForCellWithInfo:nil tableView:tableView context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
    }else{
        CGFloat height = MainScreenH - tableView.contentInset.top - tableView.contentInset.bottom ;
        return height ;
    }
    
    //    return 40.0f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_SiteMineNoticeDetailCell *noticeCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_SiteMineNoticeDetailCell defaultReuseIdentifier]] ;
        [noticeCell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
        return noticeCell ;
    }else{
        return self.loadingIndicateTableViewCell ;
    }
}
@end
