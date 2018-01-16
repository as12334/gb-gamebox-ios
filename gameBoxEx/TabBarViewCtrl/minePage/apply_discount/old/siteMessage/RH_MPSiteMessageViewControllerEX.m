//
//  RH_MPSiteMessageViewControllerEX.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPSiteMessageViewControllerEX.h"
#import "RH_SiteMessageSystemNoticeController.h"
#import "RH_SiteMessageMineNoticeController.h"
#import "RH_SiteMessageSentViewController.h"
@interface RH_MPSiteMessageViewControllerEX ()
@property(nonatomic,strong,readonly)UIScrollView *contentScrollowView;
@property(nonatomic,strong)UIButton *chooseBtn;
@end

@implementation RH_MPSiteMessageViewControllerEX
@synthesize contentScrollowView = _contentScrollowView;
-(BOOL)isSubViewController
{
    return YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}
-(void)setupUI
{
    //加上三个按钮
    NSArray *btnTitleArray = @[@"系统消息",@"我的消息",@"发送消息"];
    for (int i = 0; i<3; i++) {
        UIButton *btn  =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10+70*i, 10, 60, 30);
        btn.backgroundColor = [UIColor lightGrayColor];
        [btn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:11.f];
        btn.tag  = i;
        [btn addTarget:self action:@selector(selectedChooseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor lightGrayColor]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        if (i==0) {
            btn.backgroundColor = [UIColor blueColor];
            btn.selected = YES;
            self.chooseBtn = btn;
        }
        [self.view addSubview:btn];
    }
    
    [self addChildCustomViewController];
    [self.contentView addSubview:self.contentScrollowView];
    UIViewController *VC= self.childViewControllers[0];
    if (VC.view.superview) {
        return;
    }
    VC.view.frame = CGRectMake(0,0, MainScreenW, MainScreenH);
    [self.contentScrollowView addSubview:VC.view];
}
#pragma mark 选择按钮的点击事件
-(void)selectedChooseBtn:(UIButton *)button
{
    if (!button.isSelected) {
        self.chooseBtn.selected = !self.chooseBtn.selected;
        self.chooseBtn.backgroundColor = [UIColor lightGrayColor];
        button.selected = !button.selected;
        button.backgroundColor = [UIColor blueColor];
        self.chooseBtn = button;
        
    }
//    if (button.tag==10) {
//
//    }
//    else if (button.tag==11)
//    {
//
//    }
//    else if (button.tag == 12)
//    {
//
//    }
    [self choosechildController:button];
}
//选择滑到哪一个控制器
-(void)choosechildController:(UIButton *)button{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentScrollowView.contentOffset = CGPointMake(button.tag*MainScreenW, 0);
    }];
    UIViewController *VC= self.childViewControllers[button.tag];
    if (VC.view.superview) {
        return;
    }
    VC.view.frame = CGRectMake(button.tag*MainScreenW,0, MainScreenW,self.contentView.frameHeigh-NavigationBarHeight);
    [self.contentScrollowView addSubview:VC.view];
}

#pragma mark - contentScrollowView
-(UIScrollView *)contentScrollowView
{
    if (!_contentScrollowView) {
        _contentScrollowView = [[UIScrollView alloc]init];
        _contentScrollowView.frame = CGRectMake(0, NavigationBarHeight, self.contentView.frameWidth, self.contentView.frameHeigh-NavigationBarHeight);
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
    RH_SiteMessageSystemNoticeController *systemController= [[RH_SiteMessageSystemNoticeController alloc]init];
    [self addChildViewController:systemController];
    RH_SiteMessageMineNoticeController *mineController = [[RH_SiteMessageMineNoticeController alloc]init];
    [self addChildViewController:mineController];
    RH_SiteMessageSentViewController *sentController = [[RH_SiteMessageSentViewController alloc]init];
    [self addChildViewController:sentController];
    NSInteger count = self.childViewControllers.count;
    self.contentScrollowView.contentSize = CGSizeMake(count*MainScreenW, 0);
}


@end
