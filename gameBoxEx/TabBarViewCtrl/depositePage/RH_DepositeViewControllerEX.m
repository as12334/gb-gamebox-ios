//
//  RH_DepositeViewControllerEX.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/21.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeViewControllerEX.h"
#import "RH_LoginViewControllerEx.h"
#import "RH_DepositePayforWayCell.h"
#import "RH_DepositeChooseMoneyCell.h"
#import "RH_DepositeMoneyNumberCell.h"
#import "RH_DepositeReminderCell.h"
#import "RH_DepositeSubmitCircleView.h"
#import "RH_DepositeMoneyBankCell.h"
#import "RH_DepositeSystemPlatformCell.h"
#import "RH_DepositeTransferBankcardController.h"
#import "RH_DepositeTransferModel.h"
#import "RH_DepositOriginseachSaleModel.h"
@interface RH_DepositeViewControllerEX ()<LoginViewControllerExDelegate,DepositeReminderCellCustomDelegate,DepositePayforWayCellDelegate,DepositeSystemPlatformCellDelegate,RH_ServiceRequestDelegate,DepositeSubmitCircleViewDelegate>
@property(nonatomic,strong,readonly)RH_DepositeSubmitCircleView *circleView;
@property(nonatomic,strong)UIView *shadeView;
@property(nonatomic,strong)NSArray *markArray;
@property(nonatomic,strong)RH_DepositeTransferModel *transferModel;
@property(nonatomic,strong)RH_DepositeSystemPlatformCell *platformCell;
@property(nonatomic,strong)RH_DepositeMoneyNumberCell *numberCell;
@property(nonatomic,strong)RH_DepositePayAccountModel *payAccountModel;
@property(nonatomic,strong)NSArray *accountModelArray;
@property(nonatomic,strong)UIView *backDropView;
@property(nonatomic,strong)NSString *payNumStr;
@property(nonatomic,strong)RH_DepositOriginseachSaleModel *saleModel;
//支付方式类型
@property(nonatomic,strong)NSString *payforType;
//优惠ID
@property(nonatomic,assign)NSInteger activityId;
@end

