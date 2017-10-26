//
//  RH_ImagePickerViewController.m
//  TaskTracking
//
//  Created by apple pro on 2017/2/26.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_ImagePickerViewController.h"
#import "RH_BasicViewController.h"

@interface RH_ImagePickerViewController ()

@end

@implementation RH_ImagePickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [RH_BasicViewController configureNavigationBar:self.navigationBar] ;
    self.statusBarStyle = UIStatusBarStyleLightContent;
}

@end

//----------------------------------------------------------

@implementation RH_MultipleImagePickerController

@end
