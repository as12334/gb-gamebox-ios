//
//  RH_TestSafariViewController.m
//  gameBoxEx
//
//  Created by lewis on 2018/4/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_TestSafariViewController.h"
#import "RH_APPDelegate.h"
#import "RH_LoginViewController.h"
@interface RH_TestSafariViewController ()<UINavigationControllerDelegate>

@end

@implementation RH_TestSafariViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
     [self.navigationController.toolbar setHidden:YES];
    [self.navigationController setToolbarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//     [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.navigationController setToolbarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
