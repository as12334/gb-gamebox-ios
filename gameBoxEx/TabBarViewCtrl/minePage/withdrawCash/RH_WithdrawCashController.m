//
//  RH_WithdrawCashController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//
#import "RH_CapitalRecordViewController.h"
#import "RH_WithdrawCashController.h"
#import "coreLib.h"
#import "PXAlertView+Customization.h"
#import "RH_WithdrawAddBitCoinAddressController.h"
#import "RH_UserInfoManager.h"
#import "RH_WithdrawMoneyLowCell.h"
#import "RH_WithDrawModel.h"
#import "RH_CustomViewController.h"
#import "RH_WithdrawCashTwoCell.h"
#import "RH_UserInfoManager.h"
#import "RH_BitCoinController.h"
#import "RH_BankCardController.h"
#import "RH_ModifySafetyPasswordController.h"
#import "RH_BankCardController.h"
#import "RH_WithdrawCashThreeCell.h"
#import "RH_NavigationUserInfoView.h"
#import "GameWebViewController.h"
#import "RH_JiHeViewController.h"
typedef NS_ENUM(NSInteger,WithdrawCashStatus ) {
    WithdrawCashStatus_Init              = 0    ,
    WithdrawCashStatus_NotEnoughCash            ,
    WithdrawCashStatus_EnterCash                ,
    WithdrawCashStatus_EnterBitCoin             ,
    WithdrawCashStatus_HasOrder                 ,
};

@interface RH_WithdrawCashController ()<CLTableViewManagementDelegate,WithdrawMoneyLowCellDelegate,WithdrawCashTwoCellDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong,readonly) CLTableViewManagement *tableViewManagement;
@property (nonatomic,strong,readonly) UISegmentedControl *mainSegmentControl ;
@property (nonatomic, strong, readonly) UIView  *footerView;
@property (nonatomic, strong) UIButton *button_Submit;
@property (nonatomic, strong) UIButton *button_Check;
@property (nonatomic,strong) RH_WithDrawModel *withDrawModel ;
@property (nonatomic, strong) RH_WithdrawCashTwoCell *cashCell;
@property (nonatomic,strong) RH_NavigationUserInfoView *userInfoBtnView ;
@end

@implementation RH_WithdrawCashController

{
    WithdrawCashStatus _withdrawCashStatus ;
    
    //记录两种类型的--
    CGFloat _bankWithdrawAmount     ; //记录银行卡 取款金额
    CGFloat _bitCoinWithdrawAmount  ; //记录比特币 取款金额
    NSString *_withDrawMinMoneyStr ;  //在钱包没有钱的情况下返回的提示
    AuditMapModel *auditMap ;
}
@synthesize userInfoBtnView = _userInfoBtnView ;
@synthesize tableViewManagement = _tableViewManagement;
@synthesize mainSegmentControl = _mainSegmentControl  ;
@synthesize footerView = _footerView;
@synthesize cashCell = _cashCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIBarButtonItem *itembar = [[UIBarButtonItem alloc]initWithCustomView:self.userInfoBtnView];
//    self.navigationBarItem.rightBarButtonItem = itembar;
      self.hiddenNavigationBar = YES;
//    self.title = @"取款";
    _withdrawCashStatus = WithdrawCashStatus_Init ;
    [self setNeedUpdateView] ;
    [self setupInfo] ;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:)
                                                 name:RHNT_AlreadySuccessAddBankCardInfo object:nil] ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:RHNT_AlreadySuccessfulAddBitCoinInfo object:nil] ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil] ;
    
    //关闭键盘
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}
//会影响cell的点击
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

- (void)setupInfo {
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO];
    
    [self.contentView addSubview:self.contentTableView];
    [self.tableViewManagement reloadData];
    self.contentTableView.tableFooterView = [self footerView];
    self.contentView.backgroundColor = colorWithRGB(242, 242, 242);
