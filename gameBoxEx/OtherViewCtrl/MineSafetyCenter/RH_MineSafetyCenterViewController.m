//
//  RH_MineSafetyCenterViewController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MineSafetyCenterViewController.h"
#import "RH_MineSafetyCenterHeaderView.h"

#import "RH_ModifyPasswordController.h"
#import "RH_ModifySafetyPasswordController.h"
#import "RH_BankCardController.h"
#import "RH_GesturelLockController.h"
#import "coreLib.h"
#import "RH_UserInfoManager.h"
#import "RH_UserGroupInfoModel.h"
#import "RH_BankInfoModel.h"
typedef NS_ENUM(NSInteger,SafetyCenterStatus ) {
    SafetyCenterStatus_Init                        ,
    SafetyCenterStatus_None                        ,
    SafetyCenterStatus_OnlyCard                   ,
    SafetyCenterStatus_OnlyBit                    ,
    SafetyCenterStatus_Both                       ,
};


@interface RH_MineSafetyCenterViewController () <CLTableViewManagementDelegate>

@property (nonatomic, strong, readonly) CLTableViewManagement *tableViewManagement;
@property (nonatomic, strong, readonly) RH_MineSafetyCenterHeaderView *headerView;
@end

@implementation RH_MineSafetyCenterViewController
{
    SafetyCenterStatus _safetyCenterStatus  ;
}

@synthesize tableViewManagement = _tableViewManagement;
@synthesize headerView = _headerView;

- (BOOL)isSubViewController {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"安全中心";
    [self setupInfo];
    self.view.backgroundColor = colorWithRGB(255, 255, 255);
    [self setNeedUpdateView] ;
    [self.serviceRequest startV3UserInfo] ;
}


- (RH_MineSafetyCenterHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[RH_MineSafetyCenterHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, screenSize().width, 260);
    }
    return _headerView;
}

#pragma mark-
- (void)setupInfo {
    
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO];
    [self.contentView addSubview:self.contentTableView];
    [self.tableViewManagement reloadData];
}

-(void)updateView
{
    if (MineSettingInfo==nil){
        _safetyCenterStatus = SafetyCenterStatus_Init ;
        [self.tableViewManagement reloadDataWithPlistName:@"MineSafetyCenterInit"] ;
        [self loadingIndicateViewDidTap:nil] ;
        return ;
    }else{
        [self.contentLoadingIndicateView hiddenView] ;
        self.contentTableView.tableHeaderView = [self headerView];
        
        if (MineSettingInfo.mIsBit && MineSettingInfo.mIsCash)
        {
            _safetyCenterStatus = SafetyCenterStatus_Both ;
            [self.tableViewManagement reloadDataWithPlistName:@"MineSafetyCenterBoth"] ;
            return ;
        }else if (MineSettingInfo.mIsBit){
            _safetyCenterStatus = SafetyCenterStatus_OnlyBit ;
            [self.tableViewManagement reloadDataWithPlistName:@"MineSafetyCenterOnlyBit"] ;
            return ;
        }else if (MineSettingInfo.mIsCash){
            _safetyCenterStatus = SafetyCenterStatus_OnlyCard ;
            [self.tableViewManagement reloadDataWithPlistName:@"MineSafetyCenterOnlyCard"] ;
            return ;
        }else{
            _safetyCenterStatus = SafetyCenterStatus_None ;
            [self.tableViewManagement reloadDataWithPlistName:@"MineSafetyCenterNone"] ;
            return ;
        }
    }
}

#pragma mark-
-(RH_LoadingIndicateView*)contentLoadingIndicateView
{
    return self.loadingIndicateTableViewCell.loadingIndicateView ;
}


- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:@"初始化安全信息" detailText:@"请稍等"] ;
    [self.serviceRequest startV3UserInfo] ;
}

#pragma mark - service request
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3UserInfo){
        RH_UserGroupInfoModel *infoModel = ConvertToClassPointer(RH_UserGroupInfoModel, data);
        NSArray *bankModelArray = ConvertToClassPointer(NSArray, infoModel.mBankList);
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    if (type == ServiceRequestTypeV3UserInfo){
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }
}


#pragma mark-
- (CLTableViewManagement *)tableViewManagement {
    if (_tableViewManagement == nil) {
        _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView configureFileName:@"RH_MineSafetyCenter" bundle:nil];
        _tableViewManagement.delegate = self;
    }
    return _tableViewManagement;
}

-(CGFloat)tableViewManagement:(CLTableViewManagement *)tableViewManagement customCellHeightAtIndexPath:(NSIndexPath *)indexPath
{
    return MainScreenH - StatusBarHeight - NavigationBarHeight ;
}

-(UITableViewCell*)tableViewManagement:(CLTableViewManagement *)tableViewManagement customCellAtIndexPath:(NSIndexPath *)indexPath
{
    
    return self.loadingIndicateTableViewCell ;
}

- (BOOL)tableViewManagement:(CLTableViewManagement *)tableViewManagement didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dictInfo = [self.tableViewManagement cellExtraInfo:indexPath] ;
    UIViewController *targetViewCtrl = [dictInfo targetViewController] ;
    if (targetViewCtrl){
        [self showViewController:targetViewCtrl sender:self] ;
    }
    
    return YES;
}
@end
