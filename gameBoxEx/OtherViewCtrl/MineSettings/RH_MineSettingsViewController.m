//
//  RH_MineSettingsViewController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MineSettingsViewController.h"
#import "coreLib.h"
@interface RH_MineSettingsViewController () <CLTableViewManagementDelegate>

@property (nonatomic, strong, readonly) CLTableViewManagement *tableViewManagement;
@property (nonatomic, strong) UIButton *button;

@end

@implementation RH_MineSettingsViewController
@synthesize tableViewManagement = _tableViewManagement;

- (BOOL)isSubViewController {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self setupInfo];
}

- (void)setupInfo {
    
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO];
    [self.contentView addSubview:self.contentTableView];
    UIView *view_Footer = [[UIView alloc] init];
    view_Footer.frame = CGRectMake(0, 0, screenSize().width, 100);
    self.contentTableView.tableFooterView = view_Footer;
    self.button = [[UIButton alloc] init];
    [view_Footer addSubview:self.button];
    self.button.whc_TopSpace(30).whc_LeftSpace(20).whc_RightSpace(20).whc_Height(45);
    [self.button setBackgroundColor:colorWithRGB(27, 117, 217)];
    self.button.layer.cornerRadius = 5.0f;
    self.button.clipsToBounds = YES;
    [self.button setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.button setTitleColor:colorWithRGB(255, 255, 255) forState:UIControlStateNormal];
    [self.button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.button addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [self.tableViewManagement reloadData];
    
}

#pragma mark - 退出登录
-(void)loginOut
{
    [self.serviceRequest startV3UserLoginOut];
}

#pragma mark-
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3UserLoginOut){
       
    }
   
    
    
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3UserLoginOut){
        [self loadDataFailWithError:error] ;
    }
}

- (CLTableViewManagement *)tableViewManagement {
    
    if (_tableViewManagement == nil) {
        _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView configureFileName:@"RH_MineSettings" bundle:nil];
        _tableViewManagement.delegate = self;
    }
    return _tableViewManagement;
}

- (BOOL)tableViewManagement:(CLTableViewManagement *)tableViewManagement didSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    return  YES;
}

@end
