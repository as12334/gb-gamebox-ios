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
#import "RH_GetNoAutoTransferInfoModel.h"

@interface RH_LimitTransferViewController ()<CLTableViewManagementDelegate, LimitTransferTopViewDelegate, BankPickerSelectViewDelegate,RH_LimitTransferCellDelegate>
@property (nonatomic,strong,readonly) CLTableViewManagement *tableViewManagement;
@property (nonatomic, strong, readonly) UIView  *footerView;
@property (nonatomic, strong) RH_LimitTransferTopView  *tableTopView;
@property (nonatomic, strong, readonly) RH_BankPickerSelectView *selectViewTransferIn;
@property (nonatomic, strong, readonly) RH_BankPickerSelectView *selectViewTransferOut;
@property (nonatomic , strong)RH_GetNoAutoTransferInfoModel *selectInfoModel ;

@end

@implementation RH_LimitTransferViewController
{
    NSString *_selectInText ;
    NSString *_selectInValue ;
    NSString *_selectOutText ;
    NSString *_selectOutValue ;
}
@synthesize tableViewManagement = _tableViewManagement;
@synthesize footerView = _footerView;
@synthesize tableTopView = _tableTopView ;
@synthesize selectViewTransferIn = _selectViewTransferIn;
@synthesize selectViewTransferOut= _selectViewTransferOut;

- (BOOL)isSubViewController {
    return  YES;
}



-(RH_BankPickerSelectView *)selectViewTransferIn
{
    if (_selectViewTransferIn == nil) {
        _selectViewTransferIn = [RH_BankPickerSelectView createInstance] ;
        _selectViewTransferIn.delegate = self ;
        _selectViewTransferIn.tag = 110 ;
    }
    return _selectViewTransferIn ;
}
-(RH_BankPickerSelectView *)selectViewTransferOut
{
    if (_selectViewTransferOut==nil) {
        _selectViewTransferOut = [RH_BankPickerSelectView createInstance] ;
        _selectViewTransferOut.delegate = self ;
        _selectViewTransferOut.tag = 111 ;
    }
    return _selectViewTransferOut ;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"额度转换";
    [self setupInfo];
    self.contentView.backgroundColor = colorWithRGB(239, 239, 239);
    //转出默认值
    _selectOutValue = @"wallet";
    _selectInValue = @"" ;
}

