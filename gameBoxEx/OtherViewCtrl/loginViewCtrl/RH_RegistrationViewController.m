//
//  RH_RegistrationViewController.m
//  gameBoxEx
//
//  Created by Lenny on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_RegistrationViewController.h"
#import "coreLib.h"
@interface RH_RegistrationViewController ()<CLTableViewManagementDelegate>

@property (nonatomic, strong, readonly) CLTableViewManagement *tableViewManagement;
//@property (nonatomic, strong, readonly) <#UIScrollView#> *<#scrollView#>;
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
                navigationBar.barTintColor = ColorWithNumberRGB(0x1b75d9) ;
            }else{
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor ;
            }
        }else
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
            [navigationBar insertSubview:backgroundView atIndex:0] ;
            backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor ;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupInfo];
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

@end