@implementation RH_DepositeViewControllerEX
{
    NSInteger _selectNumber;
}
@synthesize circleView = _circleView;
-(BOOL)tabBarHidden
{
    return NO ;
}
-(BOOL)needLogin
{
    return YES  ;
}
-(BOOL)hasBottomView
{
    return YES;
}
-(CGFloat)bottomViewHeight
{
    return 40.f;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    if ([self needLogin]){
        //check whether login
        if (!self.appDelegate.isLogin){
            if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
                //push login viewController
                RH_LoginViewControllerEx *loginViewCtrlEx = [RH_LoginViewControllerEx viewControllerWithContext:@(YES)];
                loginViewCtrlEx.delegate = self ;
                [self presentViewController:loginViewCtrlEx animated:YES completion:nil] ;
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //增加login status changed notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:NT_LoginStatusChangedNotification object:nil] ;
    self.title = @"存款";
    _markArray = @[@0,@1,@2,@3,@4,@5];
    [self setNeedUpdateView];
    [self setupUI];
    // 键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    // 键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:UIKeyboardWillHideNotification object:nil];
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

#pragma mark --检测是否登录
-(void)handleNotification:(NSNotification*)nt
{
    if ([nt.name isEqualToString:NT_LoginStatusChangedNotification]){
        [self setNeedUpdateView] ;
    }
}
-(void)updateView
{
    if (self.appDelegate.isLogin&&NetworkAvailable()){
//        [self.serviceRequest startV3RequestDepositOrigin];
        [self setupPageLoadManager] ;
    }
    else if(!self.appDelegate.isLogin){
        //进入登录界面
//        [self loginButtonItemHandle] ;
    }
    else if (NetNotReachability()){
        showAlertView(@"无网络", @"") ;
    }
}
-(void)loginViewViewControllerExTouchBack:(RH_LoginViewControllerEx *)loginViewContrller BackToFirstPage:(BOOL)bFirstPage
{
    if (loginViewContrller.presentingViewController){
        [loginViewContrller dismissViewControllerAnimated:YES completion:nil] ;
    }else{
        [self.navigationController popViewControllerAnimated:YES] ;
    }
    
    if (bFirstPage){
        if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
            [self.navigationController popToRootViewControllerAnimated:NO];
            self.myTabBarController.selectedIndex = 2 ;
        }else{
            self.myTabBarController.selectedIndex = 0 ;
        }
    }
}

-(void)loginViewViewControllerExLoginSuccessful:(RH_LoginViewControllerEx *)loginViewContrller
{
    if (loginViewContrller.presentingViewController){
        [loginViewContrller dismissViewControllerAnimated:YES completion:nil] ;
    }else{
        [self.navigationController popViewControllerAnimated:YES] ;
    }
    
}

-(void)loginViewViewControllerExSignSuccessful:(RH_LoginViewControllerEx *)loginViewContrller SignFlag:(BOOL)bFlag
{
    if (loginViewContrller.presentingViewController){
        [loginViewContrller dismissViewControllerAnimated:YES completion:nil] ;
    }else{
        [self.navigationController popViewControllerAnimated:YES] ;
    }

    if (bFlag==false){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *account = [defaults stringForKey:@"account"] ;
        NSString *password = [defaults stringForKey:@"password"] ;
        
        if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
            [self.serviceRequest startAutoLoginWithUserName:account Password:password] ;
        }else{
            [self.serviceRequest startLoginWithUserName:account Password:password VerifyCode:nil] ;
        }
    }
}
#pragma mark --视图
-(void)setupUI{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self   ;
    self.contentTableView.dataSource = self ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    self.contentTableView.sectionHeaderHeight = 0.0f ;
    [self.contentTableView registerCellWithClass:[RH_DepositePayforWayCell class]] ;
    [self.contentTableView registerCellWithClass:[RH_DepositeChooseMoneyCell class]];
    [self.contentTableView registerCellWithClass:[RH_DepositeMoneyNumberCell class]];
    [self.contentTableView registerCellWithClass:[RH_DepositeReminderCell class]];
    [self.contentTableView registerCellWithClass:[RH_DepositeMoneyBankCell class]];
    [self.contentTableView registerCellWithClass:[RH_DepositeSystemPlatformCell class]];
    [self.contentView addSubview:self.contentTableView] ;
    
    //提交按钮
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(0, 0, self.contentView.frameWidth, 40);
    submitBtn.backgroundColor = [UIColor blueColor];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitDepositeInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:submitBtn];
}
#pragma mark --点击提交按钮弹框
-(RH_DepositeSubmitCircleView *)circleView
{
    if (!_circleView) {
        _circleView = [RH_DepositeSubmitCircleView createInstance];
        _circleView.frame = CGRectMake(0, 0, 250, 360);
        _circleView.center = self.view.center;
        _circleView.delegate = self;
    }
    return _circleView;
}

#pragma mark-tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return  5 ;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item==[_markArray[0] integerValue]) {
        return [RH_DepositePayforWayCell heightForCellWithInfo:nil tableView:tableView context:self.transferModel] ;
    }
    else if (indexPath.item==[_markArray[1] integerValue]){
        return 120.f;
    }
    else if (indexPath.item==[_markArray[2] integerValue]){
        return 44.f;
    }
    else if (indexPath.item==[_markArray[3] integerValue]){
        return 44.f;
    }
    else if (indexPath.item ==[_markArray[4] integerValue]){
        return 200.f;
    }
    else if (indexPath.item ==[_markArray[5] integerValue]){
        return [RH_DepositeSystemPlatformCell heightForCellWithInfo:nil tableView:tableView context:self.transferModel.mPayModel[_selectNumber]];
    }
    return 0.0f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (self.pageLoadManager.currentDataCount) {
        RH_DepositeTransferModel *transferModel = ConvertToClassPointer(RH_DepositeTransferModel, [self.pageLoadManager dataAtIndex:0]);
        if (indexPath.item==[_markArray[0]integerValue]) {
            RH_DepositePayforWayCell *payforWayCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositePayforWayCell defaultReuseIdentifier]] ;
            payforWayCell.delegate = self;
            [payforWayCell updateCellWithInfo:nil context:transferModel.mPayModel];
            return payforWayCell ;
        }
        else if (indexPath.item == [_markArray[1]integerValue]){
            RH_DepositeChooseMoneyCell *moneyCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeChooseMoneyCell defaultReuseIdentifier]] ;
            [moneyCell updateCellWithInfo:nil context:transferModel.mPaydataModel];
            return moneyCell ;
        }
        else if (indexPath.item == [_markArray[2]integerValue]){
            RH_DepositeMoneyNumberCell *numberCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeMoneyNumberCell defaultReuseIdentifier]] ;
