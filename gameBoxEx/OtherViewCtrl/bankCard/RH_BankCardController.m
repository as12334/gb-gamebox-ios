//
//  RH_BankCardController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//
#import "RH_BankCardNumberCell.h"
#import "RH_BankCardController.h"
#import "coreLib.h"
#import "RH_UserInfoManager.h"
#import "RH_ModifyPasswordCell.h"
#import "RH_BankCardCell.h"
#import "RH_BankPickerSelectView.h"
#import "RH_BankCardRealNameCell.h"
#import "RH_BankCardLocationCell.h"
typedef NS_ENUM(NSInteger,BankCardStatus ) {
    BankCardStatus_Init                        ,
    BankCardStatus_None                        ,
    BankCardStatus_Exist                   ,
};


@interface RH_BankCardController ()<CLTableViewManagementDelegate,BankPickerSelectViewDelegate, RH_ServiceRequestDelegate,UITextFieldDelegate>
@property (nonatomic, strong, readonly) CLTableViewManagement *tableViewManagement;
@property (nonatomic,strong, readonly)  RH_BankCardRealNameCell *realNameCell ;
@property (nonatomic,strong, readonly)  RH_BankCardCell *bankSelectedCell ;
@property (nonatomic,strong, readonly)  RH_BankCardNumberCell *bankCardNumCell ;
@property (nonatomic,strong, readonly)  RH_BankCardLocationCell *bankLocationCell ;

@property (nonatomic,strong, readonly)  RH_BankPickerSelectView *bankPickerSelectView ;

////---
@property (nonatomic, strong,readonly) UIView *footerView ;
@property (nonatomic, strong,readonly) UIButton *addButton ;
@end

@implementation RH_BankCardController
{
    BankCardStatus _bankCardStatus ;
    
    NSString *_contextTitle ;
    //添加银行卡所需信息
    NSString *_addBankCardRealName ;
    NSString *_addBankCardBankName ;
    NSString *_addBankCardBankCardNumber ;
    NSString *_addBankCardMasterBankName ;
    NSString *_addBankCardBankCode ;
}
@synthesize tableViewManagement = _tableViewManagement;
@synthesize footerView = _footerView ;
@synthesize addButton = _addButton ;
@synthesize bankPickerSelectView = _bankPickerSelectView ;

-(void)setupViewContext:(id)context
{
    _contextTitle = ConvertToClassPointer(NSString, context) ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _contextTitle?:@"我的银行卡";
    [self setupInfo];
    self.needObserverTapGesture = YES ;
    [self setNeedUpdateView] ;
}

- (void)setupInfo {
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO];
    [self.contentView addSubview:self.contentTableView];
    self.contentTableView.tableFooterView = [self footerView];
    [self.tableViewManagement reloadData];
}

-(void)updateView
{
    if (MineSettingInfo==nil){
        _bankCardStatus = BankCardStatus_Init ;
        [self.tableViewManagement reloadDataWithPlistName:@"BankCardInit"] ;
        [self loadingIndicateViewDidTap:nil] ;
        
    }else{
        [self.contentLoadingIndicateView hiddenView] ;
        
        if (MineSettingInfo.mBankCard)
        {
            _bankCardStatus = BankCardStatus_Exist ;
            [self.tableViewManagement reloadDataWithPlistName:@"BankCardExist"] ;
            self.contentTableView.tableFooterView = nil;
            
        }else{
            self.contentTableView.tableFooterView = self.footerView ;
            _bankCardStatus = BankCardStatus_None ;
            [self.tableViewManagement reloadDataWithPlistName:@"BankCardNone"] ;
            [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
            if ([THEMEV3 isEqualToString:@"green"]){
                self.addButton.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
            }else if ([THEMEV3 isEqualToString:@"red"]){
                self.addButton.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
            }else if ([THEMEV3 isEqualToString:@"black"]){
                self.addButton.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
            }else{
                _addButton.backgroundColor = RH_NavigationBar_BackgroundColor;
            }
            
        }
    }
    
//    for (RH_ModifyPasswordCell *cell in self.contentTableView.visibleCells) {
//        if ([cell isKindOfClass:[RH_ModifyPasswordCell class]]) {
//            cell.textField.secureTextEntry = NO;
//        }
//    }
    
}

#pragma mark -
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return self.realNameCell.isEditing || self.bankCardNumCell.isEditing || self.bankLocationCell.isEditing ||[_bankPickerSelectView superview] ;
}

- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.realNameCell endEditing:YES] ;
    [self.bankCardNumCell endEditing:YES] ;
    [self.bankLocationCell endEditing:YES] ;
    
    if (_bankPickerSelectView.superview){
        [self hideBankPickerSelectView] ;
    }
}

#pragma mark -
-(RH_BankPickerSelectView *)bankPickerSelectView
{
    if (!_bankPickerSelectView){
        _bankPickerSelectView = [RH_BankPickerSelectView createInstance] ;
        _bankPickerSelectView.delegate = self ;
    }
    
    return _bankPickerSelectView ;
}

-(void)showBankPickerSelectView
{
    if (self.bankPickerSelectView.superview){
        [self.bankPickerSelectView removeFromSuperview] ;
    }
    self.bankPickerSelectView.backgroundColor = colorWithRGB(153, 153, 153);
    self.bankPickerSelectView.frame = CGRectMake(0, MainScreenH , MainScreenW, 0) ;
    [self.view addSubview:self.bankPickerSelectView] ;
    [UIView animateWithDuration:0.5f animations:^{
        self.bankPickerSelectView.frame = CGRectMake(0, MainScreenH - BankPickerSelectViewHeight , MainScreenW, BankPickerSelectViewHeight) ;
    } completion:^(BOOL finished) {
    }] ;
}

-(void)hideBankPickerSelectView
{
    if (self.bankPickerSelectView.superview){
        [self.view addSubview:self.bankPickerSelectView] ;
        [UIView animateWithDuration:0.5f animations:^{
            self.bankPickerSelectView.frame = CGRectMake(0, MainScreenH , MainScreenW, 0) ;
        } completion:^(BOOL finished) {
            [self.bankPickerSelectView removeFromSuperview] ;
        }] ;
    }
}

-(void)bankPickerSelectViewDidTouchConfirmButton:(RH_BankPickerSelectView*)bankPickerSelectView WithSelectedBank:(id)bankModel
{
    
    _addBankCardBankName = [((RH_BankInfoModel *)bankModel).mBankName copy] ;
    _addBankCardBankCode = [((RH_BankCardModel *)bankModel).mBankCode copy] ;
    [self.tableViewManagement reloadData] ;
    [self hideBankPickerSelectView];
}

-(void)bankPickerSelectViewDidTouchCancelButton:(RH_BankPickerSelectView*)bankPickerSelectView
{
    [self hideBankPickerSelectView];
}


//#pragma mark -textField Delegate
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if ([self.realNameCell.textField isEqual:textField]){
//        _addBankCardRealName = [textField.text copy] ;
//        return ;
//    }else if ([self.bankCardNumCell.textField isEqual:textField]){
//        _addBankCardBankCardNumber = [textField.text copy] ;
//        return ;
//    }else if ([self.bankLocationCell.textField isEqual:textField]){
//        _addBankCardMasterBankName = [textField.text copy] ;
//    }
//}

#pragma mark -
-(RH_BankCardRealNameCell *)realNameCell
{
    return _bankCardStatus==BankCardStatus_None?ConvertToClassPointer(RH_BankCardRealNameCell, [self.tableViewManagement cellViewAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]):nil ;
}

-(RH_BankCardCell *)bankSelectedCell
{
    return _bankCardStatus==BankCardStatus_None?ConvertToClassPointer(RH_BankCardCell, [self.tableViewManagement cellViewAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]]):nil ;
}

-(RH_BankCardNumberCell *)bankCardNumCell
{
    return _bankCardStatus==BankCardStatus_None?ConvertToClassPointer(RH_BankCardNumberCell, [self.tableViewManagement cellViewAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]]):nil ;
}

