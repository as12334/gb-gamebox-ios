//
//  RH_SlideMenuViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/12/19.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_SlideMenuViewController.h"
#import "RH_SlideHeaderView.h"
#import "coreLib.h"

#define  SlideMenuWidth             floorf(MainScreenW * 0.75)

@interface RH_SlideMenuViewController ()<SlideHeaderViewProtocol,CLTableViewManagementDelegate>
@property (nonatomic,strong,readonly) RH_SlideHeaderView *slideHeaderView        ;
@property (nonatomic,strong,readonly) CLTableViewManagement *tableViewManagement ;
@end

@implementation RH_SlideMenuViewController
@synthesize slideHeaderView = _slideHeaderView          ;
@synthesize tableViewManagement = _tableViewManagement  ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hiddenTabBar = YES ;
    self.hiddenNavigationBar = YES ;
    self.contentView.backgroundColor = colorWithRGB(68, 68, 68) ;
    [self setupUI] ;
}

-(BOOL)hasTopView
{
    return YES ;
}

-(CGFloat)topViewHeight
{
    return  180.0f ;
}

-(void)setupUI
{
    [self.topView addSubview:self.slideHeaderView] ;
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                          self.topView.frameY+self.topView.frameHeigh,
                                                                          SlideMenuWidth,
                                                                          self.contentView.frameHeigh-self.topView.frameHeigh-self.topView.frameY)
                                                         style:UITableViewStylePlain] ;
    
    self.contentTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin ;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    self.contentTableView.backgroundColor = [UIColor clearColor] ;
    
    [self.contentView addSubview:self.contentTableView] ;
    [self.tableViewManagement reloadData] ;
}

#pragma mark-
-(RH_SlideHeaderView *)slideHeaderView
{
    if (!_slideHeaderView){
        _slideHeaderView = [RH_SlideHeaderView createInstance] ;
        _slideHeaderView.delegate = self ;
        _slideHeaderView.frame = CGRectMake(0, 0, SlideMenuWidth, self.topView.frameHeigh);
        _slideHeaderView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight ;
    }
    
    return _slideHeaderView ;
}

-(void)slideHeaderViewTouchUserCenter:(RH_SlideHeaderView*)slideHeaderView
{
}

#pragma mark-
-(CLTableViewManagement*)tableViewManagement
{
    if (!_tableViewManagement){
        _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView
                                                              configureFileName:@"RH_MainMenuCells"
                                                                         bundle:nil] ;
        
        _tableViewManagement.delegate = self ;
    }
    return _tableViewManagement ;
}

 -(BOOL)tableViewManagement:(CLTableViewManagement *)tableViewManagement didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.item) {
        case 0:  //首页
            {
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
                        self.myTabBarController.selectedIndex = 2 ;
                    }else{
                        self.myTabBarController.selectedIndex = 0 ;
                    }
                }];
            }
            break;
            
        case 1:  //优惠活动
        {
            [self dismissViewControllerAnimated:YES completion:^{
                if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
                    self.myTabBarController.selectedIndex = 1 ;
                }
            }];
        }
            break;
        
        case 2:  //账户存款
        {
            [self dismissViewControllerAnimated:YES completion:^{
                if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
                    self.myTabBarController.selectedIndex = 0 ;
                }
            }];
        }
            break;
        
        case 3:  //关于我们
        {
            [self dismissViewControllerAnimated:YES completion:^{
                if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
                }
            }];
        }
            break;
        
        case 4:  //常见问题
        {
            [self dismissViewControllerAnimated:YES completion:^{
                if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
                }
            }];
        }
            break;
        
        case 5:  //在线客服
        {
            [self dismissViewControllerAnimated:YES completion:^{
                if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
                    self.myTabBarController.selectedIndex = 3 ;
                }
            }];
            
        }
            break;
            
        case 6:  //注册条款
        {
            [self dismissViewControllerAnimated:YES completion:^{
                if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
                }
            }];
        }
            break;
            
        case 7:  //语言
        {
            [self dismissViewControllerAnimated:YES completion:^{
                if ([SITE_TYPE isEqualToString:@"integratedv3"] || [SITE_TYPE isEqualToString:@"integratedv3oc"]){
                }
            }];
        }
            break;
            
        default:
            break;
    }
    
    return NO ;
}
@end
