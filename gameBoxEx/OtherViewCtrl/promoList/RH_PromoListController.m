//
//  RH_PromoListController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PromoListController.h"
#import "coreLib.h"
#import "RH_PreferentialListCell.h"
#import "RH_API.h"
#import "RH_PromoInfoModel.h"


@interface RH_PromoListController ()
@end

@implementation RH_PromoListController
- (BOOL)isSubViewController {
    return  YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"优惠记录";
    [self setupInfo];
    self.contentView.backgroundColor = colorWithRGB(239, 239, 239);
}

- (void)setupInfo
{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO];
    self.contentTableView.sectionHeaderHeight = 9.0f ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    [self.contentTableView registerCellWithClass:[RH_PreferentialListCell class]] ;
    [self.contentView addSubview:self.contentTableView];
    [self setupPageLoadManager] ;
}


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
                                        detailText:@"您暂无相关优惠记录"] ;
    return YES ;
    
}

#pragma mark-
-(void)netStatusChangedHandle
{
    if (NetworkAvailable()){
        [self startUpdateData] ;
    }
}

-(NSUInteger)defaultPageSize
{
    CGFloat contentHeigh =  self.contentTableView.frameHeigh - self.contentTableView.contentInset.top - self.contentTableView.contentInset.bottom ;
    CGFloat cellHeigh = [RH_PreferentialListCell heightForCellWithInfo:nil tableView:nil context:nil] ;
    return floorf(contentHeigh/cellHeigh) ;
}

#pragma mark- 请求回调
-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
    [self.serviceRequest startV3PromoList:page+1 PageSize:pageSize] ;
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
    if (type == ServiceRequestTypeV3PromoList){
        NSDictionary *dictTmp = ConvertToClassPointer(NSDictionary, data)  ;
        [self loadDataSuccessWithDatas:[dictTmp arrayValueForKey:RH_GP_PROMOLIST_LIST]
                            totalCount:[dictTmp integerValueForKey:RH_GP_PROMOLIST_TOTALCOUNT]] ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3PromoList){
        [self loadDataFailWithError:error] ;
    }
}

#pragma mark-tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX(1, self.pageLoadManager.currentDataCount) ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        return [RH_PreferentialListCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
    }else{
        CGFloat height = MainScreenH - tableView.contentInset.top - tableView.contentInset.bottom ;
        return height ;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_PreferentialListCell *promoCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_PreferentialListCell defaultReuseIdentifier]] ;
        [promoCell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]];
        return promoCell ;
        
    }else{
        return self.loadingIndicateTableViewCell ;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    RH_PromoInfoModel *model = ConvertToClassPointer(RH_PromoInfoModel, [self.pageLoadManager dataAtIndex:indexPath.row]) ;
//    NSLog(@"%ld",model.mID) ;
//    NSString *mStr = [NSString stringWithFormat:@"/promo/promoDetail.html?searchId=%ld",model.mID] ;
//    [self.navigationController pushViewController:[RH_PromoDetailViewController viewControllerWithContext:mStr] animated:YES] ;
}




@end
