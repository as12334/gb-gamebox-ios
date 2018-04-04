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
#import "RH_DepositeTransferButtonCell.h"
#import "RH_DepositeTransferChannelModel.h"
#import "RH_DepositOriginseachSaleModel.h"
#import "RH_DepositBitcionViewController.h"
#import "RH_BankPickerSelectView.h"
#import "THScrollChooseView.h"
#import "RH_CustomViewController.h"
#import "RH_APPDelegate.h"
#import "RH_DepositSuccessAlertView.h"
#import "RH_CapitalRecordViewController.h"
#import "RH_QuickChongZhiViewController.h"
@interface RH_DepositeViewControllerEX ()<LoginViewControllerExDelegate,DepositeReminderCellCustomDelegate,DepositePayforWayCellDelegate,DepositeSystemPlatformCellDelegate,RH_ServiceRequestDelegate,DepositeSubmitCircleViewDelegate,DepositeChooseMoneyCellDelegate,DepositeTransferButtonCellDelegate,DepositeMoneyBankCellDeleaget,DepositSuccessAlertViewDelegate>
@property(nonatomic,strong,readonly)RH_DepositeSubmitCircleView *circleView;
@property(nonatomic,strong)UIView *shadeView;
@property(nonatomic,strong)NSArray *markArray;
@property(nonatomic,strong)RH_DepositeTransferModel *transferModel;
@property(nonatomic,strong)RH_DepositeTransferChannelModel *channelModel;
@property(nonatomic,strong)RH_DepositeTransferListModel *listModel;
@property(nonatomic,strong)NSArray *transModelArray;
@property(nonatomic,strong)RH_DepositeMoneyNumberCell *numberCell;
@property(nonatomic,strong)RH_DepositeSystemPlatformCell *platformCell;
@property(nonatomic,strong)NSArray *accountModelArray;
@property(nonatomic,strong,readonly)UIButton *closeBtn;
@property(nonatomic,strong)RH_DepositSuccessAlertView *successAlertView ;
@property(nonatomic,strong)RH_DepositeMoneyBankCell *bankCell;

//柜台机下拉列表数组
@property(nonatomic,strong)NSArray *counterArray;

//支付方式类型
@property(nonatomic,strong)NSString *payforType;
//优惠ID
@property(nonatomic,assign)NSInteger activityId;
@property(nonatomic,assign)NSInteger accountId;
@property(nonatomic,strong)NSString *rechargeTypeStr;
//存款渠道name
@property(nonatomic,strong)NSString *depositeName;
@property(nonatomic,strong)NSString *depositeCode;
//点击选择金额按钮，界面上移
@property(nonatomic,assign)CGFloat keyboardHeight;
//在线存款具体选择的那个银行
@property(nonatomic,assign)NSInteger bankSeletedIndex;
//将金额传入到优惠弹出界面
@property(nonatomic,strong)NSString *discountStr;

@end

@implementation RH_DepositeViewControllerEX
{
    NSInteger _selectNumber;
}
@synthesize circleView = _circleView;
@synthesize closeBtn = _closeBtn;

