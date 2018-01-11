//
//  RH_PreferentialListController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PreferentialListController.h"
#import "coreLib.h"
@interface RH_PreferentialListController () <CLTableViewManagementDelegate>

@property (nonatomic, strong, readonly) CLTableViewManagement *tableViewManagement;

@end

@implementation RH_PreferentialListController
@synthesize tableViewManagement = _tableViewManagement;


- (BOOL)isSubViewController {
    return  YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"优惠记录";
    [self setupInfo];
    self.contentView.backgroundColor = colorWithRGB(239, 239, 239);
    
}

- (void)setupInfo {
    
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO];
    [self.contentView addSubview:self.contentTableView];
    [self.tableViewManagement reloadData];
    self.contentTableView.backgroundColor = [UIColor clearColor];
}

- (CLTableViewManagement *)tableViewManagement {
    
    if (_tableViewManagement == nil) {
        _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView configureFileName:@"RH_PreferentialList" bundle:nil];
        _tableViewManagement.delegate = self;
    }
    return _tableViewManagement;
}

- (CGFloat)tableViewManagement:(CLTableViewManagement *)tableViewManagement customCellHeightAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

@end
