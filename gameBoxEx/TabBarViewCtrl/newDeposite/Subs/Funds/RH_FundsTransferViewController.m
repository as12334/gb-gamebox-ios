//
//  RH_FundsTransferViewController.m
//  gameBoxEx
//
//  Created by jun on 2018/9/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_FundsTransferViewController.h"
#import "RH_FundsHeadCollectionReusableView.h"
#import "RH_FundsCollectionViewCell.h"
#import "RH_FundsFooterView.h"
#import "RH_MineInfoModel.h"
#import "RH_UserGroupInfoModel.h"
#import "RH_UserApiBalanceModel.h"
@interface RH_FundsTransferViewController ()<RH_FundsFooterViewDelegate,RH_FundsCollectionViewCellDelegate>
@property(nonatomic,strong)NSMutableArray *statusArray;
@property(nonatomic,copy)NSString *flag;
@property(nonatomic,copy)NSString *aipId;
@property(nonatomic,assign)NSInteger index;
@end

@implementation RH_FundsTransferViewController

-(BOOL)hasBottomView{
    return YES;
}
-(CGFloat)bottomViewHeight{
    return  0;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      self.hiddenNavigationBar = YES;
    self.statusArray = [NSMutableArray array];
    CGFloat tab_height = TABBAR_HEIGHT;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing =  1;
    layout.minimumInteritemSpacing = 1;
    layout.headerReferenceSize = CGSizeMake(screenSize().width, 130);
    layout.sectionInset = UIEdgeInsetsMake(1, 0, 0, 0);
    self.contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screenSize().width, screenSize().height-tab_height-NavigationBarHeight-STATUS_HEIGHT-40-44) collectionViewLayout:layout];
    self.contentCollectionView.backgroundColor = colorWithRGB(230, 230, 230);
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.contentCollectionView];
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"RH_FundsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"RH_FundsCollectionViewCell"];
    [self.contentCollectionView registerCellWithClass:[RH_LoadingIndicaterCollectionViewCell class]] ;
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"RH_FundsHeadCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RH_FundsHeadCollectionReusableView"];

    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.contentCollectionView.bounds), screenSize().width, 44) ;
    RH_FundsFooterView *footView = [[NSBundle mainBundle]loadNibNamed:@"RH_FundsFooterView" owner:self options:nil].lastObject;
    footView.frame = CGRectMake(0, 0, screenSize().width, 44);
    footView.delegate = self;
    [self.bottomView addSubview:footView];
    
     [self setupPageLoadManager] ;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}
#pragma mark--
#pragma mark--collectionView delagate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return MAX(1, self.pageLoadManager.currentDataCount) ;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.pageLoadManager.currentDataCount){
        RH_FundsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RH_FundsCollectionViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell updateUIWithModel:[self.pageLoadManager dataAtIndexPath:indexPath] Animation:[self.statusArray[indexPath.row] boolValue] IndexPath:indexPath];
        return cell;
    }else{
        return self.loadingIndicateCollectionViewCell ;
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    // 复用SectionHeaderView,SectionHeaderView是xib创建的
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        RH_FundsHeadCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RH_FundsHeadCollectionReusableView" forIndexPath:indexPath];
        return headerView;
    }
    return nil;
    
}
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        return CGSizeMake((screenSize().width-2.0)/3.0, 72); ;
    }else{
        return self.contentCollectionView.frame.size  ;
    }
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

