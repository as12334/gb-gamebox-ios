//
//  RH_LotteryGameListViewController.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/5.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_LotteryGameListViewController.h"
#import "RH_LotteryGameListTopView.h"
#import "RH_GameListCollectionViewCell.h"
#import "RH_LotteryAPIInfoModel.h"
#import "RH_API.h"

@interface RH_LotteryGameListViewController ()
@property(nonatomic,strong,readonly)RH_LotteryGameListTopView *searchView;
@end

@implementation RH_LotteryGameListViewController
{
    RH_LotteryAPIInfoModel *_lotteryApiModel ;
}
@synthesize searchView = _searchView;
-(void)setupViewContext:(id)context
{
    _lotteryApiModel = ConvertToClassPointer(RH_LotteryAPIInfoModel, context) ;
}

-(BOOL)hasTopView
{
    return YES;
}
-(CGFloat)topViewHeight
{
    return 35;
}
-(BOOL)isSubViewController
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}
-(void)setupUI{
    [self.topView addSubview:self.searchView];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置headerView的尺寸大小
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width,0);
    //该方法也可以设置itemSize
//    layout.itemSize =CGSizeMake(110, 150);
    self.contentCollectionView = [self createCollectionViewWithLayout:layout updateControl:NO loadControl:NO];
    self.contentCollectionView.delegate=self;
    self.contentCollectionView.dataSource=self;
    [self.contentCollectionView registerCellWithClass:[RH_GameListCollectionViewCell class]] ;
    [self.contentView addSubview:self.contentCollectionView] ;
    [self.contentCollectionView reloadData] ;
    
    [self setupPageLoadManager] ;
}
#pragma mark searchView
-(RH_LotteryGameListTopView *)searchView
{
    if (!_searchView) {
        _searchView = [RH_LotteryGameListTopView createInstance];
        _searchView.frame = CGRectMake(0, 0, self.topView.frameWidth, 35);
    }
    return _searchView;
}

#pragma mark- netStatusChangedHandle
-(void)netStatusChangedHandle
{
    if (NetworkAvailable() && [self.pageLoadManager currentDataCount]==0){
        [self startUpdateData] ;
    }
}

#pragma mark- 请求回调
-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
    [self.serviceRequest startV3GameListWithApiID:_lotteryApiModel.mApiID
                                        ApiTypeID:_lotteryApiModel.mApiTypeID
                                       PageNumber:page
                                         PageSize:pageSize
                                       SearchName:nil] ;
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
                            totalCount:[dictTmp integerValueForKey:RH_GP_APIGAMELIST_TOTALCOUNT]] ;

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
//        RH_LoadingIndicaterCollectionViewCell * cell = [collectionView  dequeueReusableCellWithReuseIdentifier:[RH_LoadingIndicaterCollectionViewCell defaultReuseIdentifier] forIndexPath:indexPath];
//        cell.backgroundColor = [UIColor whiteColor];
//        cell.loadingIndicateView.delegate = self;
//        _pageLoadingIndicateView = cell.loadingIndicateView;
//
//        //更新加载指示视图
//        [self setNeedUpdateIndicaterView];
        
//        return cell;
    }
    
    return nil ;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        return [RH_GameListCollectionViewCell sizeForViewWithInfo:nil containerViewSize:collectionView.bounds.size context:nil] ;
    }else{
        return CGSizeZero  ;
    }
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

@end