//    self.contentTableView.tableFooterView = nil;
}
#pragma mark - userInfoView
-(RH_NavigationUserInfoView *)userInfoBtnView
{
    if (!_userInfoBtnView){
        _userInfoBtnView = [RH_NavigationUserInfoView createInstance] ;
//        [_userInfoBtnView.buttonCover addTarget:self
//                                         action:@selector(_userInfoBtnViewHandle) forControlEvents:UIControlEventTouchUpInside] ;
        _userInfoBtnView.frame = CGRectMake(0, 0, _userInfoBtnView.labBalance.frame.size.width + 20, 40.0f) ;
    }
    
    return _userInfoBtnView ;
}
//+(void)configureNavigationBar:(UINavigationBar *)navigationBar
//{
//    if ([SITE_TYPE isEqualToString:@"integratedv3oc"] ){
//        navigationBar.barStyle = UIBarStyleDefault ;
//        if (GreaterThanIOS11System){
//            if ([THEMEV3 isEqualToString:@"green"]){
//                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green ;
//            }else if ([THEMEV3 isEqualToString:@"red"]){
//                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red ;
//            }else if ([THEMEV3 isEqualToString:@"black"]){
//                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Black ;
//            }else if ([THEMEV3 isEqualToString:@"blue"]){
//                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Blue ;
//            }else if ([THEMEV3 isEqualToString:@"orange"]){
//                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange ;
//            }else if ([THEMEV3 isEqualToString:@"red_white"]){
//                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red_White ;
//            }else if ([THEMEV3 isEqualToString:@"green_white"]){
//                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green_White ;
//            }else if ([THEMEV3 isEqualToString:@"orange_white"]){
//                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange_White ;
//            }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
//                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_White ;
//            }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
//                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_Black ;
//            }else{
//                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor ;
//            }
//        }else
//        {
//            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
//            [navigationBar insertSubview:backgroundView atIndex:0] ;
//            if ([THEMEV3 isEqualToString:@"green"]){
//                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Green ;
//            }else if ([THEMEV3 isEqualToString:@"red"]){
//                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Red ;
//            }else if ([THEMEV3 isEqualToString:@"black"]){
//                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Black ;
//            }else if ([THEMEV3 isEqualToString:@"blue"]){
//                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Blue ;
//            }else if ([THEMEV3 isEqualToString:@"orange"]){
//                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Orange ;
//            }else if ([THEMEV3 isEqualToString:@"red_white"]){
//                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red_White ;
//            }else if ([THEMEV3 isEqualToString:@"green_white"]){
//                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green_White ;
//            }else if ([THEMEV3 isEqualToString:@"orange_white"]){
//                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange_White ;
//            }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
//                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_White ;
//            }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
//                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_Black ;
//            }else{
//                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor ;
//            }
//        }
//        
//        navigationBar.titleTextAttributes = @{NSFontAttributeName:RH_NavigationBar_TitleFontSize,
//                                              NSForegroundColorAttributeName:RH_NavigationBar_ForegroundColor} ;
//    }else{
//        navigationBar.barStyle = UIBarStyleDefault ;
//        if (GreaterThanIOS11System){
//            navigationBar.barTintColor = [UIColor blackColor];
//        }else
//        {
//            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
//            [navigationBar insertSubview:backgroundView atIndex:0] ;
//            backgroundView.backgroundColor = [UIColor blackColor] ;
//        }
//        
//        navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0f],
//                                              NSForegroundColorAttributeName:[UIColor whiteColor]} ;
//    }
//}

#pragma mark- handleNotification
-(void)handleNotification:(NSNotification*)nt
{
    if ([nt.name isEqualToString:RHNT_AlreadySuccessAddBankCardInfo] ||
        [nt.name isEqualToString:RHNT_AlreadySuccessfulAddBitCoinInfo]){
        [self showProgressIndicatorViewWithAnimated:YES title:@"数据更新中..."];
        [self.serviceRequest startV3GetWithDraw] ;
    }else if ([nt.name isEqualToString:UITextFieldTextDidChangeNotification]){
        UITextField *textF = ConvertToClassPointer(UITextField, nt.object) ;
        // UITextField 条件判断
        if (textF && [textF isMemberOfClass:[UITextField class]] && textF.tag !=998 && textF.tag != 999){
            if (self.mainSegmentControl.selectedSegmentIndex){
                _bitCoinWithdrawAmount = [textF.text floatValue] ;
            }else
            {
                _bankWithdrawAmount = [textF.text floatValue] ;
            }
        }
    }
}

#pragma mark - CashCell
- (RH_WithdrawCashTwoCell *)cashCell {
    if (_cashCell == nil) {
        _cashCell = ConvertToClassPointer(RH_WithdrawCashTwoCell, [self.tableViewManagement cellViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]);
    }
    return _cashCell;
}

