//
//  RH_BasicSubViewController.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/20.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_BasicSubViewController.h"
#import "coreLib.h"

@interface RH_BasicSubViewController ()
@end

@implementation RH_BasicSubViewController

-(void)viewDidLoad
{
    [super viewDidLoad] ;
    self.hiddenTabBar = YES ;
    self.navigationBarItem.leftBarButtonItem = self.backButtonItem ;
    self.navigationBarItem.rightBarButtonItems = nil ;
}


-(void)backBarButtonItemHandle
{
    if (self.presentingViewController){
        [self dismissViewControllerAnimated:YES completion:nil] ;
    }else{
        [self.navigationController popViewControllerAnimated:YES] ;
    }
}


@end
