//
//  RH_LimitTransferViewController.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_LimitTransferViewController.h"
#import "RH_LimitTransferTopView.h"
#import "RH_LimitTransferCell.h"
#import "RH_UserInfoManager.h"
#import "RH_MineInfoModel.h"
#import "RH_UserGroupInfoModel.h"
#import "RH_UserApiBalanceModel.h"
#import "RH_BankPickerSelectView.h"

@interface RH_LimitTransferViewController ()<CLTableViewManagementDelegate, RH_LimitTransferTopViewDelegate, BankPickerSelectViewDelegate>
@property (nonatomic,strong,readonly) CLTableViewManagement *tableViewManagement;
@property (nonatomic, strong, readonly) UIView  *footerView;
@property (nonatomic, strong) RH_LimitTransferTopView  *tableTopView;
@property (nonatomic, strong, readonly) RH_BankPickerSelectView *selectView;;
@end

@implementation RH_LimitTransferViewController
@synthesize tableViewManagement = _tableViewManagement;
@synthesize footerView = _footerView;
@synthesize tableTopView = _tableTopView ;
@synthesize selectView = _selectView;
- (BOOL)isSubViewController {
    return  YES;
}

- (RH_BankPickerSelectView *)selectView {
    if (_selectView == nil) {
        _selectView = [RH_BankPickerSelectView createInstance];
        _selectView.delegate = self;
    }
    return _selectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"额度转换";
    [self setupInfo];
    self.contentView.backgroundColor = colorWithRGB(239, 239, 239);
}