-(void)withdrawCashTwoCellDidTouchDONE:(RH_WithdrawCashTwoCell*)withdrawCashCell
{
    if (self.cashCell.textField.text.trim.length){
        CGFloat amountValue = [self.cashCell.textField.text.trim floatValue] ;
        
        if (amountValue <self.withDrawModel.mWithdrawMinNum ||
            amountValue >self.withDrawModel.mWithdrawMaxNum) {
            showMessage(self.view, @"请重新输入", [NSString stringWithFormat:@"金额有效范围为【%.2f-%.2f】",self.withDrawModel.mWithdrawMinNum,self.withDrawModel.mWithdrawMaxNum]);
            return;
        }
        
        AuditMapModel *auditMap = [self.withDrawModel.withDrawFeeDict objectForKey:self.cashCell.textField.text.trim] ;
        if (auditMap==nil){
            //计算费率信息
            [self showProgressIndicatorViewWithAnimated:YES title:@"计算费用..."];
            [self.serviceRequest startV3WithDrawFeeWithAmount:amountValue] ;
            return ;
        }
        
        [self setNeedUpdateView] ;
    }else{
        showMessage(self.view, @"", @"请输入取款金额");
        [self setNeedUpdateView] ;
        return;
    }
}

#pragma mark - footerView
- (UIView *)footerView {
    
    if (_footerView == nil) {
        _footerView = [UIView new];
        _footerView.frame = CGRectMake(0, 0, screenSize().width, 150);
        self.button_Check = [UIButton new];
        self.button_Submit = [UIButton new];
        [_footerView addSubview:self.button_Submit];
        self.button_Submit.whc_LeftSpace(20).whc_RightSpace(20).whc_TopSpace(40).whc_Height(40);
        self.button_Submit.layer.cornerRadius = 5;
        self.button_Submit.clipsToBounds = YES;
        [self.button_Submit setTitle:@"确认提交" forState:UIControlStateNormal];
        [self.button_Submit addTarget:self action:@selector(buttonConfirmHandle) forControlEvents:UIControlEventTouchUpInside];
        self.button_Check = [UIButton new];
        if ([THEMEV3 isEqualToString:@"green"]){
            self.button_Submit.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
            [self.button_Check setTitleColor:RH_NavigationBar_BackgroundColor_Green forState:UIControlStateNormal];
        }else if ([THEMEV3 isEqualToString:@"red"]){
            self.button_Submit.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
            [self.button_Check setTitleColor:RH_NavigationBar_BackgroundColor_Red forState:UIControlStateNormal];
        }else if ([THEMEV3 isEqualToString:@"black"]){
            self.button_Submit.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
            [self.button_Check setTitleColor:RH_NavigationBar_BackgroundColor_Black forState:UIControlStateNormal];
        }else if ([THEMEV3 isEqualToString:@"blue"]){
            self.button_Submit.backgroundColor = RH_NavigationBar_BackgroundColor_Blue;
            [self.button_Check setTitleColor:RH_NavigationBar_BackgroundColor_Blue forState:UIControlStateNormal];
        }else if ([THEMEV3 isEqualToString:@"orange"]){
            self.button_Submit.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
            [self.button_Check setTitleColor:RH_NavigationBar_BackgroundColor_Red forState:UIControlStateNormal];
        }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
            self.button_Submit.backgroundColor = RH_NavigationBar_BackgroundColor_Coffee_Black;
            [self.button_Check setTitleColor:RH_NavigationBar_BackgroundColor_Coffee_Black forState:UIControlStateNormal];
        }else{
            self.button_Submit.backgroundColor = RH_NavigationBar_BackgroundColor_Orange;
            [self.button_Check setTitleColor:RH_NavigationBar_BackgroundColor_Orange forState:UIControlStateNormal];
        }
        
        [_footerView addSubview:self.button_Check];
        self.button_Check.whc_TopSpace(10).whc_RightSpace(5).whc_Height(20).whc_Width(70);
        [self.button_Check setTitle:@"查看稽核" forState:UIControlStateNormal];
        [self.button_Check addTarget:self action:@selector(buttonCheckHandle) forControlEvents:UIControlEventTouchUpInside];
        
        self.button_Check.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.button_Check.titleLabel setFont:[UIFont systemFontOfSize:12]];
    }
    return _footerView;
}