-(BOOL)tabBarHidden
{
    return NO ;
}
-(BOOL)needLogin
{
    return YES  ;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    [self.contentTableView setContentOffset:CGPointMake(0,-64) animated:YES];
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
        else
        {
            self.numberCell.payMoneyNumLabel.text=nil;
//            self.numberCell.payMoneyNumLabel.text.length=
        }
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //增加login status changed notification
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:NT_LoginStatusChangedNotification object:nil] ;
    self.title = @"存款";
    [self setNeedUpdateView];
    [self setupUI];
    // 键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
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
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self   ;
    self.contentTableView.dataSource = self ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    self.contentTableView.sectionHeaderHeight = 0.0f ;
    self.contentTableView.showsHorizontalScrollIndicator = NO;
    self.contentTableView.showsVerticalScrollIndicator = NO;
    [self.contentTableView registerCellWithClass:[RH_DepositePayforWayCell class]] ;
    [self.contentTableView registerCellWithClass:[RH_DepositeChooseMoneyCell class]];
    [self.contentTableView registerCellWithClass:[RH_DepositeMoneyNumberCell class]];
    [self.contentTableView registerCellWithClass:[RH_DepositeReminderCell class]];
    [self.contentTableView registerCellWithClass:[RH_DepositeMoneyBankCell class]];
    [self.contentTableView registerCellWithClass:[RH_DepositeSystemPlatformCell class]];
    [self.contentTableView registerCellWithClass:[RH_DepositeTransferButtonCell class]];
    [self.contentView addSubview:self.contentTableView] ;
    self.contentTableView.whc_LeftSpace(0).whc_TopSpace(0).whc_RightSpace(0).whc_BottomSpace(0) ;
    
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
    if ([self.depositeCode isEqualToString:@"bitcoin"]||[self.depositeName isEqualToString:@"快充中心"]){
        return 1;
    }
    else{
    return  6 ;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item==[_markArray[0] integerValue]) {
        return [RH_DepositePayforWayCell heightForCellWithInfo:nil tableView:tableView context:self.transModelArray] ;
    }
    else if (indexPath.item==[_markArray[1] integerValue]){
        return [RH_DepositeSystemPlatformCell heightForCellWithInfo:nil tableView:tableView context:self.channelModel.mArrayListModel] -10;
//        return 120.f;
    }
    else if (indexPath.item ==[_markArray[2]integerValue]){
        return 120.f;
    }
    else if (indexPath.item==[_markArray[3] integerValue]){
        return 50.f;
    }
    else if (indexPath.item==[_markArray[4] integerValue]){
        return 50.f;
    }
    else if (indexPath.item ==[_markArray[5] integerValue]){
//
        return 80;
    }
    else if (indexPath.item ==[_markArray[6] integerValue]){
        return 160.f;
    }
    return 0.0f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (self.pageLoadManager.currentDataCount) {
        NSArray *transferModelArray = ConvertToClassPointer(NSArray, [self.pageLoadManager dataAtIndex:0]);
        if (indexPath.item==[_markArray[0]integerValue]) {
            RH_DepositePayforWayCell *payforWayCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositePayforWayCell defaultReuseIdentifier]] ;
            payforWayCell.delegate = self;
            [payforWayCell updateCellWithInfo:nil context:transferModelArray];
            return payforWayCell ;
        }
        else if (indexPath.item==[_markArray[1]integerValue]){
            RH_DepositeSystemPlatformCell *platformCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeSystemPlatformCell defaultReuseIdentifier]] ;
            platformCell.delegate=self;
            self.platformCell = platformCell;
            [platformCell updateCellWithInfo:nil context:self.channelModel];
            return platformCell ;
        }
        else if (indexPath.item == [_markArray[2]integerValue]){
            RH_DepositeChooseMoneyCell *moneyCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeChooseMoneyCell defaultReuseIdentifier]] ;
            moneyCell.delegate = self;
            
            return moneyCell ;
        }
        else if (indexPath.item == [_markArray[3]integerValue]){
            RH_DepositeMoneyNumberCell *numberCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeMoneyNumberCell defaultReuseIdentifier]] ;
            self.numberCell = numberCell;
            UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
            [topView setBarStyle:UIBarStyleBlackTranslucent];
            UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(2, 5, 50, 25);
            [btn addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:@"完成"forState:UIControlStateNormal];
            
            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
            NSArray * buttonsArray = [NSArray   arrayWithObjects:btnSpace,doneBtn,nil];
            [topView setItems:buttonsArray];
            [numberCell.payMoneyNumLabel setInputAccessoryView:topView];
            return numberCell ;
        }
        else if (indexPath.item == [_markArray[4]integerValue]){
            RH_DepositeMoneyBankCell *bankCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeMoneyBankCell defaultReuseIdentifier]] ;
            bankCell.delegate = self;
            self.bankCell = bankCell;
            [bankCell updateCellWithInfo:nil context:self.channelModel];
            return bankCell ;
        }
        else if (indexPath.item == [_markArray[5]integerValue]){
            RH_DepositeTransferButtonCell *btnCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferButtonCell defaultReuseIdentifier]];
            btnCell.delegate = self;
            return btnCell;
        }
        else if (indexPath.item == [_markArray[6]integerValue]){
            RH_DepositeReminderCell *reminderCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeReminderCell defaultReuseIdentifier]] ;
            reminderCell.delegate = self;
            return reminderCell ;
        }
       
       
    }
    else{
        return self.loadingIndicateTableViewCell ;
    }
    
    return nil;
}
#pragma mark --depositePayforWay的代理，选择付款的平台
-(void)depositePayforWayDidtouchItemCell:(RH_DepositePayforWayCell *)payforItem depositeCode:(NSString *)depositeCode depositeName:(NSString *)depositName
{
  
    [self.serviceRequest startV3RequestDepositOriginChannel:depositeCode];
    if ([depositName isEqualToString:@"快充中心"]) {
       
    }else
    {
         [self showProgressIndicatorViewWithAnimated:YES title:nil] ;
    }
    //点击各个渠道，重置存款方式
    [self.platformCell awakeFromNib];
    self.payforType=nil;
    
    self.depositeName = depositName;
    self.depositeCode = depositeCode;
    
    if ([self.depositeName isEqualToString:@"快充中心"]) {
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        appDelegate.customUrl =depositeCode ;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showViewController:[RH_QuickChongZhiViewController viewControllerWithContext:depositeCode] sender:self] ;
        }) ;
        _markArray = @[@0];
    }
   else{
        if ([depositName isEqualToString:@"在线支付"]) {
            _markArray = @[@0,@6,@1,@2,@3,@4,@5];
            self.bankCell.bankNameLabel.text=@"请选择支付银行";
        }
        else {
            _markArray = @[@0,@1,@2,@3,@6,@4,@5];
        }
   }
        [self.contentTableView reloadData];
}
#pragma mark --depositeReminder的代理,跳转到客服
-(void)touchTextViewCustomPushCustomViewController:(RH_DepositeReminderCell *)cell
{
    [self.tabBarController setSelectedIndex:3];
}
#pragma mark --RH_DepositeSystemPlatformCell的代理，选择不同的平台进行跳转
-(void)depositeSystemPlatformCellDidtouch:(RH_DepositeSystemPlatformCell *)cell payTypeString:(NSString *)payType accountModel:(id)accountModel acounterModel:(NSArray *)acounterModel
{
    self.payforType = payType;
    self.listModel = accountModel;
    [self.numberCell updateCellWithInfo:nil context:accountModel];
    self.counterArray = acounterModel;
    //判断选择的支付方式的type，来确定是否跳转
    [self.contentTableView reloadData];
}
#pragma mark --选择金钱的代理
-(void)depositeChooseMoneyCell:(NSInteger)moneyNumber
{
    NSInteger sum =  [self.numberCell.payMoneyNumLabel.text integerValue]+moneyNumber;
    self.numberCell.payMoneyNumLabel.text = [NSString stringWithFormat:@"%ld",moneyNumber];
    
}
#pragma mark --提交按钮的代理
-(void)selectedDepositeTransferButton:(RH_DepositeTransferButtonCell *)cell
{
    [self.numberCell.payMoneyNumLabel resignFirstResponder];
//    [self.contentTableView setContentOffset:CGPointMake(0,0) animated:YES];
    //点击提交按钮tabelView向下移动
    CGFloat sum =[self.numberCell.payMoneyNumLabel.text doubleValue]+[self.numberCell.decimalsBtn.titleLabel.text doubleValue];
    NSString *sumStr = [NSString stringWithFormat:@"%0.2f",sum];
    self.discountStr = sumStr;
    
    //  线上支付比较特殊
    if ([self.depositeCode isEqualToString:@"online"])
    {
        RH_DepositeTransferListModel *onlineModel =  (RH_DepositeTransferListModel *)self.channelModel.mArrayListModel[self.bankSeletedIndex] ;
        if (self.depositeName==nil)
        {
            showMessage(self.view, @"请选择付款平台", nil);
        }
        else{
            if ([self.numberCell.payMoneyNumLabel.text integerValue]<onlineModel.mSingleDepositMin||[self.numberCell.payMoneyNumLabel.text integerValue]>onlineModel.mSingleDepositMax||[self.numberCell.payMoneyNumLabel.text integerValue]==0)
                {
                    showMessage(self.view, [NSString stringWithFormat:@"请输入%ld~%ld元",onlineModel.mSingleDepositMin,onlineModel.mSingleDepositMax], nil);
                }
            
            else{
                if ([sumStr floatValue]>onlineModel.mSingleDepositMax) {
                    showMessage(self.view, [NSString stringWithFormat:@"您输入的%@超出了限定",sumStr], nil);
                }
                else{
                    if ([self.bankCell.bankNameLabel.text isEqualToString:@"请选择支付银行"]) {
                        showMessage(self.view, @"请选择支付银行", nil);
                    }
                    else{
                    [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:sumStr  PayAccountDepositWay:onlineModel.mDepositWay PayAccountID:onlineModel.mSearchId];
                    }
                }
                
            }
        }
    }
    else{
    
        if (self.depositeName==nil) {
            showMessage(self.view, @"请选择付款平台", nil);
        }
        else{
            if (self.payforType==nil) {
                showMessage(self.view, @"请选择存款方式", nil);
            }
            else{
                if ([self.numberCell.payMoneyNumLabel.text integerValue]<self.numberCell.moneyNumMin||[self.numberCell.payMoneyNumLabel.text integerValue]>self.numberCell.moneyNumMax||[self.numberCell.payMoneyNumLabel.text integerValue]==0) {
                    showMessage(self.view, [NSString stringWithFormat:@"请输入%ld~%ld元",self.numberCell.moneyNumMin,self.numberCell.moneyNumMax], nil);
                }
                else{
                    if ([sumStr doubleValue]>self.numberCell.moneyNumMax) {
                        showMessage(self.view, [NSString stringWithFormat:@"您输入的%@超出了限定",sumStr], nil);
                    }
                    else{
                        if ([self.payforType isEqualToString:@"1"]) {
                            NSMutableArray *mutableArray = [NSMutableArray array];
                            [mutableArray addObject:sumStr];
                            [mutableArray addObject:self.listModel];
                            [mutableArray addObject:self.depositeCode];
                            if (self.counterArray.count>0) {
                              [mutableArray addObject:self.counterArray];
                            }
                            RH_DepositeTransferBankcardController *transferVC = [RH_DepositeTransferBankcardController viewControllerWithContext:mutableArray];
                            [self showViewController:transferVC sender:self];
                        }
                        else{
                            [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:sumStr PayAccountDepositWay:self.listModel.mDepositWay PayAccountID:self.listModel.mSearchId];
                        }
                    }
                }
            }
        }
    }

}

