//
//  MainTabBarVC.m
//  webViewtest
//
//  Created by deve dawoo on 2017/4/4.
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import "MainTabBarVC.h"
#import "AppDelegate.h"
#import "ColorChange.h"

@interface MainTabBarVC ()

@property AppDelegate *appDelegate;

@end

@implementation MainTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
//    NSString siteType = _appDelegate.siteType;
//    NSString theme = _appDelegate.theme;
    
    UITabBarItem *home = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *deposit = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *transfer = [self.tabBar.items objectAtIndex:2];
    UITabBarItem *service = [self.tabBar.items objectAtIndex:3];
    UITabBarItem *mine = [self.tabBar.items objectAtIndex:4];
    
    home.title = @"首页";
    deposit.title = @"存款";
    service.title = @"客服";
    mine.title = @"我的";
    
    home.image = [[UIImage imageNamed:@"tab_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    deposit.image = [[UIImage imageNamed:@"tab_deposit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    service.image = [[UIImage imageNamed:@"tab_service"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mine.image = [[UIImage imageNamed:@"tab_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    if ([@"integrated" isEqualToString:SITE_TYPE]) {
        transfer.title = @"转账";
        transfer.image = [[UIImage imageNamed:@"tab_transfer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if ([@"blue.skin" isEqualToString:THEME]) {
            home.selectedImage = [[UIImage imageNamed:@"tab_blue_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            deposit.selectedImage = [[UIImage imageNamed:@"tab_blue_deposit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            transfer.selectedImage = [[UIImage imageNamed:@"tab_blue_transfer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            service.selectedImage = [[UIImage imageNamed:@"tab_blue_service"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            mine.selectedImage = [[UIImage imageNamed:@"tab_blue_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBar.tintColor = [UIColor colorWithRed:0.00 green:0.53 blue:1.00 alpha:1.0];
        } else if ([@"green.skin" isEqualToString:THEME]) {
            home.selectedImage = [[UIImage imageNamed:@"tab_green_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            deposit.selectedImage = [[UIImage imageNamed:@"tab_green_deposit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            transfer.selectedImage = [[UIImage imageNamed:@"tab_green_transfer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            service.selectedImage = [[UIImage imageNamed:@"tab_green_service"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            mine.selectedImage = [[UIImage imageNamed:@"tab_green_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBar.tintColor = [UIColor colorWithRed:0.08 green:0.50 blue:0.37 alpha:1.0];
        } else if ([@"pink.skin" isEqualToString:THEME]) {
            home.selectedImage = [[UIImage imageNamed:@"tab_pink_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            deposit.selectedImage = [[UIImage imageNamed:@"tab_pink_deposit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            transfer.selectedImage = [[UIImage imageNamed:@"tab_pink_transfer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            service.selectedImage = [[UIImage imageNamed:@"tab_pink_service"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            mine.selectedImage = [[UIImage imageNamed:@"tab_pink_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBar.tintColor = [UIColor colorWithRed:0.88 green:0.10 blue:0.48 alpha:1.0];
        } else {
            home.selectedImage = [[UIImage imageNamed:@"tab_default_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            deposit.selectedImage = [[UIImage imageNamed:@"tab_default_deposit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            transfer.selectedImage = [[UIImage imageNamed:@"tab_default_transfer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            service.selectedImage = [[UIImage imageNamed:@"tab_default_service"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            mine.selectedImage = [[UIImage imageNamed:@"tab_default_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBar.tintColor = [UIColor colorWithRed:0.09 green:0.40 blue:0.73 alpha:1.0];
        }
    } else if ([@"lottery" isEqualToString:SITE_TYPE]) {
        transfer.title = @"取款";
        transfer.image = [[UIImage imageNamed:@"tab_withdraw"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        deposit.title = @"充值/提款";
        transfer.title = @"购彩大厅";
        service.title = @"投注记录";
        
        deposit.image = [[UIImage imageNamed:@"tab_lottery_deposit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        transfer.image = [[UIImage imageNamed:@"tab_hall_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        service.image = [[UIImage imageNamed:@"tab_bet_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        
        home.selectedImage = [[UIImage imageNamed:@"tab_lottery_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        deposit.selectedImage = [[UIImage imageNamed:@"tab_lottery_deposit_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        transfer.selectedImage = [[UIImage imageNamed:@"tab_hall_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        service.selectedImage = [[UIImage imageNamed:@"tab_bet_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        mine.selectedImage = [[UIImage imageNamed:@"tab_lottery_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBar.tintColor = [UIColor colorWithRed:0.87 green:0.32 blue:0.30 alpha:1.0];
    }
    
    if ([@"185" isEqualToString:SID]) {
        home.title = @"メインページ";
        deposit.title = @"振込";
        transfer.title = @"振替";
        service.title = @"サービス";
        mine.title = @"マイ";
    }
}

-(void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item   //当点击相应得UITabBarItem时被调用
{
    //底部相应 根据下标
    switch (item.tag)
    {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            NSLog(@"item name = %@", item.title);
            break;
        case 4:
            break;
    }
}

@end