- (void)buttonCheckHandle {
    
//    GameWebViewController *gameViewController = [[GameWebViewController alloc] initWithNibName:nil bundle:nil];
//    NSString *checkType = [[self.appDelegate.checkType componentsSeparatedByString:@"+"] firstObject];
//    
//    RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
//    NSString *url;
//    if (appDelegate.demainName.length > 0) {
//        url = [NSString stringWithFormat:@"%@://%@%@",checkType,self.appDelegate.demainName,_withDrawModel.mAuditLogUrl];
//    } else {
//         url = [NSString stringWithFormat:@"%@://%@%@",checkType,self.appDelegate.headerDomain,_withDrawModel.mAuditLogUrl];
//    }
//    gameViewController.url = url;
//    [self.navigationController pushViewController:gameViewController animated:YES];
    
    RH_JiHeViewController *vc = [[RH_JiHeViewController alloc]init];
      [self.navigationController pushViewController:vc animated:YES];

//    self.appDelegate.customUrl = _withDrawModel.mAuditLogUrl;
//    [self showViewController:[RH_CustomViewController viewControllerWithContext:self.withDrawModel] sender:nil];
}

- (void)buttonConfirmHandle {
    if (self.appDelegate.isLogin) {
        [self.cashCell.textField resignFirstResponder] ;
        CGFloat amountValue = [self.cashCell.textField.text.trim floatValue] ;
        if (self.mainSegmentControl.selectedSegmentIndex==0){
            if ([self _checkShowBankCardInfo:YES]) {
                return ;
            }
        }else{
            if ([self _checkShowBitCoinInfo:YES]) {
                return ;
            }
        }
        
        if (self.cashCell.textField.text.trim.length == 0 ) {
            showMessage(self.view, @"", @"请输入取款金额");
            return;
        }
        
        if (amountValue <self.withDrawModel.mWithdrawMinNum ||
            amountValue >self.withDrawModel.mWithdrawMaxNum) {
            showMessage(self.view, @"请重新输入", [NSString stringWithFormat:@"金额有效范围为【%.2f-%.2f】",self.withDrawModel.mWithdrawMinNum,self.withDrawModel.mWithdrawMaxNum]);
            return;
        }
        
        auditMap = [self.withDrawModel.withDrawFeeDict objectForKey:self.cashCell.textField.text.trim] ;
        if (auditMap==nil){
            //计算费率信息
            [self showProgressIndicatorViewWithAnimated:YES title:@"计算费用..."];
            [self.serviceRequest startV3WithDrawFeeWithAmount:amountValue] ;
            return ;
        }
        
        //检测最终可取 金额是否大于 0
        if (auditMap.mActualWithdraw<=0){
            showMessage(self.view, @"提示信息",@"实际取款金额应大于零");
            return ;
        }
        
        //检测取款余额是否大于钱包余额
        if (amountValue>MineSettingInfo.mWalletBalance){
            showMessage(self.view, @"提示信息",@"取款金额应小于钱包余额!");
            return ;
        }
        
        //检测是否有设置安全密码
        if (self.withDrawModel.mIsSafePassword==false){
            showAlertView(@"安全提示", @"请设置安全密码") ;
            [self showViewController:[RH_ModifySafetyPasswordController viewControllerWithContext:@"设置安全密码"] sender:self] ;
            return ;
        }
        
        
        //安全密码提示框
        UIAlertView *alert = [UIAlertView alertWithCallBackBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex==1){//确认
                NSString *safetyPass =  [alertView textFieldAtIndex:0].text ;
                if (safetyPass.length){
                    [self showProgressIndicatorViewWithAnimated:YES title:@"提交中..."];
                    //（1：银行卡，2：比特币）
                    [self.serviceRequest startV3SubmitWithdrawAmount:amountValue
                                                           SafetyPwd:safetyPass
                                                             gbToken:self.withDrawModel.mToken
                                                            CardType:self.mainSegmentControl.selectedSegmentIndex+1] ;
                    
                }
            }
        }
                                                           title:nil
                                                         message:@"请输入安全密码"
                                                cancelButtonName:@"取消"
                                               otherButtonTitles:@"确认", nil] ;
        alert.alertViewStyle = UIAlertViewStyleSecureTextInput ;
        [alert show];
    }else
    {
        showMessage_b(self.view, nil, @"您的账号在另一设备登录！", ^{
            [self loginButtonItemHandle] ;
        });
    }
}

