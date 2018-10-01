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
#import "RH_SelectedHelper.h"
@interface RH_DepositeBasicViewController ()
@property(nonatomic,strong)RH_ScrollPageView *scrollView;
@end
@implementation RH_DepositeBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedWithDrawCash) name:@"selectedWithNotification" object:nil];
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
    style.coverHeight = 40;
    style.titleFont = [UIFont systemFontOfSize:15];
    style.gradualChangeTitleColor = YES;
    style.normalTitleColor = colorWithRGB(52, 52, 52);
    style.selectedTitleColor = colorWithRGB(31, 103, 185);
    CGFloat tab_height = TABBAR_HEIGHT;
//    if (iPhoneX) {
//        tab_height = 83
//    }
    RH_ScrollPageView *scrollPageView = [[RH_ScrollPageView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight+STATUS_HEIGHT, screenSize().width, screenSize().height-NavigationBarHeight-STATUS_HEIGHT-tab_height) segmentStyle:style childVcs:childs Titles:@[@"存款",@"资金",@"提现"] parentViewController:self];
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollPageView];
    self.scrollView = scrollPageView;
    //从未点击过存款tabbar的话从我的页面点击提现会默认选中第一个的 但事实上应该选中第三个,因为从未初始化过该控制器所有通知没有收到
    [scrollPageView setSelectedIndex:[RH_SelectedHelper shared].selectedIndex animated:NO];
}
-(void)selectedWithDrawCash{
    [self.scrollView setSelectedIndex:[RH_SelectedHelper shared].selectedIndex animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