- (void)setupInfo
{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO];
    self.contentTableView.sectionHeaderHeight = 9.0f ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    [self.contentTableView registerCellWithClass:[RH_LimitTransferCell class]] ;
    [self.contentView addSubview:self.contentTableView];
    self.contentTableView.whc_LeftSpace(0).whc_TopSpace(0).whc_RightSpace(0).whc_BottomSpace(0) ;
    self.tableTopView = [[RH_LimitTransferTopView alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, 265)];
    self.tableTopView.delegate = self;
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, 120.f)]  ;
    _footerView.backgroundColor = [UIColor whiteColor] ;
    UIButton *oneStepRecoryBtn  =  [UIButton new] ;  //一键回收
    [_footerView addSubview:oneStepRecoryBtn];
    oneStepRecoryBtn.whc_LeftSpace(10).whc_TopSpace(10).whc_RightSpace(10).whc_Height(40) ;
    [oneStepRecoryBtn setTitle:@"一键回收" forState:UIControlStateNormal];
    [oneStepRecoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    oneStepRecoryBtn.titleLabel.font = [UIFont systemFontOfSize:14.f] ;
    oneStepRecoryBtn.layer.cornerRadius = 5.f ;
    oneStepRecoryBtn.layer.masksToBounds = YES ;
    [oneStepRecoryBtn addTarget:self action:@selector(oneStepRecoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
     UIButton *oneStepRefreshBtn  =  [UIButton new] ;  //一键刷新
    [_footerView addSubview:oneStepRefreshBtn];
    oneStepRefreshBtn.whc_LeftSpace(10).whc_TopSpaceToView(10, oneStepRecoryBtn).whc_RightSpace(10).whc_Height(40) ;
    [oneStepRefreshBtn setTitle:@"一键刷新" forState:UIControlStateNormal];
    [oneStepRefreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    oneStepRefreshBtn.titleLabel.font = [UIFont systemFontOfSize:14.f] ;
    oneStepRefreshBtn.layer.cornerRadius = 5.f ;
    oneStepRefreshBtn.layer.masksToBounds = YES ;
    [oneStepRefreshBtn addTarget:self action:@selector(oneStepRefreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
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
    [self setupPageLoadManager] ;
}

#pragma mark PickerView
- (void)bankPickerSelectViewDidTouchCancelButton:(RH_BankPickerSelectView *)bankPickerSelectView {
    [self hideBankPickerSelectViewWithType:@"transferOut"];
    [self hideBankPickerSelectViewWithType:@"transferIn"];
    
}
- (void)bankPickerSelectViewDidTouchConfirmButton:(RH_BankPickerSelectView *)bankPickerSelectView WithSelectedBank:(id)bankModel {
    if (bankPickerSelectView.tag == 110) {
        _selectOutText =  ((SelectModel *)bankModel).mText ;
        _selectOutValue =  ((SelectModel *)bankModel).mValue ;
        [self.tableTopView updataBTnTitletransferOutBtnTitle:_selectOutText];
        [self.contentTableView reloadData] ;
        
        if ([_selectOutValue isEqualToString:@"wallet"]) {
            if ([_selectInValue isEqualToString:@"wallet"]) {
                _selectInValue = @"";
                _selectInText = @"请选择";
                [self.tableTopView updataBTnTitleTransferInBtnTitle:_selectInText] ;
            }
        }else if (![_selectOutValue isEqualToString:@"wallet"])
        {
            if (![_selectInValue isEqualToString:@"wallet"]) {
                _selectInValue = @"wallet";
                _selectInText = @"我的钱包";
                [self.tableTopView updataBTnTitleTransferInBtnTitle:_selectInText] ;
            }
        }
    }else if (bankPickerSelectView.tag == 111){
        _selectInText =  ((SelectModel *)bankModel).mText ;
        _selectInValue = ((SelectModel *)bankModel).mValue  ;
        [self.tableTopView updataBTnTitleTransferInBtnTitle:_selectInText] ;
        [self.contentTableView reloadData] ;
        if ([_selectInValue isEqualToString:@"wallet"]) {
            if ([_selectOutValue isEqualToString:@"wallet"]) {
                _selectOutValue = @"";
                _selectOutText = @"请选择";
                [self.tableTopView updataBTnTitletransferOutBtnTitle:_selectOutText];
            }
        }else if (![_selectInValue isEqualToString:@"wallet"])
        {
            if (![_selectOutValue isEqualToString:@"wallet"]) {
                _selectOutValue = @"wallet";
                _selectOutText = @"我的钱包";
                [self.tableTopView updataBTnTitletransferOutBtnTitle:_selectOutText];
            }
        }
    }
    [self hideBankPickerSelectViewWithType:@"transferOut"];
    [self hideBankPickerSelectViewWithType:@"transferIn"];
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
            backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor ;
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

#pragma mark RH_LimitTransferTopView
- (void)limitTransferTopViewDidTouchTransferInBtn:(UIButton *)sender withView:(RH_LimitTransferTopView *)topView {
    if (self.selectViewTransferIn.superview == nil) {
        [self hideBankPickerSelectViewWithType:@"transferOut"];
        [self showBankPickerSelectViewWithType:@"transferIn"];
    }else {
        [self hideBankPickerSelectViewWithType:@"transferIn"];
    }
}
- (void)limitTransferTopViewDidTouchTransferOutBtn:(UIButton *)sender withView:(RH_LimitTransferTopView *)topView {
    if (self.selectViewTransferOut.superview == nil) {
        [self hideBankPickerSelectViewWithType:@"transferIn"];
        [self showBankPickerSelectViewWithType:@"transferOut"];
    }else {
        [self hideBankPickerSelectViewWithType:@"transferOut"];
    }
}

#pragma mark - topView 余额刷新 = 一键刷新
-(void)limitTransferTopViewDidTouchRefreshBalanceBtn
{
    // 请求一键刷新余额
}

-(void)showBankPickerSelectViewWithType:(NSString *)type
{
    if ([type isEqualToString:@"transferIn"]) {
        if (self.selectViewTransferIn.superview){
            [self.selectViewTransferIn removeFromSuperview] ;
        }
        self.selectViewTransferIn.backgroundColor = colorWithRGB(153, 153, 153);
        self.selectViewTransferIn.frame = CGRectMake(0, MainScreenH , MainScreenW, 0) ;
        [self.view addSubview:self.selectViewTransferIn] ;
        [_selectViewTransferIn setDatasourceList:_selectInfoModel.selectModel] ;
        [UIView animateWithDuration:0.5f animations:^{
            self.selectViewTransferIn.frame = CGRectMake(0, MainScreenH - BankPickerSelectViewHeight , MainScreenW, BankPickerSelectViewHeight) ;
        } completion:^(BOOL finished) {
        }] ;
    }else if ([type isEqualToString:@"transferOut"]){
        if (self.selectViewTransferOut.superview){
            [self.selectViewTransferOut removeFromSuperview] ;
        }
        self.selectViewTransferOut.backgroundColor = colorWithRGB(153, 153, 153);
        self.selectViewTransferOut.frame = CGRectMake(0, MainScreenH , MainScreenW, 0) ;
        [self.view addSubview:self.selectViewTransferOut] ;
        [_selectViewTransferOut setDatasourceList:_selectInfoModel.selectModel] ;
        [UIView animateWithDuration:0.5f animations:^{
            self.selectViewTransferOut.frame = CGRectMake(0, MainScreenH - BankPickerSelectViewHeight , MainScreenW, BankPickerSelectViewHeight) ;
        } completion:^(BOOL finished) {
        }] ;
    }
}

-(void)hideBankPickerSelectViewWithType:(NSString *)type
{
    if (self.selectViewTransferIn.superview){
        [self.view addSubview:self.selectViewTransferIn] ;
        [UIView animateWithDuration:0.5f animations:^{
            self.selectViewTransferIn.frame = CGRectMake(0, MainScreenH , MainScreenW, 0) ;
        } completion:^(BOOL finished) {
            [self.selectViewTransferIn removeFromSuperview] ;
        }] ;
    }else if (self.selectViewTransferOut.superview)
    {
        [self.view addSubview:self.selectViewTransferOut] ;
        [UIView animateWithDuration:0.5f animations:^{
            self.selectViewTransferOut.frame = CGRectMake(0, MainScreenH , MainScreenW, 0) ;
        } completion:^(BOOL finished) {
            [self.selectViewTransferOut removeFromSuperview] ;
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
    [self.serviceRequest startV3GetNoAutoTransferInfoInit] ;
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
        [self loadDataSuccessWithDatas:userApiModel?userApiModel:@[]
                            totalCount:userApiModel?userApiModel.count:0] ;
        if (!infoModel.mIsAutoPay) {
            self.contentTableView.tableHeaderView = self.tableTopView ;
            self.contentTableView.tableFooterView = nil ;
        }else
        {
            self.contentTableView.tableHeaderView = nil ;
            self.contentTableView.tableFooterView = self.footerView ;
        }
    }else if (type == ServiceRequestTypeV3OneStepRecory){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showSuccessMessage(self.view, @"提示信息", @"资金回收成功") ;
            [self.serviceRequest startV3GetUserAssertInfo] ;
        }] ;
    }else if (type == ServiceRequestTypeV3RefreshApi){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showSuccessMessage(self.view, @"提示信息", @"资金刷新成功") ;
            [self.serviceRequest startV3GetUserAssertInfo] ;
        }] ;
    }else if (type == ServiceRequestTypeV3GetNoAutoTransferInfo)
    {
        //额度转换初始化
        _selectInfoModel = ConvertToClassPointer(RH_GetNoAutoTransferInfoModel, data) ;
        [self.tableTopView topViewUpdataTopDateWithModel:_selectInfoModel];
    }else if (type == ServiceRequestTypeV3SubmitTransfersMoney){
        // 额度转换提交
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showSuccessMessage(self.view, @"提示信息", @"资金刷新成功") ;
            [self.serviceRequest startV3GetUserAssertInfo] ;
        }] ;
    }
     [self.contentTableView reloadData] ;
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3UserInfo) {
        [self loadDataFailWithError:error] ;
    }else if (type == ServiceRequestTypeV3OneStepRecory){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showErrorMessage(nil, error, @"资金回收失败") ;
        }] ;
    }else if (type == ServiceRequestTypeV3RefreshApi){
       showErrorMessage(nil, error, @"资金刷新失败") ;
    }else if (type == ServiceRequestTypeV3GetNoAutoTransferInfo)
    {
        //额度转换初始化
        [self loadDataFailWithError:error] ;
    }else if (type == ServiceRequestTypeV3SubmitTransfersMoney){
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
        return [RH_LimitTransferCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
    }else{
        CGFloat height = MainScreenH - tableView.contentInset.top - tableView.contentInset.bottom ;
        return height ;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_LimitTransferCell *limtCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_LimitTransferCell defaultReuseIdentifier]] ;
        [limtCell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]];
        limtCell.delegate = self ;
        return limtCell ;
    }else{
        return self.loadingIndicateTableViewCell ;
    }
}

