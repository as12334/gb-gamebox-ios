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
/***原生***/
#import "RH_AboutUsViewController.h"
#import "RH_RegisterClauseViewController.h" //注册条款
#import "RH_HelpCenterViewController.h"


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
+(void)configureNavigationBar:(UINavigationBar *)navigationBar
{
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"] ){
        navigationBar.barStyle = UIBarStyleDefault ;
        if (GreaterThanIOS11System){
            if ([THEMEV3 isEqualToString:@"green"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green ;
            }else if ([THEMEV3 isEqualToString:@"red"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red ;
            }else if ([THEMEV3 isEqualToString:@"black"]){
                navigationBar.barTintColor = ColorWithNumberRGB(0x1766bb) ;
            }else if ([THEMEV3 isEqualToString:@"blue"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Blue ;
            }else if ([THEMEV3 isEqualToString:@"orange"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange ;
            }else{
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor ;
            }
        }else
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
            [navigationBar insertSubview:backgroundView atIndex:0] ;
            if ([THEMEV3 isEqualToString:@"green"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Green ;
            }else if ([THEMEV3 isEqualToString:@"red"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Red ;
            }else if ([THEMEV3 isEqualToString:@"black"]){
                backgroundView.backgroundColor = ColorWithNumberRGB(0x1766bb) ;
            }else if ([THEMEV3 isEqualToString:@"blue"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Blue ;
            }else if ([THEMEV3 isEqualToString:@"orange"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Orange ;
            }else{
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor ;
            }
        }
        
        navigationBar.titleTextAttributes = @{NSFontAttributeName:RH_NavigationBar_TitleFontSize,
                                              NSForegroundColorAttributeName:RH_NavigationBar_ForegroundColor} ;
    }else{
        navigationBar.barStyle = UIBarStyleDefault ;
        if (GreaterThanIOS11System){
            navigationBar.barTintColor = [UIColor blackColor];
        }else
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
            [navigationBar insertSubview:backgroundView atIndex:0] ;
            backgroundView.backgroundColor = [UIColor blackColor] ;
        }
        
        navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0f],
                                              NSForegroundColorAttributeName:[UIColor whiteColor]} ;
    }
}


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
//        [self.navigationController pushViewController:[RH_MineMoreDetailWebViewController viewControllerWithContext:QuestionsURL]
//                                             animated:YES] ;
         [self.navigationController pushViewController:[RH_HelpCenterViewController viewController] animated:YES] ;
        
    }else if (indexPath.row == 1)
    {
//        [self.navigationController pushViewController:[RH_MineMoreDetailWebViewController viewControllerWithContext:RegisterProtocol]
//                                             animated:YES] ;
        [self.navigationController pushViewController:[RH_RegisterClauseViewController viewController] animated:YES] ;
    }else if (indexPath.row== 2)
    {
//        [self.navigationController pushViewController:[RH_MineMoreDetailWebViewController viewControllerWithContext:AboutUs]
//                                             animated:YES] ;
        [self.navigationController pushViewController:[RH_AboutUsViewController viewController] animated:YES] ;
    }

    return YES;
}
@end