-(BOOL)showNotingIndicaterView
{
    [self.loadingIndicateView showNothingWithImage:ImageWithName(@"empty_searchRec_image")
                                             title:nil
                                        detailText:@"您暂无相关数据"] ;
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
    [self.serviceRequest startV3UserInfo] ;
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
    if (type == ServiceRequestTypeV3UserInfo) {
        RH_UserGroupInfoModel *model = ConvertToClassPointer(RH_UserGroupInfoModel, data) ;
        RH_MineInfoModel *infoModel = model.mUserSetting ;
        NSArray *userApiModel = infoModel.mApisBalanceList;
        for (int i = 0; i < userApiModel.count; i++) {
            [self.statusArray addObject:[NSNumber numberWithBool:NO]];
        }
        [self loadDataSuccessWithDatas:userApiModel?userApiModel:@[]
                            totalCount:userApiModel?userApiModel.count:0] ;
    }else if(type == ServiceRequestTypeV3OneStepRecory){
        [self refreshColleciontView];
        showMessageWithImage(self.view, @"回收成功", nil, [UIImage imageNamed:@"icon_success"]);
    }else if (type == ServiceRequestTypeV3RefreshApi){
        //单个刷新,单个刷新之后就单个回收API
         [self.serviceRequest startV3OneStepRecoverySearchId:self.aipId];
    }else if (type == ServiceRequestTypeV3OneStepRefresh){
        //一键刷新
        if ([data count] > 0 ) {
            showMessageWithImage(self.view, @"刷新成功", nil, [UIImage imageNamed:@"icon_success"]);
            NSArray *userApiModel = ConvertToClassPointer(NSArray, data);
    
            for (int i = 0; i < userApiModel.count; i++) {
                [self.statusArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
            }
            [self loadDataSuccessWithDatas:userApiModel?userApiModel:@[]
                                totalCount:userApiModel?userApiModel.count:0] ;
            [self.contentTableView reloadData] ;
        }else
        {
            showMessageWithImage(self.view, @"刷新失败", nil, [UIImage imageNamed:@"icon_unsuccess"]);
        }
    }
}
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (error.code == 1001) {
        return ;
    }
    if (type == ServiceRequestTypeV3UserInfo) {
        showErrorMessage(nil, error, nil) ;
    }else if (type == ServiceRequestTypeV3OneStepRecory){
        showMessageWithImage(self.view, @"回收失败", nil, [UIImage imageNamed:@"icon_unsuccess"]);
        [self refreshColleciontView];
    }else if (type == ServiceRequestTypeV3RefreshApi){
        showErrorMessage(nil, error, @"资金刷新失败") ;
    }else if (type == ServiceRequestTypeV3OneStepRefresh)
    {
        showErrorMessage(nil, error, nil) ;
    }
}
-(void)refreshColleciontView{
    if ([self.flag isEqualToString:@"allRecouvery"]) {
        //所有的都回收
        for ( int i = 0; i < self.statusArray.count; i++) {
            [self.statusArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
            [self.contentCollectionView reloadData];
        }
    }else if([self.flag isEqualToString:@"oneRecouvery"]){
        //单个回收
        [self.statusArray replaceObjectAtIndex:self.index withObject:[NSNumber numberWithBool:NO]];
        [self.contentCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.index inSection:0]]];
    }
    
}
#pragma mark--
#pragma mark--footerView代理
- (void)oneKeyRefreshOrRecoveryByTag:(NSInteger)tag{
    if (tag == 0) {
        //一键刷新
        [self.serviceRequest startV3OneStepRefresh];
    }else if (tag == 1){
        //一键回收
        self.flag = @"allRecouvery";
        for ( int i = 0; i < self.statusArray.count; i++) {
            [self.statusArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
        }
        [self.contentCollectionView reloadData];
        [self.serviceRequest startV3OneStepRecoverySearchId:nil] ;
    }
}
#pragma mark--
#pragma mark--cell代理
- (void)refreshAndRecouveryByApiId:(NSString *)apiId Index:(NSInteger)index IsMaintaining:(BOOL)isMaintaining{
    if (isMaintaining) {
        showMessageWithImage(self.view, @"维护中", nil, [UIImage imageNamed:@"icon_maintaining"]);
    }else{
    self.flag = @"oneRecouvery";
    self.aipId = apiId;
    self.index = index;
    [self.statusArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:YES]];
    [self.contentCollectionView reloadData];
    [self.serviceRequest startV3RefreshApiWithApiId:apiId];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end