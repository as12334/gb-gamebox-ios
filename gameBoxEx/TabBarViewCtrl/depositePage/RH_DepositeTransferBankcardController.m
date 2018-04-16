//
//  RH_DepositeTransferBankcardController.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeTransferBankcardController.h"
#import "RH_DepositeSubmitCircleView.h"
#import "RH_DepositeTransferBankInfoCell.h"
#import "RH_DepositeTransferPayWayCell.h"
#import "RH_DepositeTransferReminderCell.h"
#import "RH_DepositeTransferQRCodeCell.h"
#import "RH_DepositeTransferWXinInfoCell.h"
#import "RH_DepositeTransferChannelModel.h"
#import "RH_DepositeTransferOrderNumCell.h"
#import "RH_DepositeTransferPayAdressCell.h"
#import "RH_API.h"
#import "coreLib.h"
#import "RH_DepositOriginseachSaleModel.h"
#import "RH_DepositeTransferButtonCell.h"
#import "RH_DepositeTransferPulldownView.h"
#import "RH_DepositSuccessAlertView.h" //存款成功的弹窗
#import "RH_CapitalRecordViewController.h" //资金记录
#import "RH_CustomServiceSubViewController.h"
@interface RH_DepositeTransferBankcardController ()<DepositeTransferReminderCellDelegate,RH_ServiceRequestDelegate,DepositeTransferButtonCellDelegate,DepositeSubmitCircleViewDelegate,DepositeTransferPayWayCellDelegate,DepositeTransferOrderNumCellDelegate,DepositeTransferPayAdressCellDelegate,DepositeTransferQRCodeCellDelegate,DepositSuccessAlertViewDelegate,DepositeTransferPulldownViewDelegate>
@property(nonatomic,strong,readonly)RH_DepositeSubmitCircleView *circleView;
@property(nonatomic,strong)UIView *shadeView;
@property(nonatomic,strong)NSArray *markArray;
@property(nonatomic,assign)NSInteger indexMark;
@property(nonatomic,strong)NSArray *transferwayArray;
@property(nonatomic,strong)RH_DepositeTransferListModel *listModel;
@property(nonatomic,strong)NSMutableArray *accountMuArray;
@property(nonatomic,strong)RH_DepositOriginseachSaleModel *saleModel;
@property(nonatomic,assign)NSInteger activityId;
@property(nonatomic,strong)RH_DepositeTransferOrderNumCell *transferOrderCell ;
@property(nonatomic,strong)RH_DepositeTransferPayAdressCell *adressCell;
@property(nonatomic,strong)RH_DepositeTransferPayWayCell *paywayCell;
@property(nonatomic,strong,readonly)RH_DepositeTransferPulldownView *pulldownView;
@property(nonatomic,strong)RH_DepositSuccessAlertView *successAlertView ;
@property(nonatomic,strong,readonly)UIButton *closeBtn;
//柜台机单独传type
@property(nonatomic,strong)NSString *counterStr;
@end