#pragma mark - RH_LimitTransferCellDelegate 单个回收 && 单个刷新
-(void)limitTransferCelRecoryAndRefreshBtnDidTouch:(RH_LimitTransferCell *)limitTransferCell withBtn:(UIButton *)sender withModel:(RH_UserApiBalanceModel *)model
{
    if ([sender.titleLabel.text isEqualToString:@"回收"]) {
        //单个回收
        if (model.mBalance == 0 ) {
            showMessage(self.view, nil, @"当前余额为0不能回收") ;
            return ;
        }
        [self showProgressIndicatorViewWithAnimated:NO title:@"回收中..."] ;
        [self.serviceRequest startV3OneStepRecoverySearchId:[NSString stringWithFormat:@"%ld",model.mApiID]] ;
    }else
    {
        // 单个刷新
        [self showProgressIndicatorViewWithAnimated:NO title:@"刷新中..."] ;
        [self.serviceRequest startV3RefreshApiWithApiId:model.mApiID] ;
        
    }
}
#pragma mark - 一键回收
-(void)oneStepRecoryBtnClick
{
    [self showProgressIndicatorViewWithAnimated:NO title:@"一键回收中..."] ;
    [self.serviceRequest startV3OneStepRecoverySearchId:nil] ;
}

#pragma mark - 一键刷新
-(void)oneStepRefreshBtnClick
{
    
}

#pragma mark - 确认提交
-(void)limitTransferTopViewDidTouchSureSubmitBtnWithamount:(NSString *)amount
{
    if ([_selectOutValue isEqualToString:@""]) {
        showMessage(self.view, nil, @"请选择转出游戏名称") ;
        return ;
    }
    if ([_selectInValue isEqualToString:@""]) {
        showMessage(self.view, nil, @"请选择转入游戏名称") ;
        return ;
    }
    if (amount.length==0) {
        showMessage(self.view, nil, @"请输入转账金额") ;
        return ;
    }
    [self showProgressIndicatorViewWithAnimated:NO title:@"提交中..."] ;
    [self.serviceRequest startV3SubitTransfersMoneyToken:_selectInfoModel.mToken transferOut:_selectOutValue transferInto:_selectInValue transferAmount:[amount floatValue]];
}



#pragma mark -
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return [_selectViewTransferIn superview] || [_selectViewTransferOut superview];
}

- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (_selectViewTransferIn.superview || _selectViewTransferOut.superview){
        [self hideBankPickerSelectViewWithType:@"transferOut"] ;
        [self hideBankPickerSelectViewWithType:@"transferIn"] ;
    }
}

@end
