//
//  RH_MPApplyDiscountController.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPApplyDiscountController.h"
#import "coreLib.h"
#import "RH_MPGameNoticeViewController.h"
#import "RH_MPSystemNoticeViewController.h"
#import "RH_MPSiteMessageViewController.h"
#import "RH_MPSiteMessageViewControllerEX.h"
#import "RH_SiteSendMessageView.h"
@interface RH_MPApplyDiscountController ()
@property(nonatomic,strong,readonly)UISegmentedControl *segmentedControl;
@property(nonatomic,strong,readonly)UIScrollView *contentScrollowView;
@property(nonatomic,strong,readonly)RH_SiteSendMessageView *sendMessageView;
@end

@implementation RH_MPApplyDiscountController
@synthesize segmentedControl = _segmentedControl;
@synthesize contentScrollowView = _contentScrollowView;
@synthesize sendMessageView = _sendMessageView;
-(BOOL)isSubViewController
{
    return YES;
}
-(BOOL)hasTopView
{
    return YES;
}

-(CGFloat)topViewHeight
{
    return 100;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}
-(void)setupUI
{
    [self.topView addSubview:self.segmentedControl];
    setCenterConstraint(self.segmentedControl, self.topView) ;
    [self addChildCustomViewController];
    
    [self.contentView addSubview:self.contentScrollowView];
    UIViewController *VC= self.childViewControllers[0];
    if (VC.view.superview) {
        return;
    }
    VC.view.frame = CGRectMake(0,0, MainScreenW, MainScreenH);
    [self.contentScrollowView addSubview:VC.view];
}
-(RH_SiteSendMessageView *)sendMessageView
{
    if (!_sendMessageView) {
        _sendMessageView = [RH_SiteSendMessageView createInstance];
        _sendMessageView.frame = self.view.frame;
    }
    return _sendMessageView;
}
#pragma mark - 分段控制器
-(UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        NSArray *itemArray = @[@"游戏公告",@"系统公告",@"站点信息"];
        _segmentedControl = [[UISegmentedControl alloc]initWithItems:itemArray];
        _segmentedControl.frame = CGRectMake(0,0, 200, 30);
        _segmentedControl.translatesAutoresizingMaskIntoConstraints = NO ;
        //默认下标
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl addTarget:self action:@selector(choosechildController:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}
//选择滑到哪一个控制器
-(void)choosechildController:(UISegmentedControl *)sender{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentScrollowView.contentOffset = CGPointMake(sender.selectedSegmentIndex*MainScreenW, 0);
    }];
        UIViewController *VC= self.childViewControllers[sender.selectedSegmentIndex];
        if (VC.view.superview) {
            return;
        }
        VC.view.frame = CGRectMake(sender.selectedSegmentIndex*MainScreenW,0, MainScreenW,self.contentView.frameHeigh-NavigationBarHeight-self.topView.frameHeigh);
        [self.contentScrollowView addSubview:VC.view];
}

#pragma mark - contentScrollowView
-(UIScrollView *)contentScrollowView
{
    if (!_contentScrollowView) {
        _contentScrollowView = [[UIScrollView alloc]init];
        _contentScrollowView.frame = CGRectMake(0, NavigationBarHeight+100, self.contentView.frameWidth, self.contentView.frameHeigh-NavigationBarHeight-self.topView.frameHeigh);
        //CGRectMake(0, 114, MainScreenW, MainScreenH - 114);
        _contentScrollowView.delegate = self;
        _contentScrollowView.pagingEnabled = YES;
        _contentScrollowView.backgroundColor = [UIColor yellowColor];
        _contentScrollowView.bounces = NO;
        _contentScrollowView.scrollEnabled = NO;
        _contentScrollowView.showsHorizontalScrollIndicator = NO;
    }
    return _contentScrollowView;
}
#pragma mark - 添加子控制器
-(void)addChildCustomViewController
{
    RH_MPGameNoticeViewController *gameController= [[RH_MPGameNoticeViewController alloc]init];
    [self addChildViewController:gameController];
    RH_MPSystemNoticeViewController *systemController = [[RH_MPSystemNoticeViewController alloc]init];
    [self addChildViewController:systemController];
    RH_MPSiteMessageViewControllerEX *siteController = [[RH_MPSiteMessageViewControllerEX alloc]init];
    [self addChildViewController:siteController];
    NSInteger count = self.childViewControllers.count;
    self.contentScrollowView.contentSize = CGSizeMake(count*MainScreenW, 0);
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
