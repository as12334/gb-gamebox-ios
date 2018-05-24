//
//  RH_GameListContentPageCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_GameListContentPageCell.h"
#import "RH_GameListCollectionViewCell.h"
#import "RH_LoadingIndicaterCollectionViewCell.h"
#import "RH_API.h"
#import "RH_UserInfoManager.h"
#import "RH_GamesViewController.h"
#import "coreLib.h"

@interface RH_GameListContentPageCell()
@property (nonatomic,strong) RH_LotteryAPIInfoModel *lotteryInfoModel ;
@property (nonatomic,strong) NSDictionary *typeModel ;
@property (nonatomic,strong) NSString *searchName;
@property (nonatomic,strong,readonly) RH_LoadingIndicaterCollectionViewCell *loadingIndicateCollectionViewCell ;
@end



@implementation RH_GameListContentPageCell
@synthesize loadingIndicateCollectionViewCell = _loadingIndicateCollectionViewCell ;

-(void)updateViewWithType:(NSDictionary*)typeModel
               SearchName:(NSString*)searchName
             APIInfoModel:(RH_LotteryAPIInfoModel*)lotteryApiInfo
                  Context:(CLPageLoadDatasContext*)context
{
    self.lotteryInfoModel = ConvertToClassPointer(RH_LotteryAPIInfoModel, lotteryApiInfo) ;
    self.typeModel = ConvertToClassPointer(NSDictionary, typeModel) ;
    self.searchName = searchName ;
    
    if (self.contentCollectionView == nil) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10.f;
        flowLayout.sectionInset = UIEdgeInsetsMake(10.0, 10.f, 10.0f, 10.0f);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake((MainScreenW -50)/4,(MainScreenW-50)/4*7/5);
        
        //该方法也可以设置itemSize
        //    layout.itemSize =CGSizeMake(110, 150);
        self.contentCollectionView = [[UICollectionView alloc] initWithFrame:self.myContentView.bounds collectionViewLayout:flowLayout] ;
        self.contentCollectionView.delegate=self;
        self.contentCollectionView.dataSource=self;
        [self.contentCollectionView registerCellWithClass:[RH_GameListCollectionViewCell class]] ;
        [self.contentCollectionView registerCellWithClass:[RH_LoadingIndicaterCollectionViewCell class]] ;
        self.contentCollectionView.backgroundColor = [UIColor clearColor];
        if ([THEMEV3 isEqualToString:@"black"]||[THEMEV3 isEqualToString:@"green"]||[THEMEV3 isEqualToString:@"red"]||[THEMEV3 isEqualToString:@"blue"]||[THEMEV3 isEqualToString:@"orange"]||[THEMEV3 isEqualToString:@"coffee_black"]) {
            self.contentCollectionView.backgroundColor = [UIColor blackColor];
        }
        
        self.contentScrollView = self.contentCollectionView;
        [self setupPageLoadManagerWithdatasContext:context] ;
        
    }else {
        [self updateWithContext:context];
    }
}


#pragma mark- RH_LoadingIndicaterCollectionViewCell
-(RH_LoadingIndicaterCollectionViewCell*)loadingIndicateCollectionViewCell
{
    if (!_loadingIndicateCollectionViewCell) {
        _loadingIndicateCollectionViewCell = [self.contentCollectionView dequeueReusableCellWithReuseIdentifier:[RH_LoadingIndicaterCollectionViewCell defaultReuseIdentifier] forIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]  ;
        _loadingIndicateCollectionViewCell.backgroundColor = [UIColor clearColor];
        _loadingIndicateCollectionViewCell.contentInset = UIEdgeInsetsMake(5.f, 0.f, 5.f, 0.f);
        _loadingIndicateCollectionViewCell.loadingIndicateView.backgroundColor = [UIColor whiteColor];
        _loadingIndicateCollectionViewCell.loadingIndicateView.delegate = self;
    }
    
    return _loadingIndicateCollectionViewCell;
}

-(RH_LoadingIndicateView*)contentLoadingIndicateView
{
    return self.loadingIndicateCollectionViewCell.loadingIndicateView ;
}


- (CLPageLoadManagerForTableAndCollectionView *)createPageLoadManager
{
    return [[CLPageLoadManagerForTableAndCollectionView alloc] initWithScrollView:self.contentCollectionView
                                                          pageLoadControllerClass:nil
                                                                         pageSize:[self defaultPageSize]
                                                                     startSection:0
                                                                         startRow:0
                                                                   segmentedCount:1] ;
}

#pragma mark- netStatusChangedHandle
-(void)netStatusChangedHandle
{
    if (NetworkAvailable() && [self.pageLoadManager currentDataCount]==0){
        [self startUpdateData] ;
    }
}

#pragma mark- 请求回调
-(NSUInteger)defaultPageSize
{
//    return self.contentCollectionView.frameHeigh/((MainScreenW-50)/4*7/5)*4;
    return 20 ;
}

-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
    [self.serviceRequest startV3GameListWithApiID:self.lotteryInfoModel.mApiID
                                        ApiTypeID:self.lotteryInfoModel.mApiTypeID
                                       PageNumber:page+1
                                         PageSize:[self defaultPageSize]
                                       SearchName:self.searchName
                                            TagID:[self.typeModel stringValueForKey:@"key"]] ;
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
    
    if (type == ServiceRequestTypeV3APIGameList){
        NSDictionary *dictTmp = ConvertToClassPointer(NSDictionary, data) ;
        [self loadDataSuccessWithDatas:[dictTmp arrayValueForKey:RH_GP_APIGAMELIST_LIST]
                            totalCount:[dictTmp integerValueForKey:RH_GP_APIGAMELIST_TOTALCOUNT]
                        completedBlock:nil];
        
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3APIGameList){
        [self loadDataFailWithError:error] ;
    }
}


#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MAX(1, self.pageLoadManager.currentDataCount);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_GameListCollectionViewCell *gameCell = [self.contentCollectionView dequeueReusableCellWithReuseIdentifier:[RH_GameListCollectionViewCell defaultReuseIdentifier] forIndexPath:indexPath];
        [gameCell updateViewWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
        return gameCell;
    }else{
        return self.loadingIndicateCollectionViewCell ;
    }
    
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        return [RH_GameListCollectionViewCell sizeForViewWithInfo:nil containerViewSize:collectionView.bounds.size context:nil] ;
    }else{
        return self.bounds.size  ;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_LotteryInfoModel *lotteryInfoModel = ConvertToClassPointer(RH_LotteryInfoModel, [self.pageLoadManager dataAtIndexPath:indexPath]) ;
        ifRespondsSelector(self.delegate, @selector(gameListContentPageCellDidTouchCell:CellModel:)){
            [self.delegate gameListContentPageCellDidTouchCell:self CellModel:lotteryInfoModel] ;
        }
    }
}

@end