@implementation RH_DepositeTransferBankcardController
@synthesize circleView = _circleView;
@synthesize pulldownView = _pulldownView;
@synthesize closeBtn = _closeBtn;

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
            }else if ([THEMEV3 isEqualToString:@"blue"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Blue ;
            }else if ([THEMEV3 isEqualToString:@"orange"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange ;
            }else if ([THEMEV3 isEqualToString:@"red_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red_White ;
            }else if ([THEMEV3 isEqualToString:@"green_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green_White ;
            }else if ([THEMEV3 isEqualToString:@"orange_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_Black ;
            }else{
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor ;
            }
        }else
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
            [navigationBar insertSubview:backgroundView atIndex:0] ;
            if ([THEMEV3 isEqualToString:@"green"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Green ;
            }else if ([THEMEV3 isEqualToString:@"red"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Red ;
            }else if ([THEMEV3 isEqualToString:@"black"]){
                backgroundView.backgroundColor = ColorWithNumberRGB(0x1766bb) ;
            }else if ([THEMEV3 isEqualToString:@"blue"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Blue ;
            }else if ([THEMEV3 isEqualToString:@"orange"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Orange ;
            }else if ([THEMEV3 isEqualToString:@"red_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red_White ;
            }else if ([THEMEV3 isEqualToString:@"green_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green_White ;
            }else if ([THEMEV3 isEqualToString:@"orange_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_Black ;
            }else{
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor ;
            }
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
-(BOOL)isSubViewController
{
    return YES;
}
-(BOOL)hasBottomView
{
    return YES;
}
-(CGFloat)bottomViewHeight
{
    return 40.f;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated] ;
    [self.successAlertView removeFromSuperview] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"银行卡转账";
    [self setupUI];
}
-(RH_DepositeTransferPulldownView *)pulldownView
{
    if (!_pulldownView) {
        _pulldownView = [RH_DepositeTransferPulldownView createInstance];
        if ([self.accountMuArray[2] isEqualToString:@"counter"]) {
            [_pulldownView setupViewWithContext:self.accountMuArray[3]];
        }
        _pulldownView.delegate = self;
    }
    return _pulldownView;
}
#pragma mark --获取点击的具体的item
-(void)setupViewContext:(id)context
{
    self.accountMuArray = [NSMutableArray array];
    self.accountMuArray = ConvertToClassPointer(NSMutableArray, context);
    RH_DepositeTransferListModel *listModel = ConvertToClassPointer(RH_DepositeTransferListModel, self.accountMuArray[1]);
    self.listModel = listModel;
    if ([self.accountMuArray[2] isEqualToString:@"company"]) {
        _markArray =@[@0,@7,@6,@1,@2,@5,@3,@4];
        self.title = @"网银付款";
    }
    else if ([self.accountMuArray[2] isEqualToString:@"wechat"]){
        _markArray =@[@7,@0,@1,@2,@3,@6,@4,@5];
        self.title = @"微信付款";
    }
    else if ([self.accountMuArray[2] isEqualToString:@"alipay"])
    {
        _markArray =@[@7,@0,@1,@2,@3,@4,@5,@6];
        self.title = @"支付宝付款";
    }
    else if ([self.accountMuArray[2] isEqualToString:@"qq"])
    {
        _markArray =@[@7,@0,@1,@2,@3,@6,@4,@5];
        self.title = @"QQ钱包付款";
    }
    else if ([self.accountMuArray[2] isEqualToString:@"jd"])
    {
        _markArray =@[@7,@0,@1,@2,@3,@6,@4,@5];
        self.title = @"京东钱包付款";
    }
    else if ([self.accountMuArray[2] isEqualToString:@"bd"])
    {
        _markArray =@[@7,@0,@1,@2,@3,@6,@4,@5];
        self.title = @"百度钱包付款";
    }
    else if ([self.accountMuArray[2] isEqualToString:@"onecodepay"]){
        _markArray =@[@7,@0,@1,@2,@5,@6,@3,@4];
        self.title = @"一码付";
    }
    else if ([self.accountMuArray[2] isEqualToString:@"counter"]){
        _markArray =@[@0,@7,@6,@1,@2,@3,@4,@5];
        self.title = @"柜台机付款";
        self.counterStr = ((RH_DepositeTansferCounterModel*)(self.accountMuArray[3][0])).mCode;
    }
    else if ([self.accountMuArray[2] isEqualToString:@"other"])
    {
        _markArray = @[@7,@0,@1,@2,@3,@6,@4,@5];
        self.title = @"其他付款付款";
    }
    else{
       _markArray =@[@0,@1,@2,@3,@4,@5];
    }
}
#pragma mark --视图
-(void)setupUI{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self   ;
    self.contentTableView.dataSource = self ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    self.contentTableView.sectionHeaderHeight = 0.0f ;
    self.contentTableView.separatorStyle = UITableViewRowActionStyleDefault;
    [self.contentView addSubview:self.contentTableView] ;
    [self.contentTableView registerCellWithClass:[RH_DepositeTransferBankInfoCell class]] ;
    [self.contentTableView registerCellWithClass:[RH_DepositeTransferPayWayCell class]] ;
    [self.contentTableView registerCellWithClass:[RH_DepositeTransferReminderCell class]] ;
    [self.contentTableView registerCellWithClass:[RH_DepositeTransferQRCodeCell class]];
    [self.contentTableView registerCellWithClass:[RH_DepositeTransferWXinInfoCell class]];
    [self.contentTableView registerCellWithClass:[RH_DepositeTransferOrderNumCell class]];
    [self.contentTableView registerCellWithClass:[RH_DepositeTransferPayAdressCell class]];
    [self.contentTableView registerCellWithClass:[RH_DepositeTransferButtonCell class]];
}
#pragma mark --点击提交按钮弹框
-(RH_DepositeSubmitCircleView *)circleView
{
    if (!_circleView) {
        _circleView = [RH_DepositeSubmitCircleView createInstance];
        _circleView.frame = CGRectMake(0, 0, 295, 358);
        _circleView.center = self.contentView.center;
        _circleView.delegate = self;
    }
    return _circleView;
}
#pragma mark --弹框的关闭按钮
-(UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        _closeBtn.frame = CGRectMake((self.view.frameWidth-51)/2, self.circleView.frameHeigh+self.circleView.frameY+24, 51, 51);
        [_closeBtn addTarget:self action:@selector(closeTheCircleView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
-(void)closeTheCircleView
{
    [_shadeView removeFromSuperview];
    [self.circleView removeFromSuperview];
    [self.closeBtn removeFromSuperview];
}
#pragma mark-tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.accountMuArray[2] isEqualToString:@"company"] ) {
        return 5;
    }
    else if ([self.accountMuArray[2] isEqualToString:@"wechat"]||[self.transferwayArray[0]isEqualToString:@"counter"]){
        return 6;
    }
    else if ([self.accountMuArray[2] isEqualToString:@"alipay"])
    {
        return 7;
    }
    else if ([self.accountMuArray[2]isEqualToString:@"onecodepay"]){
        return 5;
    }
    return  6 ;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item==[_markArray[0] integerValue]) {
        return 226.0f ;
    }
    else if (indexPath.item==[_markArray[1] integerValue]){
        return 190.f;
    }
    else if (indexPath.item==[_markArray[2] integerValue])
    {
        return 137.f;
    }
    else if (indexPath.item==[_markArray[3] integerValue])
    {
        return 50.f;
    }
    else if (indexPath.item==[_markArray[4] integerValue]){
        return 50.f;
    }
    else if (indexPath.item ==[_markArray[5] integerValue]){
        return 50.f;
    }
    else if (indexPath.item==[_markArray[6] integerValue]){
        return 80.f;
    }
    else if (indexPath.item==[_markArray[7]integerValue]){
        return 200.f;
    }
    
    return 0.f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.item==[_markArray[0] integerValue]) {
        RH_DepositeTransferBankInfoCell *bankInfoCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferBankInfoCell defaultReuseIdentifier]] ;
//        payforWayCell.delegate = self;
        [bankInfoCell updateCellWithInfo:nil context:self.listModel];
        return bankInfoCell ;
    }
    else if (indexPath.item==[_markArray[1]integerValue]){
        RH_DepositeTransferWXinInfoCell *wxInfoCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferWXinInfoCell defaultReuseIdentifier]] ;
        //        platformCell.delegate=self;
        [wxInfoCell updateCellWithInfo:nil context:self.listModel];
        return wxInfoCell ;
    }
    else if (indexPath.item == [_markArray[2]integerValue]){
        RH_DepositeTransferQRCodeCell *qrcodeCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferQRCodeCell defaultReuseIdentifier]] ;
        qrcodeCell.delegate=self;
        [qrcodeCell updateCellWithInfo:nil context:self.listModel];
        return qrcodeCell ;
        
    }
    else if (indexPath.item == [_markArray[3] integerValue]){
        RH_DepositeTransferPayWayCell *paywayCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferPayWayCell defaultReuseIdentifier]] ;
        self.paywayCell = paywayCell;
        paywayCell.delegate = self;
        [paywayCell updateCellWithInfo:nil context:self.accountMuArray];
        return paywayCell ;
    }
    else if (indexPath.item == [_markArray[4] integerValue]){
        RH_DepositeTransferOrderNumCell *orderCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferOrderNumCell defaultReuseIdentifier]] ;
        self.transferOrderCell = orderCell;
        orderCell.delegate = self;
       [orderCell updateCellWithInfo:nil context:self.accountMuArray[2]];
        return orderCell ;
    }
    else if (indexPath.item == [_markArray[5] integerValue]){
        RH_DepositeTransferPayAdressCell *paywayCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferPayAdressCell defaultReuseIdentifier]] ;
        self.adressCell = paywayCell;
        paywayCell.delegate = self;
       [paywayCell updateCellWithInfo:nil context:self.accountMuArray[2]];
        return paywayCell ;
    }
    else if (indexPath.item == [_markArray[6] integerValue]){
        RH_DepositeTransferButtonCell *btnCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferButtonCell defaultReuseIdentifier]];
        btnCell.delegate = self;
        return btnCell;
    }
    else if (indexPath.item == [_markArray[7] integerValue]){
        RH_DepositeTransferReminderCell *reminderCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferReminderCell defaultReuseIdentifier]] ;
        reminderCell.delegate=self;
        [reminderCell updateCellWithInfo:nil context:self.accountMuArray[2]];
        return reminderCell ;
    }
    return nil;
}
#pragma mark --RH_DepositeTransferReminderCell的代理，点击进入客服界面
-(void)touchTransferReminderTextViewPushCustomViewController:(RH_DepositeTransferReminderCell *)cell
{
    RH_CustomServiceSubViewController *customVC = [[RH_CustomServiceSubViewController alloc]init];
    [self showViewController:customVC sender:self];
//    touchTransferReminderTextViewPushCustomViewController
//    [self.tabBarController setSelectedIndex:3];
}
#pragma mark --点击遮罩层，关闭遮罩层和弹框
-(void)closeShadeView
{
    [self.pulldownView removeFromSuperview];
    [_shadeView removeFromSuperview];
    [self.circleView removeFromSuperview];
    [self.closeBtn removeFromSuperview];
}
#pragma mark --点击textfield
-(void)depositeTransferPaywayCellSelecteUpframe:(RH_DepositeTransferPayWayCell *)cell
{
    if ([self.accountMuArray[2] isEqualToString:@"company"]||[self.accountMuArray[2] isEqualToString:@"counter"]) {
       [self.contentTableView setContentOffset:CGPointMake(0,100) animated:YES];
    }
   
    else {
        [self.contentTableView setContentOffset:CGPointMake(0,200) animated:YES];
    }
    
    
}
-(void)depositeTransferOrderNumCellSelecteUpframe:(RH_DepositeTransferOrderNumCell *)cell
{
    if ([self.accountMuArray[2] isEqualToString:@"company"]||[self.accountMuArray[2] isEqualToString:@"counter"]) {
        [self.contentTableView setContentOffset:CGPointMake(0,100) animated:YES];
    }
    
    else {
        [self.contentTableView setContentOffset:CGPointMake(0,200) animated:YES];
    }
    
}
-(void)depositeTransferPayAdressCellSelecteUpframe:(RH_DepositeTransferPayAdressCell *)cell
{
    if ([self.accountMuArray[2] isEqualToString:@"company"]||[self.accountMuArray[2] isEqualToString:@"counter"]) {
        [self.contentTableView setContentOffset:CGPointMake(0,100) animated:YES];
    }
    
    else {
        [self.contentTableView setContentOffset:CGPointMake(0,200) animated:YES];
    }
}
#pragma mark --点击提交按钮
-(void)selectedDepositeTransferButton:(RH_DepositeTransferButtonCell *)cell
{
    [self.paywayCell.payNumTextfield resignFirstResponder];

    [self.transferOrderCell.orderNumTextfiled resignFirstResponder];

    [self.adressCell.payTextfield resignFirstResponder];
    
    if ([self.accountMuArray[2] isEqualToString:@"counter"]) {
        if (self.transferOrderCell.transferOrderString.length==0) {
                showMessage(self.view, @"请填转账账号对应的姓名", nil);
            }
            else{
                if (self.adressCell.adressStr==0) {
                    showMessage(self.view, @"请填写存款地点", nil);
                }
                else{
                    [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:self.accountMuArray[0]  PayAccountDepositWay:self.listModel.mDepositWay PayAccountID:self.listModel.mSearchId];
                }
            }
    }
    else if ([self.accountMuArray[2] isEqualToString:@"company"]){
        if (self.transferOrderCell.transferOrderString.length==0) {
            showMessage(self.view, @"请填写账号对应的姓名", nil);
        }
        else{

            [self.contentTableView setContentOffset:CGPointMake(0,0) animated:YES];
            [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:self.accountMuArray[0]  PayAccountDepositWay:self.listModel.mDepositWay PayAccountID:self.listModel.mSearchId];
        }
    }
    else if ([self.accountMuArray[2] isEqualToString:@"wechat"]){
        if (self.paywayCell.paywayString.length==0||self.paywayCell.paywayString==nil) {
            showMessage(self.view, @"请填写微信昵称", nil);
        }
        else{
            if (self.transferOrderCell.transferOrderString.length!=5&&self.transferOrderCell.transferOrderString.length!=0&&self.transferOrderCell.transferOrderString!=nil) {
                showMessage(self.view, @"请输入五位纯数字订单号", nil);
            }
            else if(self.transferOrderCell.transferOrderString.length!=0){
                NSString *regex = @"[0-9]*";
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
                if ([pred evaluateWithObject:self.transferOrderCell.transferOrderString]) {
                     [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:self.accountMuArray[0]  PayAccountDepositWay:self.listModel.mDepositWay PayAccountID:self.listModel.mSearchId];
                }
                else{
                    showMessage(self.view, @"请输入五位纯数字订单号", nil);
                }
            }
            else{
               [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:self.accountMuArray[0]  PayAccountDepositWay:self.listModel.mDepositWay PayAccountID:self.listModel.mSearchId];
            }
        }
    }
    else if ([self.accountMuArray[2] isEqualToString:@"qq"]){
        if (self.paywayCell.paywayString.length==0||self.paywayCell.paywayString==nil) {
            showMessage(self.view, @"请填写qq号码", nil);
        }
        else{
            if (self.transferOrderCell.transferOrderString.length!=5&&self.transferOrderCell.transferOrderString.length!=0&&self.transferOrderCell.transferOrderString!=nil) {
                showMessage(self.view, @"请输入五位纯数字订单号", nil);
            }
            else if(self.transferOrderCell.transferOrderString.length!=0){
                NSString *regex = @"[0-9]*";
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
                if ([pred evaluateWithObject:self.transferOrderCell.transferOrderString]) {
                    [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:self.accountMuArray[0]  PayAccountDepositWay:self.listModel.mDepositWay PayAccountID:self.listModel.mSearchId];
                }
                else{
                    showMessage(self.view, @"请输入五位纯数字订单号", nil);
                }
            }
            else{
                [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:self.accountMuArray[0]  PayAccountDepositWay:self.listModel.mDepositWay PayAccountID:self.listModel.mSearchId];
            }
        }
    }
    else if ([self.accountMuArray[2] isEqualToString:@"jd"]){
        if (self.paywayCell.paywayString.length==0 ||self.paywayCell.paywayString == nil) {
            showMessage(self.view, @"请填写京东号", nil);
        }
        else{
            if (self.transferOrderCell.transferOrderString.length!=5&&self.transferOrderCell.transferOrderString.length!=0&&self.transferOrderCell.transferOrderString!=nil) {
                showMessage(self.view, @"请输入五位纯数字订单号", nil);
            }
            else if(self.transferOrderCell.transferOrderString.length!=0){
                NSString *regex = @"[0-9]*";
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
                if ([pred evaluateWithObject:self.transferOrderCell.transferOrderString]) {
                    [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:self.accountMuArray[0]  PayAccountDepositWay:self.listModel.mDepositWay PayAccountID:self.listModel.mSearchId];
                }
                else{
                    showMessage(self.view, @"请输入五位纯数字订单号", nil);
                }
            }
            else{
                [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:self.accountMuArray[0]  PayAccountDepositWay:self.listModel.mDepositWay PayAccountID:self.listModel.mSearchId];
            }
        }
    }
    else if ([self.accountMuArray[2] isEqualToString:@"bd"]){
        if (self.paywayCell.paywayString.length==0||self.paywayCell.paywayString == nil) {
            showMessage(self.view, @"请填写百度账号", nil);
        }
        else{
            if (self.transferOrderCell.transferOrderString.length!=5&&self.transferOrderCell.transferOrderString.length!=0&&self.transferOrderCell.transferOrderString!=nil) {
                showMessage(self.view, @"请输入五位纯数字订单号", nil);
            }
            else if(self.transferOrderCell.transferOrderString.length!=0){
                NSString *regex = @"[0-9]*";
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
                if ([pred evaluateWithObject:self.transferOrderCell.transferOrderString]) {
                    [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:self.accountMuArray[0]  PayAccountDepositWay:self.listModel.mDepositWay PayAccountID:self.listModel.mSearchId];
                }
                else{
                    showMessage(self.view, @"请输入五位纯数字订单号", nil);
                }
            }
            else{
                [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:self.accountMuArray[0]  PayAccountDepositWay:self.listModel.mDepositWay PayAccountID:self.listModel.mSearchId];
            }
        }
    }
    else if ([self.accountMuArray[2] isEqualToString:@"other"]){
        if (self.paywayCell.paywayString.length==0||self.paywayCell.paywayString == nil) {
            showMessage(self.view, @"请填写其他方式的账号", nil);
        }
        else{
            if (self.transferOrderCell.transferOrderString.length!=5&&self.transferOrderCell.transferOrderString.length!=0&&self.transferOrderCell.transferOrderString!=nil) {
                showMessage(self.view, @"请输入五位纯数字订单号", nil);
            }
            else if(self.transferOrderCell.transferOrderString.length!=0){
                NSString *regex = @"[0-9]*";
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
                if ([pred evaluateWithObject:self.transferOrderCell.transferOrderString]) {
                    [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:self.accountMuArray[0]  PayAccountDepositWay:self.listModel.mDepositWay PayAccountID:self.listModel.mSearchId];
                }
                else{
                    showMessage(self.view, @"请输入五位纯数字订单号", nil);
                }
            }
            else{
                [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:self.accountMuArray[0]  PayAccountDepositWay:self.listModel.mDepositWay PayAccountID:self.listModel.mSearchId];
            }
        }
    }
    else if ([self.accountMuArray[2] isEqualToString:@"alipay"]){
        if (self.paywayCell.paywayString.length==0) {
            showMessage(self.view, @"请填写支付宝用户名", nil);
        }
        else{
            if (self.transferOrderCell.transferOrderString.length==0) {
                showMessage(self.view, @"请输入支付宝账号", nil);
            }
            else{
                if (self.adressCell.adressStr.length!=5&&self.adressCell.adressStr.length!=0&&self.adressCell.adressStr!=nil) {
                    showMessage(self.view, @"请输入五位纯数字订单号", nil);
                }
                else if(self.adressCell.adressStr.length!=0){
                    NSString *regex = @"[0-9]*";
                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
                    if ([pred evaluateWithObject:self.adressCell.adressStr]) {
                        [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:self.accountMuArray[0]  PayAccountDepositWay:self.listModel.mDepositWay PayAccountID:self.listModel.mSearchId];
                    }
                    else{
                        showMessage(self.view, @"请输入五位纯数字订单号", nil);
                    }
                }
                else{
                    [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:self.accountMuArray[0]  PayAccountDepositWay:self.listModel.mDepositWay PayAccountID:self.listModel.mSearchId];
                }
            }
        }
        
    }

    else if ([self.accountMuArray[2] isEqualToString:@"onecodepay"])
    {
        if (self.paywayCell.paywayString.length!=5&&self.paywayCell.paywayString.length!=0&&self.paywayCell.paywayString!=nil) {
            showMessage(self.view, @"请输入五位纯数字订单号", nil);
        }
        else if(self.paywayCell.paywayString.length!=0){
            NSString *regex = @"[0-9]*";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
            if ([pred evaluateWithObject:self.paywayCell.paywayString]) {
                [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:self.accountMuArray[0]  PayAccountDepositWay:self.listModel.mDepositWay PayAccountID:self.listModel.mSearchId];
            }
            else{
                showMessage(self.view, @"请输入五位纯数字订单号", nil);
            }
        }
        else{
            [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:self.accountMuArray[0]  PayAccountDepositWay:self.listModel.mDepositWay PayAccountID:self.listModel.mSearchId];
        }
    }

}

