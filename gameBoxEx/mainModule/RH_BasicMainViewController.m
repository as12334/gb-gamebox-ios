//
//  RH_BasicMainViewController.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/20.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_BasicMainViewController.h"
#import "coreLib.h"

@interface RH_BasicMainViewController ()
@end

@implementation RH_BasicMainViewController

-(void)viewDidLoad
{
    [super viewDidLoad] ;
    self.hiddenTabBar = NO ;
    self.hiddenNavigationBar = NO ;
    self.navigationItem.leftBarButtonItem = nil ;
    self.navigationItem.rightBarButtonItem = nil ;
}


@end
