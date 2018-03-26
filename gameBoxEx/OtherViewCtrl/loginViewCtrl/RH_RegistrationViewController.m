//
//  RH_RegistrationViewController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_RegistrationViewController.h"
#import "coreLib.h"
@interface RH_RegistrationViewController ()<CLTableViewManagementDelegate, RH_ServiceRequestDelegate>

@property (nonatomic, strong, readonly) CLTableViewManagement *tableViewManagement;

@end

@implementation RH_RegistrationViewController
@synthesize tableViewManagement = _tableViewManagement;


- (BOOL)hasTopView {
    return NO;
}
- (BOOL)hasNavigationBar {
    return YES;
}
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self setupInfo];
    [self showProgressIndicatorViewWithAnimated:YES title:@"正在加载..."];
    [self.serviceRequest startV3RegisetInit];
}

- (void)setupInfo {
    
    self.title = @"免费注册";
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO];
    [self.contentView addSubview:self.contentTableView];
    [self.tableViewManagement reloadData];
    
}

- (CLTableViewManagement *)tableViewManagement {
    if (_tableViewManagement == nil) {
        _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView configureFileName:@"RH_Registration" bundle:nil];
        _tableViewManagement.delegate = self;
    }
    return _tableViewManagement;
}

#pragma mark Request
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    
}
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data {

}
@end