#pragma mark - mainSegmentControl
-(UISegmentedControl *)mainSegmentControl
{
    if (!_mainSegmentControl){
        _mainSegmentControl = [[UISegmentedControl alloc] init] ;
        if ([THEMEV3 isEqualToString:@"green"]){
            self.button_Submit.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
            _mainSegmentControl.tintColor = RH_NavigationBar_BackgroundColor_Green;
            [self.button_Check setTitleColor:RH_NavigationBar_BackgroundColor_Green forState:UIControlStateNormal];
        }else if ([THEMEV3 isEqualToString:@"red"]){
            self.button_Submit.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
            [self.button_Check setTitleColor:RH_NavigationBar_BackgroundColor_Red forState:UIControlStateNormal];
            _mainSegmentControl.tintColor = RH_NavigationBar_BackgroundColor_Red;
            
        }else if ([THEMEV3 isEqualToString:@"black"]){
//            _mainSegmentControl.tintColor = RH_NavigationBar_BackgroundColor_Black;
//            self.button_Submit.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
//            [self.button_Check setTitleColor:RH_NavigationBar_BackgroundColor_Black forState:UIControlStateNormal];
            _mainSegmentControl.tintColor = RH_NavigationBar_BackgroundColor;
            self.button_Submit.backgroundColor = RH_NavigationBar_BackgroundColor;
            [self.button_Check setTitleColor:RH_NavigationBar_BackgroundColor forState:UIControlStateNormal];
        }else if ([THEMEV3 isEqualToString:@"blue"]){
            self.button_Submit.backgroundColor = RH_NavigationBar_BackgroundColor_Blue;
            [self.button_Check setTitleColor:RH_NavigationBar_BackgroundColor_Blue forState:UIControlStateNormal];
            _mainSegmentControl.tintColor = RH_NavigationBar_BackgroundColor_Blue;
            
        }else if ([THEMEV3 isEqualToString:@"orange"]){
            self.button_Submit.backgroundColor = RH_NavigationBar_BackgroundColor_Orange;
            [self.button_Check setTitleColor:RH_NavigationBar_BackgroundColor_Orange forState:UIControlStateNormal];
            _mainSegmentControl.tintColor = RH_NavigationBar_BackgroundColor_Orange;
            
        }else{
            _mainSegmentControl.tintColor = RH_NavigationBar_BackgroundColor;
            self.button_Submit.backgroundColor = RH_NavigationBar_BackgroundColor;
            [self.button_Check setTitleColor:RH_NavigationBar_BackgroundColor forState:UIControlStateNormal];
        }
        if (self.withDrawModel.mIsBit==true) {
            [_mainSegmentControl insertSegmentWithTitle:@"银行卡账户" atIndex:0 animated:YES];
            [_mainSegmentControl insertSegmentWithTitle:@"比特币账户" atIndex:1 animated:YES];
        }
        else
        {
             [_mainSegmentControl insertSegmentWithTitle:@"银行卡账户" atIndex:0 animated:YES];
        }
        
        _mainSegmentControl.selectedSegmentIndex = 0;
        [_mainSegmentControl addTarget:self action:@selector(segmentControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _mainSegmentControl ;
}

- (void)segmentControlValueDidChange:(UISegmentedControl *)segmentControl {
    
    _withdrawCashStatus = segmentControl.selectedSegmentIndex?WithdrawCashStatus_EnterBitCoin:WithdrawCashStatus_EnterCash ;
    [self setNeedUpdateView] ;
}


#pragma mark- updateView
-(void)updateView
{
    if (_withdrawCashStatus==WithdrawCashStatus_Init){
        [self.tableViewManagement reloadDataWithPlistName:@"WithdrawInit"] ;
        [self loadingIndicateViewDidTap:nil] ;
        return ;
    }else if (_withdrawCashStatus == WithdrawCashStatus_HasOrder) {
        [self.contentLoadingIndicateView hiddenView] ;
        [self.tableViewManagement reloadDataWithPlistName:@"WithdrawCashHasOrder"];
        self.contentTableView.tableFooterView =  nil;
        
        if (_mainSegmentControl.superview){
            [_mainSegmentControl removeFromSuperview] ;
            _mainSegmentControl = nil ;
            [self.contentTableView  whc_ResetConstraints] ;
            self.contentTableView.whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0).whc_TopSpace(0);
        }
    }else {
        [self.contentLoadingIndicateView hiddenView] ;
        if (_withdrawCashStatus==WithdrawCashStatus_NotEnoughCash){
            [self.tableViewManagement reloadDataWithPlistName:@"WithdrawCashLow"] ;
            self.contentTableView.tableFooterView = nil;
            
            if (_mainSegmentControl.superview){
                [_mainSegmentControl removeFromSuperview] ;
                _mainSegmentControl = nil ;
                [self.contentTableView  whc_ResetConstraints] ;
                self.contentTableView.whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0).whc_TopSpace(100);
            }
            
            return ;
        }else {
            if (_mainSegmentControl.superview==nil){
                [self.contentView addSubview:self.mainSegmentControl];
                CGFloat h=0;
                if (self.withDrawModel.mIsBit==true) {
                    h = 84;
                }
                
                self.mainSegmentControl.whc_TopSpace(h).whc_CenterX(0).whc_Width(180).whc_Height(35);
                self.contentTableView.whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0).whc_TopSpace(h+16);
            }
            
            self.contentTableView.tableFooterView = self.footerView;
            
            if (_withdrawCashStatus==WithdrawCashStatus_EnterCash){
                [self.tableViewManagement reloadDataWithPlistName:@"WithdrawCash"] ;
                [self _checkShowBankCardInfo:YES] ;
                return ;
            }else{
                [self.tableViewManagement reloadDataWithPlistName:@"WithdrawCashBitCoin"] ;
                [self _checkShowBitCoinInfo:YES] ;
                return ;
            }
        }
    }
}