//            [numberCell updateCellWithInfo:nil context:transferModel.mPayModel[indexPath.item]];
            self.numberCell = numberCell;
            
            return numberCell ;
        }
        else if (indexPath.item == [_markArray[3]integerValue]){
            RH_DepositeMoneyBankCell *bankCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeMoneyBankCell defaultReuseIdentifier]] ;
            return bankCell ;
        }
        else if (indexPath.item == [_markArray[4]integerValue]){
            RH_DepositeReminderCell *reminderCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeReminderCell defaultReuseIdentifier]] ;
            reminderCell.delegate = self;
            return reminderCell ;
        }
        else if (indexPath.item==[_markArray[5]integerValue]){
            RH_DepositeSystemPlatformCell *platformCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeSystemPlatformCell defaultReuseIdentifier]] ;
            platformCell.delegate=self;
            _platformCell = platformCell;
            [platformCell updateCellWithInfo:nil context:transferModel.mPayModel[_selectNumber]];
            return platformCell ;
        }
    }
    else{
        return self.loadingIndicateTableViewCell ;
    }
    
    return nil;
}
#pragma mark --depositePayforWay的代理，选择付款的平台
-(void)depositePayforWayDidtouchItemCell:(RH_DepositePayforWayCell *)payforItem itemIndex:(NSInteger)itemIndex
{
    [self.platformCell updateConllectionView];
    _selectNumber = itemIndex;
    if ([self.transferModel.mPayModel[itemIndex].mCode isEqualToString:@"online"]) {
        _markArray = @[@0,@1,@2,@3,@4,@5];
    }
    else {
        _markArray = @[@0,@2,@3,@5,@4,@1];
    }
    [self.contentTableView reloadData];
    
}
#pragma mark --depositeReminder的代理,跳转到客服
-(void)touchTextViewCustomPushCustomViewController:(RH_DepositeReminderCell *)cell
{
    [self.tabBarController setSelectedIndex:3];
}
#pragma mark --RH_DepositeSystemPlatformCell的代理，选择不同的平台进行跳转
-(void)depositeSystemPlatformCellDidtouch:(RH_DepositeSystemPlatformCell *)cell codeString:(NSString *)codeStr accountModel:(id)accountModel
{
    NSArray *array = @[codeStr,accountModel];
    self.accountModelArray = array;
    [self.numberCell updateCellWithInfo:nil context:accountModel];
    //判断选择的支付方式的type，来确定是否跳转
    RH_DepositePayAccountModel *payAccountModel = ConvertToClassPointer(RH_DepositePayAccountModel, accountModel);
    self.payforType = payAccountModel.mType;
    self.payAccountModel = payAccountModel;
    [self.contentTableView reloadData];
}
#pragma mark --点击提交按钮
-(void)submitDepositeInfo
{

    //线上支付特殊，没有第二级菜单选择TYPE，只有在一级判断出“线上支付”,拿到type和ID
    if ([self.transferModel.mPayModel[_selectNumber].mCode isEqualToString:@"online"]) {
       
        NSArray *array = (NSArray *)(((RH_DepositePayModel *)self.transferModel.mPayModel[_selectNumber]).mPayAccounts);
//  [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:[self.payNumStr floatValue] PayAccountDepositWay:payAccount.mDepositWay PayAccountID:payAccount.mId];
    }
    else{
        if ([self.payforType isEqualToString:@"1"]) {
            NSMutableArray *mutableArray = [NSMutableArray array];
            [mutableArray addObject:self.accountModelArray];
            [mutableArray addObject:self.payNumStr];
            RH_DepositeTransferBankcardController *transferVC = [RH_DepositeTransferBankcardController viewControllerWithContext:mutableArray];
            [self showViewController:transferVC sender:self];
        }
        else{
          [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:[self.payNumStr floatValue] PayAccountDepositWay:self.payAccountModel.mDepositWay PayAccountID:self.payAccountModel.mId];
        }
    }

}
#pragma mark --点击遮罩层，关闭遮罩层和弹框
-(void)closeShadeView
{
    [_shadeView removeFromSuperview];
    [self.circleView removeFromSuperview];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}
