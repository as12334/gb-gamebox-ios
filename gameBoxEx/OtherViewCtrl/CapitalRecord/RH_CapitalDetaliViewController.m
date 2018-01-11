//
//  RH_CapitalDetaliViewController.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_CapitalDetaliViewController.h"

@interface RH_CapitalDetaliViewController ()

@end

@implementation RH_CapitalDetaliViewController

-(BOOL)isSubViewController
{
    return YES ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资金记录详情";
    [self setUpUI];
}

-(void)setUpUI
{
    
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