-(RH_BankCardLocationCell *)bankLocationCell
{
    return _bankCardStatus==BankCardStatus_None?ConvertToClassPointer(RH_BankCardLocationCell, [self.tableViewManagement cellViewAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]]):nil ;
}

#pragma mark - footerView
-(UIView *)footerView
{
    if (!_footerView){
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, 80)] ;
        [_footerView addSubview:self.addButton];
        self.addButton.whc_LeftSpace(20).whc_CenterY(0).whc_RightSpace(20).whc_Height(44);
    }
    
    return _footerView ;
}

-(UIButton *)addButton
{
    if (!_addButton){
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
        if ([THEMEV3 isEqualToString:@"green"]){
            _addButton.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
        }else if ([THEMEV3 isEqualToString:@"red"]){
            _addButton.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
        }else if ([THEMEV3 isEqualToString:@"black"]){
            _addButton.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
        }else{
            _addButton.backgroundColor = RH_NavigationBar_BackgroundColor;
        }
        _addButton.backgroundColor = colorWithRGB(27, 117, 217);
        _addButton.layer.cornerRadius = 5;
        _addButton.clipsToBounds = YES;
        [_addButton setTitle:@"添加" forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonHandle) forControlEvents:UIControlEventTouchUpInside] ;
    }
    
    return _addButton ;
}

- (void)addButtonHandle
{
    [self tapGestureRecognizerHandle:nil] ;
    
    _addBankCardRealName = self.realNameCell.textField.text;
    _addBankCardBankCardNumber = self.bankCardNumCell.textField.text;
    _addBankCardMasterBankName = self.bankLocationCell.textField.text;
    
    if (MineSettingInfo.mRealName.length > 0) {
        _addBankCardRealName = MineSettingInfo.mRealName;
    }
    if (_addBankCardRealName.length==0){
        showAlertView(@"提示信息", @"真实姓名不能为空！") ;
        return ;
    }
    
    if (_addBankCardBankName.length==0){
        showAlertView(@"提示信息", @"银行名不能为空！") ;
        return ;
    }
    
    if (_addBankCardBankCardNumber.length < 10 || _addBankCardBankCardNumber.length > 25){
        showAlertView(@"提示信息", @"银行卡号不正确(10-25位)！") ;
        return ;
    }
    
    if (_addBankCardMasterBankName.length==0){
        showAlertView(@"提示信息", @"开户行不能为空！") ;
        return ;
    }
    
    [self showProgressIndicatorViewWithAnimated:YES title:@"正在添加"];
    [self.serviceRequest startV3addBankCarkbankcardMasterName:_addBankCardRealName
                                                     bankName:_addBankCardBankCode
                                               bankcardNumber:_addBankCardBankCardNumber
                                                  bankDeposit:_addBankCardMasterBankName];
}

#pragma mark-
-(RH_LoadingIndicateView*)contentLoadingIndicateView
{
    return self.loadingIndicateTableViewCell.loadingIndicateView ;
}


- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:@"初始化银行卡信息" detailText:@"请稍等"] ;
    [self.serviceRequest startV3UserInfo] ;
}

#pragma mark - service request
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3UserInfo){
        [self.contentLoadingIndicateView hiddenView] ;
        [self setNeedUpdateView] ;
    }else if (type == ServiceRequestTypeV3AddBankCard){
        [[NSNotificationCenter defaultCenter] postNotificationName:RHNT_AlreadySuccessAddBankCardInfo object:nil] ;
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showSuccessMessage(self.view, @"提示信息",@"已成功添加银行卡") ;
            [self.serviceRequest startV3UserInfo] ;
        }];
        
        if (_contextTitle.length){
            [self backBarButtonItemHandle] ;
            return ;
        }
        
        [self setNeedUpdateView] ;
    }else if (type == ServiceRequestTypeV3UserInfo) {
        [self setNeedUpdateView];
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    if (type == ServiceRequestTypeV3UserInfo){
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }else if (type == ServiceRequestTypeV3AddBankCard){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showErrorMessage(self.view, error,  @"添加银行卡失败") ;
        }];
    }
}

