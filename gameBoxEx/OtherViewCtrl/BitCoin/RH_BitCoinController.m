//
//  RH_BitCoinController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BitCoinController.h"

@interface RH_BitCoinController ()<CLTableViewManagementDelegate>

@property (nonatomic, strong, readonly) CLTableViewManagement *tableViewManegement;

@end

@implementation RH_BitCoinController
@synthesize tableViewManegement = _tableViewManegement;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的比特币地址";
    [self setupInfo];
}

- (BOOL)isSubViewController {
    return YES;
}

- (CLTableViewManagement *)tableViewManegement {
    
    if (_tableViewManegement == nil) {
        _tableViewManegement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView configureFileName:@"RH_BitCoin" bundle:nil];
        _tableViewManegement.delegate = self;
    }
    return _tableViewManegement;
}

- (void)setupInfo {
    
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO];
    [self.contentView addSubview:self.contentTableView];
    [self.tableViewManegement reloadData] ;
}
@end