#pragma mark --选择弹框列表
-(void)depositeSubmitCircleViewChooseDiscount:(NSInteger)activityId
{
    self.activityId = activityId;
}
#pragma mark --点击柜台机选择
-(void)depositeTransferPaywayCellSelectePullDownView:(CGRect)frame
{
    if (!self.pulldownView.superview) {
        CGRect framm = frame;
        framm.origin.y+=340;
        framm.size.height+=100;
        framm.size.width=150;
        framm.origin.x = self.contentView.frameWidth-160;
        self.pulldownView.frame =framm;
        UIView *shadeView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
        shadeView.backgroundColor = [UIColor lightGrayColor];
        shadeView.alpha = 0.7f;
        shadeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeShadeView)];
        [shadeView addGestureRecognizer:tap];
        [[UIApplication sharedApplication].keyWindow addSubview:shadeView];
        _shadeView = shadeView;
        [[UIApplication sharedApplication].keyWindow addSubview:self.pulldownView];
    }
}
#pragma mark --点击柜台存款方式
-(void)depositeTransferChooseCunterCelected:(RH_DepositeTansferCounterModel *)cunterModel
{
 
    self.paywayCell.transferLabel.text = cunterModel.mName;
    self.counterStr = cunterModel.mCode;
    [self.pulldownView removeFromSuperview];
    [self.shadeView removeFromSuperview];
    [self.contentTableView reloadData];
}
#pragma mark -- 点击弹框里面的提交按钮
-(void)depositeSubmitCircleViewTransferMoney:(RH_DepositeSubmitCircleView *)circleView
{
    if ([self.accountMuArray[2]isEqualToString:@"wechat"]||
        [self.accountMuArray[2]isEqualToString:@"qq"]||
        [self.accountMuArray[2]isEqualToString:@"jd"]||
        [self.accountMuArray[2]isEqualToString:@"bd"]||
        [self.accountMuArray[2]isEqualToString:@"bitcion"]||
        [self.accountMuArray[2]isEqualToString:@"unionpay"]||[self.accountMuArray[2]isEqualToString:@"onecodepay"]||
        [self.accountMuArray[2]isEqualToString:@"other"]) {
        
        [self.serviceRequest startV3ElectronicPayWithRechargeAmount:self.accountMuArray[0] rechargeType:self.listModel.mRechargeType payAccountId:self.listModel.mSearchId bankOrder:12345 payerName:@"12" payerBankcard:self.paywayCell.paywayString activityId:self.activityId];
        [self closeShadeView] ;
        [self showProgressIndicatorViewWithAnimated:YES title:@"存款提交中"] ;
        
    }
    else if ([self.accountMuArray[2]isEqualToString:@"alipay"])
    {
        [self.serviceRequest startV3AlipayElectronicPayWithRechargeAmount:self.accountMuArray[0] rechargeType:self.listModel.mRechargeType payAccountId:self.listModel.mSearchId bankOrder:12345 payerName:self.paywayCell.paywayString payerBankcard:self.transferOrderCell.transferOrderString activityId:self.activityId];
        [self closeShadeView] ;
        [self showProgressIndicatorViewWithAnimated:YES title:@"存款提交中"] ;
    }
    else if ([self.accountMuArray[2]isEqualToString:@"company"]){
        [self.serviceRequest startV3CompanyPayWithRechargeAmount:self.accountMuArray[0] rechargeType:self.listModel.mRechargeType payAccountId:self.listModel.mSearchId payerName:self.transferOrderCell.transferOrderString
         activityId:self.activityId];
        [self closeShadeView] ;
        [self showProgressIndicatorViewWithAnimated:YES title:@"存款提交中"] ;
    }
    else if ([self.accountMuArray[2]isEqualToString:@"counter"]){
        [self.serviceRequest startV3CounterPayWithRechargeAmount:self.accountMuArray[0]  rechargeType:self.counterStr payAccountId:self.listModel.mSearchId payerName:self.transferOrderCell.transferOrderString rechargeAddress:self.adressCell.adressStr activityId:self.activityId];
        [self closeShadeView] ;
        [self showProgressIndicatorViewWithAnimated:YES title:@"存款提交中"] ;
    }
}