#pragma mark -- 点击弹框里面的提交按钮
-(void)depositeSubmitCircleViewTransferMoney:(RH_DepositeSubmitCircleView *)circleView
{
    //线上支付特殊，没有第二级菜单选择TYPE，只有在一级判断出“线上支付”,拿到type和ID
    if ([self.transferModel.mPayModel[_selectNumber].mCode isEqualToString:@"online"]) {
        
//        NSArray *array = ConvertToClassPointer(NSArray, pModel.mPayAccounts);
//       RH_DepositePayAccountModel *aModel= ConvertToClassPointer(RH_DepositePayAccountModel,array[0]);
//        [self.serviceRequest startV3OnlinePayWithRechargeAmount:[self.payNumStr floatValue] rechargeType:aModel.mRechargeType payAccountId:aModel.mAccount activityId:self.activityId];
    }
}
#pragma mark -- 优惠列表
-(void)depositeSubmitCircleViewChooseDiscount:(NSInteger)activityId
{
    self.activityId = activityId;
}
#pragma mark 数据请求

#pragma mark - serviceRequest
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
                                        detailText:@"您暂无相关数据记录"] ;
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
    [self.serviceRequest startV3RequestDepositOrigin];
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
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data {
    
    if (type == ServiceRequestTypeV3DepositeOrigin) {
        RH_DepositeTransferModel *transferModel = ConvertToClassPointer(RH_DepositeTransferModel, data);
        self.transferModel = transferModel;
        [self loadDataSuccessWithDatas:transferModel?@[transferModel]:@[]
                            totalCount:transferModel?1:0] ;
        for (RH_DepositePayModel *payModel in self.transferModel.mPayModel) {
            if ([payModel.mCode isEqualToString:@"online"]) {
                _markArray = @[@0,@1,@2,@3,@4,@5];
            }
            else {
                _markArray = @[@0,@2,@3,@5,@4,@1];
            }
        }
        
        [self.contentTableView reloadData];
    }
    else if (type == ServiceRequestTypeV3DepositOriginSeachSale){
        RH_DepositOriginseachSaleModel *saleModel = ConvertToClassPointer(RH_DepositOriginseachSaleModel, data);
        self.saleModel = saleModel;
        [self loadDataSuccessWithDatas:saleModel?@[saleModel]:@[]
                            totalCount:saleModel?1:0] ;
        //遮罩层
        UIView *shadeView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
        shadeView.backgroundColor = [UIColor lightGrayColor];
        shadeView.alpha = 0.7f;
        shadeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeShadeView)];
        [shadeView addGestureRecognizer:tap];
        [[UIApplication sharedApplication].keyWindow addSubview:shadeView];
        _shadeView = shadeView;
        [self.circleView setupViewWithContext:self.saleModel];
        [[UIApplication sharedApplication].keyWindow addSubview:self.circleView];
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    if (type == ServiceRequestTypeV3DepositeOrigin) {
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }
    else if (type == ServiceRequestTypeV3DepositOriginSeachSale){
        
    }
}
#pragma mark -键盘监听方法
- (void)keyboardWasShown:(NSNotification *)notification
{
    // 获取键盘的高度
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = frame.size.height;
    UIView *backDropView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frameHeigh-height, self.view.frameWidth, 40)];
    backDropView.backgroundColor = [UIColor lightGrayColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor greenColor]];
    [btn addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(self.view.frameWidth-40, 0, 40, 40);
    [backDropView addSubview:btn];
    backDropView.userInteractionEnabled = YES;
    self.backDropView = backDropView;
    [self.view addSubview:backDropView];
}
-(void)hideKeyboard{
    [self.numberCell.payMoneyNumLabel resignFirstResponder];
    [self.backDropView removeFromSuperview];
    self.payNumStr = self.numberCell.payMoneyNumLabel.text;
}
- (void)keyboardWillBeHiden:(NSNotification *)notification
{
//    self.textFiledScrollView.frame = CGRectMake(0, 64, kViewWidth, 455.5);
    
}


@end
