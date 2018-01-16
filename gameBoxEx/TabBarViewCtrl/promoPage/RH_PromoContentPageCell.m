//
//  RH_PromoContentPageCell.m
//  TaskTracking
//
//  Created by jinguihua on 2017/6/9.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_PromoContentPageCell.h"
#import "RH_LoadingIndicateTableViewCell.h"
#import "RH_PromoTableCell.h"
#import "RH_API.h"

@interface RH_PromoContentPageCell()
@property(nonatomic,strong,readonly) RH_LoadingIndicateTableViewCell *loadingIndicateTableViewCell ;
@end

@implementation RH_PromoContentPageCell
@synthesize loadingIndicateTableViewCell = _loadingIndicateTableViewCell ;

-(void)updateViewWithType:(id)type Context:(CLPageLoadDatasContext*)context
{
    
    if (self.contentTableView == nil) {
        self.contentTableView = [[UITableView alloc] initWithFrame:self.myContentView.bounds style:UITableViewStyleGrouped];
        self.contentTableView.delegate = self   ;
        self.contentTableView.dataSource = self ;
        self.contentTableView.backgroundColor = [UIColor clearColor];
        self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentTableView registerCellWithClass:[RH_PromoTableCell class]] ;
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
                                                          pageLoadControllerClass:nil
                                                                         pageSize:[self defaultPageSize]
                                                                     startSection:0
                                                                         startRow:0
                                                                   segmentedCount:1];
    
}

#pragma mark-
- (UIEdgeInsets)contentScorllViewInitContentInset {
//    return UIEdgeInsetsMake(NavigationBarHeight + StatusBarHeight + TopViewHeight, 0.f, 0.f, 0.f) ;
    return UIEdgeInsetsMake(0.0f, 0.f, 0.f, 0.f) ;
}

-(void)networkStatusChangeHandle
{
    if (NetworkAvailable()){
        [self startUpdateData] ;
    }
}

-(void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self startUpdateData] ;
}

-(BOOL)showNotingIndicaterView
{
    [self.loadingIndicateView showNothingWithImage:nil title:@"当前无优惠活动"
                                        detailText:nil] ;
    return YES ;
}

#pragma mark-
-(NSUInteger)defaultPageSize
{
    return 100000 ;
}

-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
    [self.serviceRequest cancleAllServices] ;
//    [self.serviceRequest startGetFirstPage:[RH_UserManager shareUserManager].userID
//                               CurrentPage:page
//                                  PageSize:pageSize] ;
//
}

-(void)cancelLoadDataHandle
{
    [self.serviceRequest cancleAllServices] ;
}

#pragma mark-
- (void) serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
//    if (type==ServiceRequestTypeFirstPage)
//    {
//        [self loadDataSuccessWithDatas:ConvertToClassPointer(NSArray, data[RH_GP_COMMON_DATALIST])
//                            totalCount:[data integerValueForKey:RH_GP_COMMON_TOTALCOUNT]
//                        completedBlock:nil];
//
//    }
}


- (void) serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
//    if (type==ServiceRequestTypeFirstPage )
//    {
//        [self loadDataFailWithError:error] ;
//    }
}


#pragma mark-
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

#pragma mark-tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX(1, self.pageLoadManager.currentDataCount) ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        return [RH_PromoTableCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
    }else{
        return tableView.boundHeigh - tableView.contentInset.top - tableView.contentInset.bottom ;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_PromoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[RH_PromoTableCell defaultReuseIdentifier]] ;
        [cell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
        return cell ;
    }else{
        return self.loadingIndicateTableViewCell ;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
//        RH_TaskDetailViewController *taskDetailViewController = [RH_TaskDetailViewController viewControllerWithContext:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
//        taskDetailViewController.delegate = self.delegate;
//        [self object:self wantToShowViewController:taskDetailViewController animated:YES completedBlock:nil] ;
//        [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    }
}


@end