#pragma mark - DepositeTransferQRCodeCellDelegate
-(void)depositeTransferQRCodeCellDidTouchSaveToPhoneWithImageUrl:(NSString *)imageUrl
{
    [self showProgressIndicatorViewWithAnimated:YES title:@"图片保存中"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageUrl]]];
    UIImage *myImage = [UIImage imageWithData:data];
    [self saveImageToPhotos:myImage];
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

#pragma mark -DepositSuccessAlertViewDelegate
- (void)depositSuccessAlertViewDidTouchCancelButton {
    
    [self backBarButtonItemHandle] ;
}
//再存一次
-(void)depositSuccessAlertViewDidTouchSaveAgainBtn
{
    [self.navigationController popViewControllerAnimated:YES] ;
}
//查看资金记录
-(void)depositSuccessAlertViewDidTouchCheckCapitalBtn
{
    [self.navigationController showViewController:[RH_CapitalRecordViewController viewController] sender:self] ;
}
#pragma mark-
-(void)netStatusChangedHandle
{
    if (NetworkAvailable()){
//        [self startUpdateData] ;
    }
}
#pragma mark- 请求回调

-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
//
    
    
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
    
    if (type == ServiceRequestTypeV3DepositOriginSeachSale) {
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
        self.circleView.moneyNumLabel.text = self.accountMuArray[0];
        [self.circleView setupViewWithContext:self.saleModel];
        [[UIApplication sharedApplication].keyWindow addSubview:self.circleView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.closeBtn];
    }
    else if (type==ServiceRequestTypeV3ElectronicPay){
        if ([data objectForKey:@"data"]) {
            [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
                if (self.successAlertView.superview == nil) {
                    self.successAlertView = [[RH_DepositSuccessAlertView alloc] init];
                    self.successAlertView.alpha = 0;
                    self.successAlertView.delegate = self;
                    [self.contentView addSubview:self.successAlertView];
                    self.successAlertView.whc_TopSpace(0).whc_LeftSpace(0).whc_BottomSpace(0).whc_RightSpace(0);
                    [UIView animateWithDuration:0.3 animations:^{
                        self.successAlertView.alpha = 1;
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [self.successAlertView showContentView];
                        }
                    }];
                }
            }] ;
        }else
        {
            showMessage(self.view, @"存款失败", nil);
        }
        
    }
    else if (type==ServiceRequestTypeV3AlipayElectronicPay){
        if ([data objectForKey:@"data"]) {
            [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
                if (self.successAlertView.superview == nil) {
                    self.successAlertView = [[RH_DepositSuccessAlertView alloc] init];
                    self.successAlertView.alpha = 0;
                    self.successAlertView.delegate = self;
                    [self.contentView addSubview:self.successAlertView];
                    self.successAlertView.whc_TopSpace(0).whc_LeftSpace(0).whc_BottomSpace(0).whc_RightSpace(0);
                    [UIView animateWithDuration:0.3 animations:^{
                        self.successAlertView.alpha = 1;
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [self.successAlertView showContentView];
                        }
                    }];
                }
            }] ;
        }else
        {
            showMessage(self.view, @"存款失败", nil);
        }
    }
    else if (type==ServiceRequestTypeV3CounterPay){
        if ([data objectForKey:@"data"]) {
            [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
                if (self.successAlertView.superview == nil) {
                    self.successAlertView = [[RH_DepositSuccessAlertView alloc] init];
                    self.successAlertView.alpha = 0;
                    self.successAlertView.delegate = self;
                    [self.contentView addSubview:self.successAlertView];
                    self.successAlertView.whc_TopSpace(0).whc_LeftSpace(0).whc_BottomSpace(0).whc_RightSpace(0);
                    [UIView animateWithDuration:0.3 animations:^{
                        self.successAlertView.alpha = 1;
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [self.successAlertView showContentView];
                        }
                    }];
                }
            }] ;
        }else
        {
            [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
                showMessage(self.view, @"存款失败", nil);
            }] ;
        }
    }else if(type == ServiceRequestTypeV3CompanyPay)
    {
        if ([data objectForKey:@"data"]) {
            [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
                if (self.successAlertView.superview == nil) {
                    self.successAlertView = [[RH_DepositSuccessAlertView alloc] init];
                    self.successAlertView.alpha = 0;
                    self.successAlertView.delegate = self;
                    [self.contentView addSubview:self.successAlertView];
                    self.successAlertView.whc_TopSpace(0).whc_LeftSpace(0).whc_BottomSpace(0).whc_RightSpace(0);
                    [UIView animateWithDuration:0.3 animations:^{
                        self.successAlertView.alpha = 1;
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [self.successAlertView showContentView];
                        }
                    }];
                }
            }] ;
        }else
        {
            [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
                showMessage(self.view, @"存款失败", nil);
            }] ;
        }
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    if (type == ServiceRequestTypeV3DepositOriginSeachSale) {
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }
    else if (type==ServiceRequestTypeV3ElectronicPay){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showErrorMessage(self.view, error, @"存款失败");
        }] ;
    }
    else if (type==ServiceRequestTypeV3AlipayElectronicPay){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showErrorMessage(self.view, error, @"存款失败");
        }] ;
    }else if(type == ServiceRequestTypeV3CompanyPay)
    {
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showErrorMessage(self.view, error, @"存款失败");
        }] ;
    }
    else if (type==ServiceRequestTypeV3CounterPay){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showErrorMessage(self.view, error, @"存款失败");
        }] ;
    }
}


@end
