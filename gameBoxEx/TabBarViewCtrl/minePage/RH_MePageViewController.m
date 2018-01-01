//
//  RH_MePageViewController.m
//  lotteryBox
//
//  Created by luis on 2017/12/8.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_MePageViewController.h"
#import "RH_MineCustomerServicesController.h"
#import "RH_MineSettingViewController.h"
#import "RH_MinePageBannarCell.h"
@interface RH_MePageViewController ()<CLTableViewManagementDelegate,MinePageBannarCellDelegate>
@property(nonatomic,strong,readonly)UIBarButtonItem *barButtonCustom ;
@property(nonatomic,strong,readonly)UIBarButtonItem *barButtonSetting;
@property(nonatomic,strong)RH_MinePageBannarCell *bannarCell;
@property(nonatomic,strong,readonly) CLTableViewManagement *tableViewManagement ;
@end

@implementation RH_MePageViewController
@synthesize barButtonCustom = _barButtonCustom ;
@synthesize barButtonSetting = _barButtonSetting ;
@synthesize tableViewManagement = _tableViewManagement;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的" ;
    [self setupUI];
    
}

#pragma mark-
-(UIBarButtonItem *)barButtonCustom
{
    if (!_barButtonCustom){
#if 1
        UIImage *menuImage = ImageWithName(@"me_custom_icon");
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, menuImage.size.width, menuImage.size.height);
        [button setBackgroundImage:menuImage forState:UIControlStateNormal];
        [button addTarget:self action:@selector(_barButtonCustomHandle) forControlEvents:UIControlEventTouchUpInside] ;
        _barButtonCustom = [[UIBarButtonItem alloc] initWithCustomView:button] ;
#else
        _barButtonCustom = [[UIBarButtonItem alloc] initWithImage:ImageWithName(@"me_custom_icon")
                                                            style:UIBarButtonItemStyleDone
                                                           target:self
                                                           action:@selector(_barButtonCustomHandle)] ;
#endif
    }
    
    return _barButtonCustom ;
}

-(void)_barButtonCustomHandle
{
    [self showViewController:[RH_MineCustomerServicesController viewController] sender:self] ;
}

#pragma mark-
-(UIBarButtonItem *)barButtonSetting
{
    if (!_barButtonSetting){
#if 1
        UIImage *menuImage = ImageWithName(@"me_setting_icon");
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, menuImage.size.width, menuImage.size.height);
        [button setBackgroundImage:menuImage forState:UIControlStateNormal];
        [button addTarget:self action:@selector(_barButtonSettingHandle) forControlEvents:UIControlEventTouchUpInside] ;
        _barButtonSetting = [[UIBarButtonItem alloc] initWithCustomView:button] ;
#else
        _barButtonSetting = [[UIBarButtonItem alloc] initWithImage:ImageWithName(@"me_setting_icon")
                                                             style:UIBarButtonItemStyleDone
                                                           target:self
                                                            action:@selector(_barButtonSettingHandle)] ;
#endif
    }
    
    return _barButtonSetting ;
}

-(void)_barButtonSettingHandle
{
    [self showViewController:[RH_MineSettingViewController viewController] sender:self] ;
}

#pragma mark-
-(void)setupUI
{
    self.navigationBarItem.leftBarButtonItem = self.barButtonCustom;
    self.navigationBarItem.rightBarButtonItem = self.barButtonSetting;
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO] ;
    [self.contentView addSubview:self.contentTableView] ;
    [self.tableViewManagement reloadData] ;
}

#pragma mark-
-(CLTableViewManagement*)tableViewManagement
{
    if (!_tableViewManagement){
        _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView
                                                              configureFileName:@"RH_UserCenterCells"
                                                                         bundle:nil] ;
        
        _tableViewManagement.delegate = self ;
    }
    return _tableViewManagement ;
}
-(void)tableViewManagement:(CLTableViewManagement *)tableViewManagement IndexPath:(NSIndexPath *)indexPath Cell:(UITableViewCell*)cell
{
    _bannarCell = ConvertToClassPointer(RH_MinePageBannarCell, cell);
    _bannarCell.delegate=self;
}

//-(void)testTimePickerClick:(RH_MinePageBannarCell *)cell
//{
//    CLChooseTimeViewController * vc =[CLChooseTimeViewController new];
//    
//    __weak typeof(self)weekSelf = self;
//    
//    [vc backDate:^(NSArray *goDate, NSArray *backDate) {
//        
//        cell.labAccoutInfo.text = [NSString stringWithFormat:@"%@ : %@",[goDate componentsJoinedByString:@"-"],[backDate componentsJoinedByString:@"-"]];
//        NSLog(@"--%@",[NSString stringWithFormat:@"%@ : %@",[goDate componentsJoinedByString:@"-"],[backDate componentsJoinedByString:@"-"]]);
//        [cell updateCellIfNeeded];
//    }];
//    
//    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:vc];
//    [self presentViewController:nav animated:YES completion:^{
//        
//        
//    }];
//}
@end
