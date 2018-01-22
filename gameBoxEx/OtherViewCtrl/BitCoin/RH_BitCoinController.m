//
//  RH_BitCoinController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BitCoinController.h"
#import "coreLib.h"
#import "RH_UserInfoManager.h"
#import "RH_BitCoinCell.h"

typedef NS_ENUM(NSInteger,BitCoinStatus ) {
    BitCoinStatus_Init                        ,
    BitCoinStatus_None                        ,
    BitCoinStatus_Exist                   ,
};

@interface RH_BitCoinController ()<CLTableViewManagementDelegate,UITextViewDelegate>
@property (nonatomic,strong,readonly) CLTableViewManagement *tableViewManagement;
@property (nonatomic,strong,readonly) RH_BitCoinCell *bitCoinCell ;
////---
@property (nonatomic, strong,readonly) UIView *footerView ;
@property (nonatomic, strong,readonly) UIButton *addButton ;
@end

@implementation RH_BitCoinController
{
    BitCoinStatus _bitCoinStatus ;    
    NSString *_addBitCoinAddrInfo ;
}
@synthesize tableViewManagement = _tableViewManagement;
@synthesize footerView = _footerView ;
@synthesize addButton = _addButton ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的比特币地址";
    [self setupInfo];
    self.needObserverTapGesture = YES ;
    [self setNeedUpdateView] ;
}

- (void)setupInfo
{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO];
    [self.contentView addSubview:self.contentTableView];
    [self.tableViewManagement reloadData] ;
}

-(void)updateView
{
    if (MineSettingInfo==nil){
        _bitCoinStatus = BitCoinStatus_Init ;
        [self.tableViewManagement reloadDataWithPlistName:@"BitCoinInit"] ;
        [self loadingIndicateViewDidTap:nil] ;
        
    }else{
        [self.contentLoadingIndicateView hiddenView] ;
        
        if (MineSettingInfo.mBitCode)
        {
            _bitCoinStatus = BitCoinStatus_Exist ;
            [self.tableViewManagement reloadDataWithPlistName:@"BitCoinExist"] ;
            self.contentTableView.tableFooterView = nil;
            
        }else{
            self.contentTableView.tableFooterView = self.footerView ;
            _bitCoinStatus = BitCoinStatus_None ;
            [self.tableViewManagement reloadDataWithPlistName:@"BitCoinNone"] ;
            [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
        }
    }
    
    ///
    self.bitCoinCell.textV.editable = MineSettingInfo.mBitCode?NO:YES ;
}

-(RH_BitCoinCell *)bitCoinCell
{
    return ConvertToClassPointer(RH_BitCoinCell, [self.tableViewManagement cellViewAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]) ;
}

#pragma mark -textView Delegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.bitCoinCell.textV isEqual:textView]){
        _addBitCoinAddrInfo = [textView.text copy] ;
        return ;
    }
}

#pragma mark -
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.bitCoinCell.isEditing ;
}

- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.bitCoinCell endEditing:YES] ;
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
    
    if (_addBitCoinAddrInfo.length==0){
        showAlertView(@"提示信息", @"Bit币地址不能为空！") ;
        return ;
    }
    
    [self showProgressIndicatorViewWithAnimated:YES title:@"正在添加"];
    [self.serviceRequest startV3AddBtcWithNumber:_addBitCoinAddrInfo];
}

#pragma mark-
-(RH_LoadingIndicateView*)contentLoadingIndicateView
{
    return self.loadingIndicateTableViewCell.loadingIndicateView ;
}


- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:@"初始化用户比特币信息" detailText:@"请稍等"] ;
    [self.serviceRequest startV3UserInfo] ;
}

#pragma mark - service request
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3UserInfo){
        [self.contentLoadingIndicateView hiddenView] ;
        [self setNeedUpdateView] ;
    }else if (type == ServiceRequestTypeV3AddBitCoin){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showSuccessMessage(self.view, @"提示信息",@"已成功添加Bit币") ;
        }];
        
        [self setNeedUpdateView] ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    if (type == ServiceRequestTypeV3UserInfo){
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }else if (type == ServiceRequestTypeV3AddBitCoin){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showErrorMessage(self.view, error, @"添加Bit币失败") ;
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
    if (_bitCoinStatus == BitCoinStatus_Exist){
        if (indexPath.item == 0){ //bit address.
            return MineSettingInfo.mBitCode.mBtcNumber ;
        }
    }else if (_bitCoinStatus == BitCoinStatus_None){
        if (indexPath.item == 0){ //
            return _addBitCoinAddrInfo?:@"" ;
        }
    }
    
    return nil ;
}

-(void)tableViewManagement:(CLTableViewManagement *)tableViewManagement IndexPath:(NSIndexPath *)indexPath Cell:(UITableViewCell*)cell
{
    if (_bitCoinStatus == BitCoinStatus_Exist){
        if ([cell isKindOfClass:[RH_BitCoinCell class]]){
            RH_BitCoinCell *bitCoinCell = ConvertToClassPointer(RH_BitCoinCell, cell) ;
            bitCoinCell.textV.delegate = nil ;
        }
    }else if (_bitCoinStatus == BitCoinStatus_None){
        if ([cell isKindOfClass:[RH_BitCoinCell class]]){
            RH_BitCoinCell *bitCoinCell = ConvertToClassPointer(RH_BitCoinCell, cell) ;
            bitCoinCell.textV.delegate = self ;
        }
    }
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
