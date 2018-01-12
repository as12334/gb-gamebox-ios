//
//  RH_BankCardController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BankCardController.h"

@interface RH_BankCardController ()<CLTableViewManagementDelegate>

@property (nonatomic, strong, readonly) CLTableViewManagement *tableViewManagement;
@property (nonatomic, strong) UIButton *button;
@end

@implementation RH_BankCardController
@synthesize tableViewManagement = _tableViewManagement;

- (BOOL)isSubViewController {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的银行卡";
    [self setupInfo];
}

- (void)setupInfo {
    
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO];
    [self.contentView addSubview:self.contentTableView];
    [self.tableViewManagement reloadData];
    
    UIView *view_Footer = [[UIView alloc] init];
    view_Footer.frame = CGRectMake(0, 0, screenSize().width, 120);
    self.contentTableView.tableFooterView = view_Footer;
    
    self.button = [UIButton new];
    [view_Footer addSubview:self.button];
    self.button.whc_LeftSpace(20).whc_CenterY(0).whc_RightSpace(20).whc_Height(44);
    [self.button setTitle:@"添加" forState:UIControlStateNormal];
    [self.button setBackgroundColor:colorWithRGB(27, 117, 217)];
}

- (CLTableViewManagement *)tableViewManagement {
    if (_tableViewManagement == nil) {
        _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView configureFileName:@"RH_BankCardAdd" bundle:nil];
        _tableViewManagement.delegate = self;
    }
    return _tableViewManagement;
}

- (BOOL)tableViewManagement:(CLTableViewManagement *)tableViewManagement didSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

@end
