//
//  RH_MineMoreInfoViewController.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//
//常见问题
#define QuestionsURL       @"/help/firstType.html"
//注册条款
#define RegisterProtocol   @"/getRegisterRules.html?path=terms"
//关于我们
#define AboutUs            @"/about.html?path=about"

#import "RH_MineMoreInfoViewController.h"
#import "RH_MineMoreDetailWebViewController.h"
#import "RH_AboutUsViewController.h"


@interface RH_MineMoreInfoViewController ()<CLTableViewManagementDelegate>
@property(nonatomic,strong,readonly) CLTableViewManagement *tableViewManagement ;
@end

@implementation RH_MineMoreInfoViewController
@synthesize tableViewManagement = _tableViewManagement   ;
- (BOOL)isSubViewController {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"更多" ;
    [self setupInfo];
}
#pragma mark-
-(void)setupInfo
{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO] ;
    [self.contentView addSubview:self.contentTableView] ;
    [self.tableViewManagement reloadData] ;
}

-(CLTableViewManagement*)tableViewManagement
{
    if (!_tableViewManagement){
        _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView
                                                              configureFileName:@"RH_MineMoreCells"
                                                                         bundle:nil] ;
        
        _tableViewManagement.delegate = self ;
    }
    
    return _tableViewManagement ;
}
-(BOOL)tableViewManagement:(CLTableViewManagement *)tableViewManagement didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[RH_MineMoreDetailWebViewController viewControllerWithContext:QuestionsURL]
                                             animated:YES] ;
    }else if (indexPath.row == 1)
    {
        [self.navigationController pushViewController:[RH_MineMoreDetailWebViewController viewControllerWithContext:RegisterProtocol]
                                             animated:YES] ;
    }else if (indexPath.row== 2)
    {
//        [self.navigationController pushViewController:[RH_MineMoreDetailWebViewController viewControllerWithContext:AboutUs]
//                                             animated:YES] ;
        [self.navigationController pushViewController:[RH_AboutUsViewController viewController] animated:YES] ;
    }

    return YES;
}
@end
