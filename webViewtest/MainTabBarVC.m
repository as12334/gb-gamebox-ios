//
//  MainTabBarVC.m
//  webViewtest
//
//  Created by deve dawoo on 2017/4/4.
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import "MainTabBarVC.h"

@interface MainTabBarVC ()

@end

@implementation MainTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[UITabBar appearance] setBarTintColor:[UIColor redColor]];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor greenColor]} forState:UIControlStateSelected];
//    [self.tabBar tintColor:@{NSForegroundColorAttributeName:[UIColor grayColor]}]
//    NSLog(@"MainTabBarVC");
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
            break;
        case 4:
            break;
    }
}

@end
