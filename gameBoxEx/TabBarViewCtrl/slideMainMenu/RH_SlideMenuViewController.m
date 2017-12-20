//
//  RH_SlideMenuViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/12/19.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_SlideMenuViewController.h"

@interface RH_SlideMenuViewController ()

@end

@implementation RH_SlideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hiddenTabBar = YES ;
    self.hiddenNavigationBar = YES ;
}

-(BOOL)hasTopView
{
    return YES ;
}

-(CGFloat)topViewHeight
{
    return  50.0f ;
}


@end