#pragma mark --点击遮罩层，关闭遮罩层和弹框
-(void)closeShadeView
{
    [_shadeView removeFromSuperview];
    [self.circleView removeFromSuperview];
    [self.closeBtn removeFromSuperview];
}

#pragma mark - DepositSuccessAlertViewDelegate
-(void)depositSuccessAlertViewDidTouchCheckCapitalBtn
{
    [self.navigationController showViewController:[RH_CapitalRecordViewController viewController] sender:self] ;
}

-(void)depositSuccessAlertViewDidTouchSaveAgainBtn
{
    [self.successAlertView removeFromSuperview];
    [self.contentTableView reloadData] ;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}
#pragma mark -- 点击弹框里面的提交按钮
-(void)depositeSubmitCircleViewTransferMoney:(RH_DepositeSubmitCircleView *)circleView
{

    if ([self.depositeCode isEqualToString:@"online"]) {
         RH_DepositeTransferListModel *onlineModel = ConvertToClassPointer(RH_DepositeTransferListModel, self.channelModel.mArrayListModel[self.bankSeletedIndex]) ;
        [self.serviceRequest startV3OnlinePayWithRechargeAmount:self.discountStr rechargeType:onlineModel.mRechargeType payAccountId:onlineModel.mSearchId activityId:[NSString stringWithFormat:@"%ld",self.activityId]];
    }
    else{
        [self.serviceRequest
         startV3ScanPayWithRechargeAmount:
         self.discountStr
         rechargeType:self.listModel.mRechargeType
         payAccountId:nil
         payerBankcard:nil
         activityId:self.activityId
         account:self.listModel.mSearchId];
        [self closeShadeView] ;
        [self showProgressIndicatorViewWithAnimated:YES title:@"存款提交中"] ;
    }
}
#pragma mark -- 优惠列表
-(void)depositeSubmitCircleViewChooseDiscount:(NSInteger)activityId
{
    self.activityId = activityId;
}

