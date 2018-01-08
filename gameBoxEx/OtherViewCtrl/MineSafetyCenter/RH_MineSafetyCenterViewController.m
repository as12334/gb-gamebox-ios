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

#import "RH_GesturelLockController.h"
#import "coreLib.h"

@interface RH_MineSafetyCenterViewController () <CLTableViewManagementDelegate>

@property (nonatomic, strong, readonly) CLTableViewManagement *tableViewManagement;
@property (nonatomic, strong, readonly) RH_MineSafetyCenterHeaderView *headerView;
@end

@implementation RH_MineSafetyCenterViewController
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
    self.contentTableView.tableHeaderView = [self headerView];
    
    [self.tableViewManagement reloadData];
}

- (CLTableViewManagement *)tableViewManagement {
    if (_tableViewManagement == nil) {
        _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView configureFileName:@"RH_MineSafetyCenter" bundle:nil];
        _tableViewManagement.delegate = self;
    }
    return _tableViewManagement;
}

- (BOOL)tableViewManagement:(CLTableViewManagement *)tableViewManagement didSelectCellAtIndexPath:(NSIndexPath *)indexPath {

   
    if (indexPath.row ==0) {
        RH_ModifyPasswordController *vc = [[RH_ModifyPasswordController alloc]init];
        [self showViewController:vc sender:nil];
    }
    if (indexPath.row == 1) {
        RH_ModifySafetyPasswordController *vc = [[RH_ModifySafetyPasswordController alloc] init];
        [self showViewController:vc sender:nil];
    }
    

    if (indexPath.item ==2) {
        NSDictionary *cellInfo = [tableViewManagement cellExtraInfo:indexPath] ;
        UIViewController *targetViewCtrl = [cellInfo targetViewController] ;
        if (targetViewCtrl){
            [self showViewController:targetViewCtrl sender:self] ;
        }
    }

    return YES;
}
@end
