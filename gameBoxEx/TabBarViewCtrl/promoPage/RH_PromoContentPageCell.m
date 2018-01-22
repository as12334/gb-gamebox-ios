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
#import "RH_DiscountActivityModel.h"
#import "RH_APPDelegate.h"
#import "RH_API.h"
#import "RH_CustomViewController.h"
#import "RH_UserInfoManager.h"

@interface RH_PromoContentPageCell()<PromoTableCellDelegate>
@property(nonatomic,strong,readonly) RH_LoadingIndicateTableViewCell *loadingIndicateTableViewCell ;
@property (nonatomic,strong) RH_DiscountActivityTypeModel *typeModel ;
@end

@implementation RH_PromoContentPageCell
@synthesize loadingIndicateTableViewCell = _loadingIndicateTableViewCell ;

-(void)updateViewWithType:(RH_DiscountActivityTypeModel*)typeModel  Context:(CLPageLoadDatasContext*)context
{
    self.typeModel = ConvertToClassPointer(RH_DiscountActivityTypeModel, typeModel) ;

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
                                                          pageLoadControllerClass:[CLArrayPageLoadController class]
                                                                         pageSize:[self defaultPageSize]
                                                                     startSection:0
                                                                         startRow:0
                                                                   segmentedCount:1];
    
}

#pragma mark-
- (UIEdgeInsets)contentScorllViewInitContentInset {
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
                                        detailText:@"点击重试"] ;
    return YES ;
}

#pragma mark -
-(void)promoTableCellImageSizeChangedNotification:(RH_PromoTableCell*)promoTableViewCell
{
    NSIndexPath *indexPath = [self.contentTableView indexPathForCell:promoTableViewCell] ;
    if (indexPath){
        [self.contentTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone] ;
    }
}

#pragma mark-
-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
    [self.serviceRequest startV3LoadDiscountActivityTypeListWithKey:self.typeModel.mActivityKey
                                                         PageNumber:page
                                                           pageSize:pageSize] ;
}

-(void)cancelLoadDataHandle
{
    [self.serviceRequest cancleAllServices] ;
}

#pragma mark-
- (void) serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type==ServiceRequestTypeV3ActivityDetailList)
    {
        NSDictionary *dictTmp = ConvertToClassPointer(NSDictionary, data) ;
        [self loadDataSuccessWithDatas:[dictTmp arrayValueForKey:RH_GP_ACTIVITYDATALIST_LIST]
                            totalCount:[dictTmp integerValueForKey:RH_GP_ACTIVITYDATALIST_TOTALNUMBER]
                        completedBlock:nil];

    }
}


- (void) serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type==ServiceRequestTypeV3ActivityDetailList )
    {
        [self loadDataFailWithError:error] ;
    }
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
        return [RH_PromoTableCell heightForCellWithInfo:nil tableView:tableView
                                                context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
    }else{
        return tableView.boundHeigh - tableView.contentInset.top - tableView.contentInset.bottom ;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_PromoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[RH_PromoTableCell defaultReuseIdentifier]] ;
        [cell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
        cell.delegate = self ;
        return cell ;
    }else{
        return self.loadingIndicateTableViewCell ;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        if (HasLogin)
        {
            RH_DiscountActivityModel *discountActivityModel = ConvertToClassPointer(RH_DiscountActivityModel, [self.pageLoadManager dataAtIndexPath:indexPath]) ;
            
            RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
            if (appDelegate){
                appDelegate.customUrl = discountActivityModel.showLink ;
                [self showViewController:[RH_CustomViewController viewController]] ;
            }
            
        }else{
            showAlertView(@"提示信息", @"您尚未登入") ;
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
    }
}


@end