-(BOOL)_checkShowBankCardInfo:(BOOL)showAlert
{
    BankcardMapModel * bankCardModel = ConvertToClassPointer(BankcardMapModel,[self.withDrawModel.mBankcardMap objectForKey:@"1"]) ;
    if (bankCardModel.mBankcardNumber.length==0){
        if (showAlert){
            UIAlertView *alert = [UIAlertView alertWithCallBackBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex==1){
                    [self showViewController:[RH_BankCardController viewControllerWithContext:@"绑定银行卡"] sender:self] ;
                }
            } title:@"请先绑定银行卡"
                                                             message:nil cancelButtonName:@"取消" otherButtonTitles:@"立即绑定", nil] ;
            [alert show] ;
        }else{
            [self showViewController:[RH_BankCardController viewControllerWithContext:@"绑定银行卡"] sender:self] ;
        }
        
        return YES ;
    }
    
    return NO ;
}

-(BOOL)_checkShowBitCoinInfo:(BOOL)showAlert
{
    BankcardMapModel * bankCardModel = ConvertToClassPointer(BankcardMapModel,[self.withDrawModel.mBankcardMap objectForKey:@"2"]) ;
    if (bankCardModel.mBankcardNumber.length==0){
        if (showAlert){
            UIAlertView *alert = [UIAlertView alertWithCallBackBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex==1){
                    [self showViewController:[RH_BitCoinController viewControllerWithContext:@"绑定比特币地址"] sender:self] ;
                }
            } title:@"请先绑定比特币地址"
                                                             message:nil cancelButtonName:@"取消" otherButtonTitles:@"立即绑定", nil] ;
            [alert show] ;
        }else{
            [self showViewController:[RH_BitCoinController viewControllerWithContext:@"绑定比特币地址"] sender:self] ;
        }
        
        return YES ;
    }
    
    return NO ;
}

#pragma mark- contentLoadingIndicateView
-(RH_LoadingIndicateView*)contentLoadingIndicateView
{
    return self.loadingIndicateTableViewCell.loadingIndicateView ;
}


- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:@"初始化取款信息" detailText:@"请稍等"] ;
    [self.serviceRequest startV3GetWithDraw] ;
}

#pragma mark - RH_WithdrawMoneyLowCell
-(void)withdrawMoneyLowCellDidTouchQuickButton:(RH_WithdrawMoneyLowCell*)withdrawLowCell
{
    [self backBarButtonItemHandle] ;
    self.myTabBarController.selectedIndex = 1 ;
}
#pragma mark ==============一键回收================
-(void)withdrawMoneyLowCellDidTouchRecycleButton:(RH_WithdrawMoneyLowCell *)withdrawLowCell
{
    [self showProgressIndicatorViewWithAnimated:YES title:@"数据处理中"] ;
    [self.serviceRequest startV3OneStepRecoverySearchId:nil]  ;
}
#pragma mark- tableview Managentment
- (CLTableViewManagement *)tableViewManagement {
    if (_tableViewManagement == nil) {
        _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView configureFileName:@"RH_WithdrawCash" bundle:nil];
        _tableViewManagement.delegate = self;
    }
    return _tableViewManagement;
}

