//
//  RH_SiteMessageSentViewController.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SiteMessageSentViewController.h"
#import "RH_SiteSendMessageView.h"
@interface RH_SiteMessageSentViewController ()
//@property(nonatomic,strong,readonly)
@end

@implementation RH_SiteMessageSentViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
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
