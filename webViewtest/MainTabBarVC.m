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
    
    home.image = [[UIImage imageNamed:@"tab_0_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    deposit.image = [[UIImage imageNamed:@"tab_1_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    transfer.image = [[UIImage imageNamed:@"tab_2_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    service.image = [[UIImage imageNamed:@"tab_3_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mine.image = [[UIImage imageNamed:@"tab_4_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    home.selectedImage = [[UIImage imageNamed:@"tab_0_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    deposit.selectedImage = [[UIImage imageNamed:@"tab_1_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    transfer.selectedImage = [[UIImage imageNamed:@"tab_2_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    service.selectedImage = [[UIImage imageNamed:@"tab_3_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mine.selectedImage = [[UIImage imageNamed:@"tab_4_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    if ([@"integrated" isEqualToString:SITE_TYPE]) {
        deposit.title = @"存款";
        transfer.title = @"转账";
        service.title = @"客服";
        mine.title = @"我的";
        if ([@"blue.skin" isEqualToString:THEME]) {
            self.tabBar.tintColor = [UIColor colorWithRed:0.00 green:0.53 blue:1.00 alpha:1.0];
        } else if ([@"green.skin" isEqualToString:THEME]) {
            self.tabBar.tintColor = [UIColor colorWithRed:0.08 green:0.50 blue:0.37 alpha:1.0];
        } else if ([@"pink.skin" isEqualToString:THEME]) {
            self.tabBar.tintColor = [UIColor colorWithRed:0.88 green:0.10 blue:0.48 alpha:1.0];
        } else {
            self.tabBar.tintColor = [UIColor colorWithRed:0.09 green:0.40 blue:0.73 alpha:1.0];
        }
    } else if ([@"lottery" isEqualToString:SITE_TYPE]) {
        deposit.title = @"充值/提款";
        transfer.title = @"购彩大厅";
        service.title = @"投注记录";
        mine.title = @"会员中心";
        
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