-(void)tableViewManagement:(CLTableViewManagement *)tableViewManagement IndexPath:(NSIndexPath *)indexPath Cell:(UITableViewCell*)cell
{
    if ([cell isKindOfClass:[RH_WithdrawMoneyLowCell class]]){
        RH_WithdrawMoneyLowCell *withDrawLowCell = ConvertToClassPointer(RH_WithdrawMoneyLowCell, cell) ;
        [withDrawLowCell updateCellWithInfo:nil context:_withDrawMinMoneyStr] ;
        withDrawLowCell.delegate  = self ;
    }else if ([cell isKindOfClass:[RH_WithdrawCashThreeCell class]] && indexPath.row == 3) {
        RH_WithdrawCashThreeCell *three = ConvertToClassPointer(RH_WithdrawCashThreeCell, cell);
        three.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }else if ([cell isKindOfClass:[RH_WithdrawCashTwoCell class]]) {
        RH_WithdrawCashTwoCell *withDrawCell = ConvertToClassPointer(RH_WithdrawCashTwoCell, cell);
        withDrawCell.delegate = self ;
    }
}


- (BOOL)tableViewManagement:(CLTableViewManagement *)tableViewManagement didSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_withdrawCashStatus == WithdrawCashStatus_EnterBitCoin) {
        if (indexPath.section == 0) {
            [self _checkShowBitCoinInfo:NO] ;
        }
    }else if (_withdrawCashStatus == WithdrawCashStatus_EnterCash){
        if (indexPath.section == 0) {
            [self _checkShowBankCardInfo:NO] ;
        }
    }
    
    return YES;
}

- (id)tableViewManagement:(CLTableViewManagement *)tableViewManagement cellContextAtIndexPath:(NSIndexPath *)indexPath
{
    if (_withdrawCashStatus == WithdrawCashStatus_EnterCash || _withdrawCashStatus ==  WithdrawCashStatus_EnterBitCoin){
        if (indexPath.section==0){
            if (_withdrawCashStatus==WithdrawCashStatus_EnterCash){
                return [self.withDrawModel.mBankcardMap objectForKey:@"1"] ;
            }else if (_withdrawCashStatus==WithdrawCashStatus_EnterBitCoin) {
                BankcardMapModel *bankCardModel = ConvertToClassPointer(BankcardMapModel,[self.withDrawModel.mBankcardMap objectForKey:@"2"]) ;
                if (bankCardModel.mBankcardNumber.length){
                    return @{@"title":@"比特币地址",
                             @"detailTitle":bankCardModel.mBankcardNumber?:@""
                                 };
                }else{
                    return @{@"title":@"请先绑定比特币地址",
                             };
                }
            }
        }else if (indexPath.section==1){
            id value =  self.mainSegmentControl.selectedSegmentIndex?@(_bitCoinWithdrawAmount):@(_bankWithdrawAmount) ;
            return value ;
        }else if (indexPath.section==2){
            AuditMapModel *auditMap = nil ;
            if (self.withDrawModel.withDrawFeeDict.count){
                auditMap= [self.withDrawModel.withDrawFeeDict objectForKey:self.cashCell.textField.text.trim?:@""] ;
            }
            
            if (auditMap==nil){
                auditMap = self.withDrawModel.mAuditMap ;
            }
            
            switch (indexPath.item) {
                case 0: //手续费
                {
                    //self.cashCell.textField.text.trim.length>0
                    return ((self.mainSegmentControl.selectedSegmentIndex==0?_bankWithdrawAmount:_bitCoinWithdrawAmount)>0?[NSString stringWithFormat:@"%.02f",auditMap.mCounterFee]:@"") ;

                }
                    break;

                case 1: ////行政费
                {
                    return (self.mainSegmentControl.selectedSegmentIndex==0?_bankWithdrawAmount:_bitCoinWithdrawAmount)>0?[NSString stringWithFormat:@"%.02f",auditMap.mAdministrativeFee]:@"" ;
                }
                    break;

                case 2: //扣除优惠
                {
                    return (self.mainSegmentControl.selectedSegmentIndex==0?_bankWithdrawAmount:_bitCoinWithdrawAmount)>0?[NSString stringWithFormat:@"%.02f",auditMap.mDeductFavorable]:@"" ;
                }
                    break;

                case 3: //最终可取
                {
                    return (self.mainSegmentControl.selectedSegmentIndex==0?_bankWithdrawAmount:_bitCoinWithdrawAmount)>0?[NSString stringWithFormat:@"%.02f",auditMap.mActualWithdraw]:@"" ;
                }
                    break;

                default:
                    break;
            }
        }
    }
    
    return nil ;
}

-(CGFloat)tableViewManagement:(CLTableViewManagement *)tableViewManagement customCellHeightAtIndexPath:(NSIndexPath *)indexPath
{
    return MainScreenH - StatusBarHeight - NavigationBarHeight ;
}

