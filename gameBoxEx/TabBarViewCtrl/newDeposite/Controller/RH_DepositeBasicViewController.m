//
//  RH_DepositeBasicViewController.m
//  gameBoxEx
//
//  Created by jun on 2018/9/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeBasicViewController.h"
#import "RH_ContentView.h"
#import "RH_ScrollPageView.h"
#import "RH_DepositeViewControllerEX.h"
#import "RH_FundsTransferViewController.h"
#import "RH_WithdrawCashController.h"
@interface RH_DepositeBasicViewController ()

@end
@implementation RH_DepositeBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}
-(BOOL)tabBarHidden
{
    return NO ;
}
- (BOOL)isSubViewController{
    return NO;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
     self.hiddenTabBar = NO;
}

-(void)configUI{
    self.title = @"存款";
    NSMutableArray *childs = [NSMutableArray array];
    RH_DepositeViewControllerEX *vc1 = [[RH_DepositeViewControllerEX alloc]init];
    RH_FundsTransferViewController *vc2 = [[RH_FundsTransferViewController alloc]init];
    RH_WithdrawCashController *vc3 = [[RH_WithdrawCashController alloc]init];
    [childs addObject:vc1];
    [childs addObject:vc2];
    [childs addObject:vc3];
    //设置主页面
    RH_SegmentStyle *style = [[RH_SegmentStyle alloc]init];
    style.scaleTitle = YES;
    style.scrollTitle = NO;
    style.showLine = YES;
//    style.titleMargin = 120;
    style.coverHeight = 40;
    style.titleFont = [UIFont systemFontOfSize:15];
    style.gradualChangeTitleColor = YES;
    style.normalTitleColor = [UIColor greenColor];
    style.selectedTitleColor = [UIColor yellowColor];
    RH_ScrollPageView *scrollPageView = [[RH_ScrollPageView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight+STATUS_HEIGHT, screenSize().width, screenSize().height-NavigationBarHeight-STATUS_HEIGHT-TabBarHeight) segmentStyle:style childVcs:childs Titles:@[@"存款",@"资金转账",@"提现"] parentViewController:self];
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollPageView];
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
