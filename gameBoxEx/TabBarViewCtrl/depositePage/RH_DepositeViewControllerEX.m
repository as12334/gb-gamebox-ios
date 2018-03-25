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
@interface RH_DepositeViewControllerEX ()<LoginViewControllerExDelegate,DepositeReminderCellCustomDelegate,DepositePayforWayCellDelegate,DepositeSystemPlatformCellDelegate,RH_ServiceRequestDelegate>
@property(nonatomic,strong,readonly)RH_DepositeSubmitCircleView *circleView;
@property(nonatomic,strong)UIView *shadeView;
@property(nonatomic,strong)NSArray *markArray;
@end

@implementation RH_DepositeViewControllerEX
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
        [self.serviceRequest startV3RequestDepositOrigin];
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
        return 90.0f ;
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
        return 130.f;
    }
    return 0.0f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item==[_markArray[0]integerValue]) {
        RH_DepositePayforWayCell *payforWayCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositePayforWayCell defaultReuseIdentifier]] ;
        payforWayCell.delegate = self;
        return payforWayCell ;
    }
    else if (indexPath.item == [_markArray[1]integerValue]){
        RH_DepositeChooseMoneyCell *moneyCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeChooseMoneyCell defaultReuseIdentifier]] ;
        
        return moneyCell ;
    }
    else if (indexPath.item == [_markArray[2]integerValue]){
        RH_DepositeMoneyNumberCell *numberCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeMoneyNumberCell defaultReuseIdentifier]] ;
        
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
        return platformCell ;
    }
    return nil;
}
#pragma mark --depositePayforWay的代理，选择付款的平台
-(void)depositePayforWayDidtouchItemCell:(RH_DepositePayforWayCell *)payforItem itemIndex:(NSInteger)itemIndex
{
    if (itemIndex==0) {
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
-(void)depositeSystemPlatformCellDidtouch:(RH_DepositeSystemPlatformCell *)cell indexCellItem:(NSInteger)index
{
    RH_DepositeTransferBankcardController *transferVC = [RH_DepositeTransferBankcardController viewControllerWithContext:@(index)];
    [self showViewController:transferVC sender:self];
}
#pragma mark --点击提交按钮
-(void)submitDepositeInfo
{
    //遮罩层
    UIView *shadeView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    shadeView.backgroundColor = [UIColor lightGrayColor];
    shadeView.alpha = 0.7f;
    shadeView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeShadeView)];
    [shadeView addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview:shadeView];
    _shadeView = shadeView;
    [[UIApplication sharedApplication].keyWindow addSubview:self.circleView];
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
#pragma mark 数据请求

#pragma mark - serviceRequest

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data {
    
    if (type == ServiceRequestTypeV3DepositeOrigin) {
     
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    if (type == ServiceRequestTypeV3DepositeOrigin) {
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }
}

@end