-(UITableViewCell*)tableViewManagement:(CLTableViewManagement *)tableViewManagement customCellAtIndexPath:(NSIndexPath *)indexPath
{
    return self.loadingIndicateTableViewCell ;
}

#pragma mark - serviceRequest
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3GetWithDrawInfo)
    {
        if (self.progressIndicatorView.superview){ //通知更新信息
            [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
                self.withDrawModel = ConvertToClassPointer(RH_WithDrawModel, data) ;
                [self setNeedUpdateView] ;
            }] ;
        }else{
            [self.contentLoadingIndicateView hiddenView] ;
            self.withDrawModel = ConvertToClassPointer(RH_WithDrawModel, data) ;
            _withdrawCashStatus = WithdrawCashStatus_EnterCash ;
            [self setNeedUpdateView] ;
        }
    }else if (type == ServiceRequestTypeV3SubmitWithdrawInfo) {
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:nil] ;
        
        //提交成功
        UIAlertView *alertView = [UIAlertView alertWithCallBackBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex==1){
                [self showViewController:[RH_CapitalRecordViewController viewControllerWithContext:nil] sender:nil];
                _withdrawCashStatus = WithdrawCashStatus_HasOrder ;
            }else{
                [self backBarButtonItemHandle] ;
            }
        } title:@"提示信息"
                                                             message:@"取款提交成功"
                                                    cancelButtonName:@"好的"
                                                   otherButtonTitles:@"资金记录", nil] ;
        
        [alertView show] ;
         [self setNeedUpdateView];
        [self.serviceRequest startV3UserInfo];
    }else if (type == ServiceRequestTypeWithDrawFee){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:nil] ;
        
        if (data){
            [self.withDrawModel.withDrawFeeDict setObject:data forKey:self.cashCell.textField.text.trim?:@""] ;
            [self setNeedUpdateView] ;
        }
    }
    else if (type ==ServiceRequestTypeV3OneStepRecory){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showSuccessMessage(self.view, @"提示信息", [data objectForKey:@"message"]) ;
            [self.serviceRequest startV3GetUserAssertInfo] ;
        }] ;
    }
    else if (type==ServiceRequestTypeV3GETUSERASSERT){
        NSDictionary *dic = ConvertToClassPointer(NSDictionary, data);
        float balance = [dic[@"balance"] floatValue];
        if (balance < 100) {
            _withdrawCashStatus = WithdrawCashStatus_NotEnoughCash;
        }else{
            //重新请求数据
            _withdrawCashStatus  = WithdrawCashStatus_Init;
        }
        
        [self updateView];
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3GetWithDrawInfo){
        if (error.code == RH_API_ERRORCODE_WITHDRAW_HASORDER) {
            //已有订单在处理。。。
            _withdrawCashStatus = WithdrawCashStatus_HasOrder;
            [self setNeedUpdateView];
        }else if (error.code == RH_API_ERRORCODE_WITHDRAW_NO_MONEY) { //金额不足
            NSDictionary *dic = ConvertToClassPointer(NSDictionary, [error userInfo]);
            NSLog(@"是否有银行===%@",dic[@"hasBank"]);
            BOOL hasBank = [dic[@"hasBank"] boolValue];
            if (hasBank) {
                _withdrawCashStatus = WithdrawCashStatus_NotEnoughCash ;
                _withDrawMinMoneyStr = [[error userInfo] objectForKey:@"NSLocalizedDescription"] ;
            }else{
                _withdrawCashStatus = WithdrawCashStatus_EnterCash ;
            }
            
            [self setNeedUpdateView] ;
        }else{
            showMessage(self.view, nil, error.localizedDescription) ;
            [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
            
        }
    }else if (type == ServiceRequestTypeV3SubmitWithdrawInfo) {
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showMessage(self.contentView, error.localizedDescription, error.userInfo[@"msg"]);
        }] ;
        NSDictionary *userInfo = error.userInfo ;
        NSString *token = [userInfo stringValueForKey:@"token"] ;
        [self.withDrawModel updateToken:token] ;
        if (error.code == 1101) {
            [self.navigationController popViewControllerAnimated:YES] ;
        }
    }else if (type == ServiceRequestTypeWithDrawFee){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showErrorMessage(self.view, error, @"费率计算失败") ;
        }] ;
    }
    else if (type==ServiceRequestTypeV3OneStepRecory){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showErrorMessage(self.view, error,nil);
        }];
    }
}

@end
