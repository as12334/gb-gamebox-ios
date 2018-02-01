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

typedef NS_ENUM(NSInteger,WithdrawCashStatus ) {
    WithdrawCashStatus_Init              = 0    ,
    WithdrawCashStatus_NotEnoughCash            ,
    WithdrawCashStatus_EnterCash                ,
    WithdrawCashStatus_EnterBitCoin             ,
    WithdrawCashStatus_HasOrder                 ,
};

@interface RH_WithdrawCashController ()<CLTableViewManagementDelegate,WithdrawMoneyLowCellDelegate>
@property (nonatomic,strong,readonly) CLTableViewManagement *tableViewManagement;
@property (nonatomic,strong,readonly) UISegmentedControl *mainSegmentControl ;
@property (nonatomic, strong, readonly) UIView  *footerView;
@property (nonatomic, strong) UIButton *button_Submit;
@property (nonatomic, strong) UIButton *button_Check;
@property (nonatomic,strong) RH_WithDrawModel *withDrawModel ;
@property (nonatomic, strong) RH_WithdrawCashTwoCell *cashCell;
@end

@implementation RH_WithdrawCashController
{
    WithdrawCashStatus _withdrawCashStatus ;
}

@synthesize tableViewManagement = _tableViewManagement;
@synthesize mainSegmentControl = _mainSegmentControl  ;
@synthesize footerView = _footerView;
@synthesize cashCell = _cashCell;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"取款";
    _withdrawCashStatus = WithdrawCashStatus_Init ;
    [self setNeedUpdateView] ;
    [self setupInfo] ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:RHNT_AlreadySuccessAddBankCardInfo object:nil] ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:RHNT_AlreadySuccessfulAddBitCoinInfo object:nil] ;
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
    [self.contentView addSubview:self.mainSegmentControl];
    self.mainSegmentControl.whc_TopSpace(84).whc_CenterX(0).whc_Width(180).whc_Height(35);
    self.contentTableView.whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0).whc_TopSpace(100);
    
    self.mainSegmentControl.hidden = YES;
    self.contentTableView.tableFooterView = nil;
}

#pragma mark- handleNotification
-(void)handleNotification:(NSNotification*)nt
{
    if ([nt.name isEqualToString:RHNT_AlreadySuccessAddBankCardInfo] ||
        [nt.name isEqualToString:RHNT_AlreadySuccessfulAddBitCoinInfo]){
        [self showProgressIndicatorViewWithAnimated:YES title:@"数据更新中..."];
        [self.serviceRequest startV3GetWithDraw] ;
    }
}

#pragma mark - CashCell
- (RH_WithdrawCashTwoCell *)cashCell {
    if (_cashCell == nil) {
        _cashCell = ConvertToClassPointer(RH_WithdrawCashTwoCell, [self.tableViewManagement cellViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]);
    }
    return _cashCell;
}

#pragma mark - footerView
- (UIView *)footerView {
    
    if (_footerView == nil) {
        _footerView = [UIView new];
        _footerView.frame = CGRectMake(0, 0, screenSize().width, 150);
        
        self.button_Submit = [UIButton new];
        [_footerView addSubview:self.button_Submit];
        self.button_Submit.whc_LeftSpace(20).whc_RightSpace(20).whc_TopSpace(40).whc_Height(40);
        self.button_Submit.layer.cornerRadius = 5;
        self.button_Submit.clipsToBounds = YES;
        [self.button_Submit setTitle:@"确认提交" forState:UIControlStateNormal];
        [self.button_Submit addTarget:self action:@selector(buttonConfirmHandle) forControlEvents:UIControlEventTouchUpInside];
        self.button_Submit.backgroundColor = colorWithRGB(27, 117, 217);
        self.button_Check = [UIButton new];
        [_footerView addSubview:self.button_Check];
        self.button_Check.whc_TopSpace(10).whc_RightSpace(5).whc_Height(20).whc_Width(70);
        [self.button_Check setTitle:@"查看稽核" forState:UIControlStateNormal];
        [self.button_Check addTarget:self action:@selector(buttonCheckHandle) forControlEvents:UIControlEventTouchUpInside];
        [self.button_Check setTitleColor:colorWithRGB(27, 117, 217) forState:UIControlStateNormal];
        self.button_Check.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.button_Check.titleLabel setFont:[UIFont systemFontOfSize:12]];
    }
    return _footerView;
}

- (void)buttonCheckHandle {
    
    self.appDelegate.customUrl = _withDrawModel.mAuditLogUrl;
    [self showViewController:[RH_CustomViewController viewController] sender:nil];
}

