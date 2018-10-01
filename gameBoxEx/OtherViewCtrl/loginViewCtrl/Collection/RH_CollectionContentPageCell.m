//
//  RH_CollectionContentPageCell.m
//  gameBoxEx
//
//  Created by paul on 2018/9/30.
//  Copyright © 2018 luis. All rights reserved.
//

#import "RH_CollectionContentPageCell.h"
#import "RH_LoadingIndicateTableViewCell.h"
#import "RH_CollectionTableViewCell.h"
@interface RH_CollectionContentPageCell()
@property(nonatomic,strong) RH_LoadingIndicateTableViewCell *loadingIndicateTableViewCell ;
@property (nonatomic,assign)NSInteger typeIndex;
@property (nonatomic,strong)NSArray  * dataArray;
@end
@implementation RH_CollectionContentPageCell
-(void)updateViewWithType:(NSInteger)typeModel  Context:(CLPageLoadDatasContext*)context
{
    self.typeIndex = typeModel;
    if (self.contentTableView == nil) {
        self.contentTableView = [[UITableView alloc] initWithFrame:self.myContentView.bounds style:UITableViewStyleGrouped];
        self.contentTableView.delegate = self   ;
        self.contentTableView.dataSource = self ;
        self.contentTableView.sectionFooterHeight = 10.0f;
        self.contentTableView.sectionHeaderHeight = 10.0f ;
        self.contentTableView.backgroundColor = [UIColor clearColor];
        self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.contentTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.myContentView.frameWidth, 0.1f)] ;
        self.contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.myContentView.frameWidth, 0.1f)] ;
        
        [self.contentTableView registerCellWithClass:[RH_CollectionTableViewCell class]] ;
        self.contentScrollView = self.contentTableView;
        
        [self setupPageLoadManagerWithdatasContext:context] ;
        
    }else {
        [self updateWithContext:context];
    }
}
#pragma mark-
-(CLPageLoadManagerForTableAndCollectionView*)createPageLoadManager
{
    return [[CLPageLoadManagerForTableAndCollectionView alloc] initWithScrollView:self.contentTableView
                                                          pageLoadControllerClass:[CLArrayPageLoadController class]
                                                                         pageSize:[self defaultPageSize]
                                                                     startSection:0
                                                                         startRow:0
                                                                   segmentedCount:1];
    
}
-(void)networkStatusChangeHandle
{
    if (NetworkAvailable()){
        [self startUpdateData] ;
    }
}
#pragma mark-
- (UIEdgeInsets)contentScorllViewInitContentInset {
    return UIEdgeInsetsMake(0.0f, 0.f, 0.f, 0.f) ;
}

-(void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self startUpdateData] ;
}
#pragma mark - 加载数据操作和回调方法
- (void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize {
    //do nothing
    if (self.typeIndex==0) {
        NSArray * array = [NSArray arrayWithContentsOfFile:[self pathForFile:@"gameURL"]];
        [self loadDataSuccessWithDatas:array
                            totalCount:array.count
                        completedBlock:nil];
    }else{
        
    }
}

- (void)cancelLoadDataHandle {
    //do nothing
     [self.serviceRequest cancleAllServices] ;
}


#pragma mark-UITableView delegate  datasource method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX(1, self.pageLoadManager.currentDataCount) ;
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        return 100 ;
    }else{
        return tableView.boundHeigh - tableView.contentInset.top - tableView.contentInset.bottom ;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RH_CollectionTableViewCell defaultReuseIdentifier]] ;
        [cell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
//        cell.delegate = self ;
        cell.backgroundColor = [UIColor clearColor];
        return cell ;
    }else{
        return self.loadingIndicateTableViewCell ;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data{
    
}
-(void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error{
    
}

-(NSString*)pathForFile:(NSString*)fileName{
    NSString  * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePatch = [path stringByAppendingPathComponent:fileName];
    return filePatch;
}

#pragma mark-- getter method
-(RH_LoadingIndicateTableViewCell*)loadingIndicateTableViewCell
{
    if (!_loadingIndicateTableViewCell){
        _loadingIndicateTableViewCell = [[RH_LoadingIndicateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _loadingIndicateTableViewCell.backgroundColor = [UIColor whiteColor];
        _loadingIndicateTableViewCell.loadingIndicateView.delegate = self;
    }
    
    return _loadingIndicateTableViewCell ;
}

-(RH_LoadingIndicateView*)loadingIndicateView
{
    return self.loadingIndicateTableViewCell.loadingIndicateView ;
}

-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray  array];
    }
    return _dataArray;
}
@end