#pragma mark --银行列表
-(void)depositeMoneyBankCellChoosePickerview:(RH_DepositeMoneyBankCell *)cell andBankNameArray:(NSMutableArray *)bankNameArray
{
    if (bankNameArray.count>0) {
        THScrollChooseView *scrollChooseView = [[THScrollChooseView alloc] initWithQuestionArray:bankNameArray withDefaultDesc:bankNameArray[0]];
        [scrollChooseView showView];
        __weak RH_DepositeViewControllerEX *weakSelf = self;
        scrollChooseView.confirmBlock = ^(NSInteger selectedQuestion) {
            weakSelf.bankSeletedIndex = selectedQuestion;
            [cell.bankNameLabel setText:bankNameArray[selectedQuestion]];
            //选择不同的银行需要存入的钱的范围不一样
            weakSelf.numberCell.payMoneyNumLabel.placeholder =[NSString stringWithFormat:@"%ld~%ld",((RH_DepositeTransferListModel*)self.channelModel.mArrayListModel[selectedQuestion]).mSingleDepositMin,((RH_DepositeTransferListModel*)self.channelModel.mArrayListModel[selectedQuestion]).mSingleDepositMax];
            [weakSelf.numberCell setupViewWithContext:((RH_DepositeTransferListModel*)self.channelModel.mArrayListModel[selectedQuestion])];
        };
    }
//    [self.contentTableView reloadData];
}
#pragma mark 数据请求