- (void)buttonConfirmHandle {
    
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
    
    if (self.cashCell.textField.text.length == 0 ) {
        showMessage(self.view, @"", @"请输入取款金额");
        return;
    }
    if (amountValue <self.withDrawModel.mWithdrawMinNum ||
        amountValue >self.withDrawModel.mWithdrawMaxNum) {
        showMessage(self.view, @"请重新输入", [NSString stringWithFormat:@"金额有效范围为【%8.2f-%8.2f】",self.withDrawModel.mWithdrawMinNum,self.withDrawModel.mWithdrawMaxNum]);
        return;
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
}

#pragma mark - mainSegmentControl
-(UISegmentedControl *)mainSegmentControl
{
    if (!_mainSegmentControl){
        _mainSegmentControl = [[UISegmentedControl alloc] init] ;
        _mainSegmentControl.tintColor = colorWithRGB(27, 117, 217);
        [_mainSegmentControl insertSegmentWithTitle:@"银行卡账户" atIndex:0 animated:YES];
        [_mainSegmentControl insertSegmentWithTitle:@"比特币账户" atIndex:1 animated:YES];
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
        self.mainSegmentControl.hidden = YES;
        self.contentTableView.tableFooterView =  nil;
    }else {
        [self.contentLoadingIndicateView hiddenView] ;
        
        if (_withdrawCashStatus==WithdrawCashStatus_NotEnoughCash){
            [self.tableViewManagement reloadDataWithPlistName:@"WithdrawCashLow"] ;
            self.mainSegmentControl.hidden = YES;
            self.contentTableView.tableFooterView = nil;
            return ;
        }else {
            self.mainSegmentControl.hidden = NO;
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
    self.myTabBarController.selectedIndex = 0 ;
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
        withDrawLowCell.delegate  = self ;
    }
    if ([cell isKindOfClass:[RH_WithdrawCashThreeCell class]] && indexPath.row == 3) {
        RH_WithdrawCashThreeCell *three = ConvertToClassPointer(RH_WithdrawCashThreeCell, cell);
        three.separatorInset = UIEdgeInsetsMake(0, 0, 00, 0);
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
    if (indexPath.section==0){
        if (_withdrawCashStatus==WithdrawCashStatus_EnterCash){
            return [self.withDrawModel.mBankcardMap objectForKey:@"1"] ;
        }else if (_withdrawCashStatus==WithdrawCashStatus_EnterBitCoin) {
            if (MineSettingInfo.mBitCode.mBtcNumber){
                return @{@"title":@"比特币地址",
                         @"detailTitle":MineSettingInfo.mBitCode.mBtcNumber?:@""
                             };
            }else{
                return @{@"title":@"请先绑定比特币地址",
                         };
            }
        }
    }else if (indexPath.section==2){
        switch (indexPath.item) {
            case 0: //手续费
            {
                return self.withDrawModel.mAuditMap.mCounterFee==0.00?@"免手续费":
                [NSString stringWithFormat:@"%.02f",self.withDrawModel.mAuditMap.mCounterFee] ;
            }
                break;
            
            case 1: ////行政费
            {
                return [NSString stringWithFormat:@"%.02f",self.withDrawModel.mAuditMap.mAdministrativeFee] ;
            }
                break;
            
            case 2: //扣除优惠
            {
                return [NSString stringWithFormat:@"%.02f",self.withDrawModel.mAuditMap.mDeductFavorable] ;
            }
                break;
            
            case 3: //最终可取
            {
                return [NSString stringWithFormat:@"%.02f",self.withDrawModel.mAuditMap.mWithdrawAmount] ;
            }
                break;
                
            default:
                break;
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
    }
    if (type == ServiceRequestTypeV3SubmitWithdrawInfo) {
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:nil] ;
        
        //提交成功
        UIAlertView *alertView = [UIAlertView alertWithCallBackBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex==1){
                [self showViewController:[RH_CapitalRecordViewController viewControllerWithContext:nil] sender:nil];
                _withdrawCashStatus = WithdrawCashStatus_HasOrder ;
                 [self setNeedUpdateView];
            }else{
                [self backBarButtonItemHandle] ;
            }
        } title:@"提示信息"
                                                             message:@"取款提交成功"
                                                    cancelButtonName:@"好的"
                                                   otherButtonTitles:@"资金记录", nil] ;
        
        [alertView show] ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3GetWithDrawInfo){
        if (error.code == 100) {
            //已有订单在处理。。。
            _withdrawCashStatus = WithdrawCashStatus_HasOrder;
            [self setNeedUpdateView];
        }else if (error.code == 102) { //金额不足
            _withdrawCashStatus = WithdrawCashStatus_NotEnoughCash ;
            [self setNeedUpdateView] ;
        }else{
            [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
        }
    }else if (type == ServiceRequestTypeV3SubmitWithdrawInfo) {
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showMessage(self.contentView, error.localizedDescription, error.userInfo[@"msg"]);
        }] ;
        
        NSDictionary *userInfo = error.userInfo ;
        NSString *token = [userInfo stringValueForKey:@"token"] ;
        [self.withDrawModel updateToken:token] ;
    }
}

@end