- (void)setupInfo
{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO];
    self.contentTableView.sectionHeaderHeight = 9.0f ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
   
    [self.contentTableView registerCellWithClass:[RH_LimitTransferCell class]] ;
    [self.contentView addSubview:self.contentTableView];
    self.tableTopView = [[RH_LimitTransferTopView alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, 265)];
    self.tableTopView.delegate = self;
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, 100.f)]  ;
    _footerView.backgroundColor = [UIColor whiteColor] ;
    UIButton *oneStepRecoryBtn  =  [UIButton new] ;  //一键回收
    [_footerView addSubview:oneStepRecoryBtn];
    oneStepRecoryBtn.whc_LeftSpace(10).whc_TopSpace(10).whc_RightSpace(10).whc_Height(40) ;
    [oneStepRecoryBtn setTitle:@"一键回收" forState:UIControlStateNormal];
    [oneStepRecoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    oneStepRecoryBtn.titleLabel.font = [UIFont systemFontOfSize:14.f] ;
    oneStepRecoryBtn.layer.cornerRadius = 5.f ;
    oneStepRecoryBtn.layer.masksToBounds = YES ;
    
     UIButton *oneStepRefreshBtn  =  [UIButton new] ;  //一键刷新
    [_footerView addSubview:oneStepRefreshBtn];
    oneStepRefreshBtn.whc_LeftSpace(10).whc_TopSpaceToView(10, oneStepRecoryBtn).whc_RightSpace(10).whc_Height(40) ;
    [oneStepRefreshBtn setTitle:@"一键刷新" forState:UIControlStateNormal];
    [oneStepRefreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    oneStepRefreshBtn.titleLabel.font = [UIFont systemFontOfSize:14.f] ;
    oneStepRefreshBtn.layer.cornerRadius = 5.f ;
    oneStepRefreshBtn.layer.masksToBounds = YES ;
    
    if ([THEMEV3 isEqualToString:@"green"]){
        oneStepRecoryBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
        oneStepRecoryBtn.layer.borderColor = RH_NavigationBar_BackgroundColor_Green.CGColor;
        
        oneStepRefreshBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
        oneStepRefreshBtn.layer.borderColor = RH_NavigationBar_BackgroundColor_Green.CGColor;
    }else if ([THEMEV3 isEqualToString:@"red"]){
        oneStepRecoryBtn.backgroundColor =RH_NavigationBar_BackgroundColor_Red;
        oneStepRecoryBtn.layer.borderColor = RH_NavigationBar_BackgroundColor_Red.CGColor;
        
        oneStepRefreshBtn.backgroundColor =RH_NavigationBar_BackgroundColor_Red;
        oneStepRefreshBtn.layer.borderColor = RH_NavigationBar_BackgroundColor_Red.CGColor;
    }else if ([THEMEV3 isEqualToString:@"black"]){
        oneStepRecoryBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
        oneStepRecoryBtn.layer.borderColor = RH_NavigationBar_BackgroundColor_Black.CGColor;
        
        oneStepRefreshBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
        oneStepRefreshBtn.layer.borderColor = RH_NavigationBar_BackgroundColor_Black.CGColor;
    }else{
        oneStepRecoryBtn.backgroundColor = RH_NavigationBar_BackgroundColor;
        oneStepRecoryBtn.layer.borderColor = RH_NavigationBar_BackgroundColor.CGColor;
        
        oneStepRefreshBtn.backgroundColor = RH_NavigationBar_BackgroundColor;
        oneStepRefreshBtn.layer.borderColor = RH_NavigationBar_BackgroundColor.CGColor;
    }
    
    
    BOOL isAutoPay;
    isAutoPay = YES ;
    if (isAutoPay) {
        self.contentTableView.tableHeaderView = self.tableTopView ;
        self.contentTableView.tableFooterView = nil ;
    }else
    {
        self.contentTableView.tableHeaderView = nil ;
        self.contentTableView.tableFooterView = self.footerView ;
    }
    [self setupPageLoadManager] ;
}

#pragma mark RH_LimitTransferTopView
- (void)RH_LimitTransferTopViewMineWalletDidTaped {
    if (self.selectView.superview == nil) {
        [self showBankPickerSelectView];
    }else {
        [self hideBankPickerSelectView];
    }
}
-(void)showBankPickerSelectView
{
    if (self.selectView.superview){
        [self.selectView removeFromSuperview] ;
    }
    self.selectView.backgroundColor = colorWithRGB(153, 153, 153);
    self.selectView.frame = CGRectMake(0, MainScreenH , MainScreenW, 0) ;
    [self.view addSubview:self.selectView] ;
    [UIView animateWithDuration:0.5f animations:^{
        self.selectView.frame = CGRectMake(0, MainScreenH - BankPickerSelectViewHeight , MainScreenW, BankPickerSelectViewHeight) ;
    } completion:^(BOOL finished) {
    }] ;
}

-(void)hideBankPickerSelectView
{
    if (self.selectView.superview){
        [self.view addSubview:self.selectView] ;
        [UIView animateWithDuration:0.5f animations:^{
            self.selectView.frame = CGRectMake(0, MainScreenH , MainScreenW, 0) ;
        } completion:^(BOOL finished) {
            [self.selectView removeFromSuperview] ;
        }] ;
    }
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
    CGFloat cellHeigh = [RH_LimitTransferCell heightForCellWithInfo:nil tableView:nil context:nil] ;
    return floorf(contentHeigh/cellHeigh) ;

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
        NSLog(@"%@",model) ;
        RH_MineInfoModel *infoModel = model.mUserSetting ;
//        NSArray *userApiModel = [RH_UserApiBalanceModel dataArrayWithInfoArray:infoModel.mApisBalanceList];
        NSArray *userApiModel = infoModel.mApisBalanceList;
        [self loadDataSuccessWithDatas:userApiModel?userApiModel:@[]
                            totalCount:userApiModel?userApiModel.count:0] ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3UserInfo) {
        [self loadDataFailWithError:error] ;
    }
}

#pragma mark-tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX(1, self.pageLoadManager.currentDataCount) ;
//    return 10 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        return [RH_LimitTransferCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
    }else{
        CGFloat height = MainScreenH - tableView.contentInset.top - tableView.contentInset.bottom ;
        return height ;
    }
//    return [RH_LimitTransferCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_LimitTransferCell *limtCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_LimitTransferCell defaultReuseIdentifier]] ;
        [limtCell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]];
        return limtCell ;

    }else{
        return self.loadingIndicateTableViewCell ;
    }
//    RH_LimitTransferCell *limtCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_LimitTransferCell defaultReuseIdentifier]] ;
//    [limtCell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]];
//    return limtCell ;
}

@end