#pragma mark - serviceRequest
-(RH_LoadingIndicateView*)contentLoadingIndicateView
{
//    return self.loadingIndicateTableViewCell.loadingIndicateView ;
    return nil;
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
     _markArray = @[@0,@6,@1,@2,@3,@4,@5];
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
            self.transModelArray  = ConvertToClassPointer(NSArray , data);
            [self loadDataSuccessWithDatas:self.transModelArray?@[self.transModelArray]:@[]
                                totalCount:self.transModelArray?1:0] ;
            [self.contentTableView reloadData];
    }
    else if (type == ServiceRequestTypeV3DepositeOriginChannel)
    {
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            self.channelModel=nil;
            RH_DepositeTransferChannelModel *channelModel = ConvertToClassPointer(RH_DepositeTransferChannelModel, data);
            self.channelModel = channelModel;
            [self loadDataSuccessWithDatas:channelModel?@[channelModel]:@[] totalCount:channelModel?1:0];
            if ([self.depositeCode isEqualToString:@"bitcoin"]) {
                RH_DepositBitcionViewController *bitcionVC = [RH_DepositBitcionViewController viewControllerWithContext:self.channelModel];
                [self showViewController:bitcionVC sender:self];
                self.markArray = @[@0];
            }
            else if ([self.depositeCode isEqualToString:@"online"]) {
                self.numberCell.payMoneyNumLabel.placeholder =[NSString stringWithFormat:@"%ld~%ld",((RH_DepositeTransferListModel*)self.channelModel.mArrayListModel[0]).mSingleDepositMin,((RH_DepositeTransferListModel*)self.channelModel.mArrayListModel[0]).mSingleDepositMax];
            }
            [self.contentTableView reloadData];
        }] ;
    }
    else if (type == ServiceRequestTypeV3DepositOriginSeachSale){
        RH_DepositOriginseachSaleModel *saleModel = ConvertToClassPointer(RH_DepositOriginseachSaleModel, data);
//        self.saleModel = saleModel;
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
        self.circleView.moneyNumLabel.text = self.discountStr;
        [self.circleView setupViewWithContext:saleModel];
        [[UIApplication sharedApplication].keyWindow addSubview:self.circleView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.closeBtn];
    }
    else if (type==ServiceRequestTypeV3OnlinePay){
        if ([data objectForKey:@"data"]) {
            RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
            appDelegate.customUrl =[[data objectForKey:@"data"] objectForKey:@"payLink"] ;
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self showViewController:[RH_CustomViewController viewController] sender:self] ;
            }) ;
           
        }else
        {
            showMessage(self.circleView, @"存款失败", nil);
        }
        
    }
    else if (type==ServiceRequestTypeV3ScanPay){
        if ([data objectForKey:@"data"]) {
            [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
            appDelegate.customUrl =[[data objectForKey:@"data"] objectForKey:@"payLink"] ;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showViewController:[RH_CustomViewController viewController] sender:self] ;
            }) ;
        }] ;
        }else
        {
            [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showMessage(self.view, @"付款失败", nil);
            }] ;
        }
    }
    
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    if (type == ServiceRequestTypeV3DepositeOrigin) {
         [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }
    else if (type == ServiceRequestTypeV3DepositOriginSeachSale){
        
    }
    else if (type==ServiceRequestTypeV3OnlinePay){

        showErrorMessage(self.circleView, error, @"存款失败");
    }
    else if (type==ServiceRequestTypeV3ScanPay){
        showErrorMessage(self.circleView, error, @"存款失败");
    }
}
#pragma mark -键盘监听方法
- (void)keyboardWasShown:(NSNotification *)notification
{
   [self.contentTableView setContentOffset:CGPointMake(0,200) animated:YES];
}
-(void)hideKeyboard{
    [self.numberCell.payMoneyNumLabel resignFirstResponder];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated] ;
    [self.contentTableView setContentOffset:CGPointMake(0,0) animated:YES];
    [self.circleView removeFromSuperview];
    [self.closeBtn removeFromSuperview];
    [self.successAlertView removeFromSuperview];
}
- (void)keyboardWillBeHiden:(NSNotification *)notification
{
//    self.textFiledScrollView.frame = CGRectMake(0, 64, kViewWidth, 455.5);
    // 获取键盘的高度
   [self.contentTableView setContentOffset:CGPointMake(0,0) animated:YES];
    
}


@end