#pragma mark-
- (CLTableViewManagement *)tableViewManagement {
    if (_tableViewManagement == nil) {
        _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView configureFileName:@"BankCardInit" bundle:nil];
        _tableViewManagement.delegate = self;
    }
    return _tableViewManagement;
}

- (id)tableViewManagement:(CLTableViewManagement *)tableViewManagement cellContextAtIndexPath:(NSIndexPath *)indexPath
{
    if (_bankCardStatus == BankCardStatus_Exist){
        if (indexPath.item == 0){ //真实姓名
            return MineSettingInfo.mRealName ;
        }else if (indexPath.item == 1){ //银行
            return MineSettingInfo.mBankCard.mBankName ;
        }else if (indexPath.item == 2){ //卡号
            return MineSettingInfo.mBankCard.mBankCardNumber ;
        }else if (indexPath.item == 3){ //开户行
            return MineSettingInfo.mBankCard.mBankDeposit ;
        }
    }else if (_bankCardStatus == BankCardStatus_None){
        if (indexPath.item == 0){ //真实姓名
            return MineSettingInfo.mRealName?:@"" ;
        }else if (indexPath.item == 1){ //选择银行
            return _addBankCardBankName?:@"请选择银行" ;
        }else if (indexPath.item == 2){ //卡号
            return _addBankCardBankCardNumber?:@"" ;
        }else if (indexPath.item == 3){ //开户行
            return _addBankCardMasterBankName?:@"" ;
        }
    }
    
    return nil ;
}

-(void)tableViewManagement:(CLTableViewManagement *)tableViewManagement IndexPath:(NSIndexPath *)indexPath Cell:(UITableViewCell*)cell
{
    if (_bankCardStatus == BankCardStatus_None) {
        
        if (MineSettingInfo.mRealName.length > 0) {
            self.realNameCell.textField.enabled = NO;
        }
    }
//    if (!MineSettingInfo.mBankCard){//新增银行卡情况
//        if ([cell isKindOfClass:[RH_ModifyPasswordNameCell class]]){
//            RH_ModifyPasswordNameCell *modifyCell = ConvertToClassPointer(RH_ModifyPasswordNameCell, cell) ;
//            modifyCell.textField.delegate = self ;
//        }
//        if ([cell isKindOfClass:[RH_BankCardNumberCell class]]){
//            RH_BankCardNumberCell *modifyCell = ConvertToClassPointer(RH_BankCardNumberCell, cell) ;
//            modifyCell.textField.delegate = self ;
//        }
//        if ([cell isKindOfClass:[RH_ModifyPasswordCell class]]){
//            RH_ModifyPasswordCell *modifyCell = ConvertToClassPointer(RH_ModifyPasswordCell, cell) ;
//            modifyCell.textField.delegate = self ;
//        }
//    }else{
//        if ([cell isKindOfClass:[RH_ModifyPasswordCell class]]){
//            RH_ModifyPasswordCell *modifyCell = ConvertToClassPointer(RH_ModifyPasswordCell, cell) ;
//            modifyCell.textField.delegate = nil ;
//        }
//    }
}

- (BOOL)tableViewManagement:(CLTableViewManagement *)tableViewManagement didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (_bankCardStatus == BankCardStatus_None){
       if (indexPath.item == 1){ //选择银行
           [self showBankPickerSelectView] ;
        }
    }
    return YES;
}

-(CGFloat)tableViewManagement:(CLTableViewManagement *)tableViewManagement customCellHeightAtIndexPath:(NSIndexPath *)indexPath
{
    return MainScreenH - StatusBarHeight - NavigationBarHeight ;
}

-(UITableViewCell*)tableViewManagement:(CLTableViewManagement *)tableViewManagement customCellAtIndexPath:(NSIndexPath *)indexPath
{
    return self.loadingIndicateTableViewCell ;
}

@end
