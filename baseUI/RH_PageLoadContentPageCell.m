//
//  RH_PageLoadContentPageCell.m
//  TaskTracking
//
//  Created by jinguihua on 2017/6/8.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_PageLoadContentPageCell.h"
#import "CLScrollContentPageCell.h"
#import "RH_ModelInfoCachePool.h"
#import "RH_APPDelegate.h"

@implementation RH_PageLoadContentPageCell
{
    //加载更多的次数
    NSUInteger _loadMoreCount;
}


@synthesize serviceRequest = _serviceRequest;
@synthesize loadingIndicateView = _loadingIndicateView;


#pragma mark -

- (RH_ServiceRequest *)serviceRequest
{
    if(!_serviceRequest){
        _serviceRequest = [[RH_ServiceRequest alloc] init];
        _serviceRequest.delegate = self;
    }

    return _serviceRequest;
}

//- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type SpecifiedError:(NSError *)error
//{
//    if (error.code==600 || error.code==1){
//        showMessage(nil, error.code==600?@"session过期":@"该帐号已在另一设备登录", @"请重新登入...");
//        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
//        [appDelegate updateLoginStatus:NO] ;
//        [self loginButtonItemHandle] ;
//    }
//}

- (RH_LoadingIndicateView *)loadingIndicateView
{
    if (!_loadingIndicateView) {
        _loadingIndicateView = [[RH_LoadingIndicateView alloc] initWithFrame:self.myContentView.bounds];
        _loadingIndicateView.marginValue = [self contentScorllViewContentInset];
        _loadingIndicateView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _loadingIndicateView.delegate = self;
        [self.myContentView addSubview:_loadingIndicateView];

        //初始化配置
        [self configureContentLoadingIndicateView:_loadingIndicateView];
    }

    return _loadingIndicateView;
}

- (void)configureContentLoadingIndicateView:(RH_LoadingIndicateView *)loadingIndicateView {
    //do nothing
}

#pragma mark -

- (RH_LoadingIndicateView *)pageLoadingIndicateView {
    return self.loadingIndicateView;
}

- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    if (loadingIndicateView == [self pageLoadingIndicateView]) {

        //没有在更新,则开始更新
        if(self.pageLoadManager.dataLoadType != CLDataLoadTypeUpdate) {
            [self startUpdateData:YES];
        }else {
            [self updateIndicaterViewWithStatus:CLIndicaterViewStatusLoading context:nil];
        }
    }
}

- (BOOL)showNotingIndicaterView {
    return NO;
}

- (NSString *)nothingIndicateTitle {
    return @"暂无相关内容";
}

- (void)updateIndicaterViewWithStatus:(CLIndicaterViewStatus)status context:(id)context
{
    switch (status) {
        case CLIndicaterViewStatusHidden:
            [[self pageLoadingIndicateView] hiddenView];
            break;

        case CLIndicaterViewStatusLoading:
            [[self pageLoadingIndicateView] showLoadingStatusWithTitle:nil detailText:nil];
            break;

        case CLIndicaterViewStatusError:
        {
            if (self.lastLoadingError){
                [[self pageLoadingIndicateView] showDefaultLoadingErrorStatus:self.lastLoadingError];
            }else{
                [[self pageLoadingIndicateView] showDefaultLoadingErrorStatus];
            }
        }
            break;

        case CLIndicaterViewStatusNoNet:
            [[self pageLoadingIndicateView] showNoNetworkStatus];
            break;

        case CLIndicaterViewStatusNothing:
            if (![self showNotingIndicaterView]) {
                [[self pageLoadingIndicateView] showNothingWithTitle:[self nothingIndicateTitle]];
            }
            break;

        default:
            break;
    }
}

#pragma mark -

- (void)didEndLoadData:(BOOL)isUpdateData success:(BOOL)success
{
    if (!success) {
        return;
    }

    if (isUpdateData) {

        if (_loadMoreCount) {
//            Class dataClass = [self pageLoadDataClassForStatistics];
//            [RH_StatisticsManager didCompletedLoadData:dataClass withLoadTimes:_loadMoreCount - 1];
        }

        _loadMoreCount = 1;

    }else {
        ++ _loadMoreCount;
    }
}

- (Class)pageLoadDataClassForStatistics {
    return nil;
}

#pragma mark -

- (CLDataStoreType)dataStoreTypeForSavaDateWithKey:(NSString *)key {
    return CLDataStoreTypeInMemory;
}

- (void)saveData:(id)data toCustomDataStore:(CLDataStoreType)dataStoreType withKey:(NSString *)key
{
    if (dataStoreType == CLDataStoreTypeInMemory) {

        if (data) {
            [[RH_ModelInfoCachePool shareCachePool] cacheData:data withType:key forContext:[self contextForDataSaveInMemoryWithKey:key]];
        }else {
            [[RH_ModelInfoCachePool shareCachePool] removeCacheDatasWithType:key forContext:[self contextForDataSaveInMemoryWithKey:key]];
        }
    }
}

- (id)getDataSavedInCustomStore:(CLDataStoreType)dataStoreType withKey:(NSString *)key
{
    if (dataStoreType == CLDataStoreTypeInMemory) {
        return [[RH_ModelInfoCachePool shareCachePool] getDataWithType:key forContext:[self contextForDataSaveInMemoryWithKey:key]];
    }

    return nil;
}

- (id)contextForDataSaveInMemoryWithKey:(NSString *)key {
    return nil;
}

@end
