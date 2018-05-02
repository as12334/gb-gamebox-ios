//
//  ErrorstatesVC.m
//  gameBoxEx
//
//  Created by sam on 2018/4/28.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "ErrorstatesVC.h"
#import "ErrorStateTopView.h"

@interface ErrorstatesVC ()
@property (nonatomic, strong) ErrorStateTopView *errorStateTopView;
@end

@implementation ErrorstatesVC
@synthesize errorStateTopView = _errorStateTopView;

-(BOOL)hasTopView
{
    return YES;
}

-(CGFloat)topViewHeight
{
    return MainScreenH/3.5;
}

-(ErrorStateTopView *)errorStateTopView
{
    if (!_errorStateTopView) {
        _errorStateTopView = [ErrorStateTopView createInstance];
        _errorStateTopView.frame = self.topView.bounds;
        _errorStateTopView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _errorStateTopView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.topView addSubview:self.errorStateTopView];
    self.hiddenTabBar = YES;
    [self setUI];
   
}

-(void)setUI
{
    CGFloat labH = 30;
    CGFloat lab2H = 30;
    CGFloat lineViewH = 1;
//    CGFloat lab3H = 30;
    CGFloat lab4H = 95;
    UILabel *lab = [UILabel new];
    [self.view addSubview:lab];
    
    UILabel *lab2 = [UILabel new];
    [self.view addSubview:lab2];
    
    UIView *lineView = [UIView new];
    [self.view addSubview:lineView];
    
    UILabel *lab3 = [UILabel new];
    [self.view addSubview:lab3];
    
    UILabel *lab4 = [UILabel new];
    [self.view addSubview:lab4];
    
    UIButton *btn1 = [UIButton new];
    [self.view addSubview:btn1];
    
    
    UIButton *btn2 = [UIButton new];
    [self.view addSubview:btn2];
    
    
    lab.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+20).whc_Height(labH).whc_LeftSpace(MainScreenW/8.5).whc_RightSpace(MainScreenW/8.5);
    lab.text = @"UNDER MAINTEMANCE";
    lab.textColor = [UIColor lightGrayColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:MainScreenW/15];
    
    lab2.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+20+labH+10).whc_Height(lab2H).whc_LeftSpace(MainScreenW/8.5).whc_RightSpace(MainScreenW/8.5);
    lab2.text = @"网站维护中，暂停访问";
//    lab2.textColor = [UIColor lightGrayColor];
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.font = [UIFont systemFontOfSize:MainScreenW/16];
    
    lineView.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+20+labH+lab2H+10+8).whc_Height(lineViewH).whc_LeftSpace(MainScreenW/8.5).whc_RightSpace(MainScreenW/8.5);
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    lab4.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+20+labH+lab2H+10+8+8+lineViewH).whc_Height(lab4H).whc_LeftSpace(MainScreenW/8.5).whc_RightSpace(MainScreenW/8.5);
//    lab4.text = @"由于您所在地不在我们的服务允许范围内，我们暂时无法为您服务，如果您有任何问题，请联系我们的客服。";
    lab4.text = @"抱歉！本系统程序升级，将暂停访问，敬请期待。维护完成时间：于北京时间2018-05-20 08:30-13:00，如果有什么疑问，请联系我们的客服";
//    lab4.textColor = [UIColor lightGrayColor];
    lab4.textAlignment = NSTextAlignmentCenter;
    lab4.font = [UIFont systemFontOfSize:MainScreenW/26];
    lab4.numberOfLines = 4;
    
    btn1.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+20+labH+lab2H+10+18+18+lineViewH+lab4H+8).whc_Height(44).whc_RightSpaceToView(15, btn2).whc_LeftSpace(MainScreenW/8.5);
    btn1.layer.cornerRadius = 5.0;
    [btn1 setTitle:@"在线客服" forState:UIControlStateNormal];
    [btn1 setImage:ImageWithName(@"cs-white") forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(onlineCUS) forControlEvents:UIControlEventTouchUpInside];
//    [btn1 setBackgroundImage:ImageWithName(@"cs_btn_bg") forState:UIControlStateNormal];
    
    btn2.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+20+labH+lab2H+10+18+18+lineViewH+lab4H+8).whc_Height(44).whc_LeftSpaceToView(15, btn1).whc_RightSpace(MainScreenW/8.5);
    btn2.layer.cornerRadius = 5.0;
    [btn2 setTitle:@"QQ客服" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(qqCUS) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setImage:ImageWithName(@"cs-white") forState:UIControlStateNormal];
//    [btn2 setBackgroundImage:ImageWithName(@"cs_btn_bg") forState:UIControlStateNormal];
    
    if ([THEMEV3 isEqualToString:@"red"]||[THEMEV3 isEqualToString:@"red_white"]) {
        btn1.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
        btn2.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
    }else if ([THEMEV3 isEqualToString:@"green"]||[THEMEV3 isEqualToString:@"green_white"]){
        btn1.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
        btn2.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
    }else if ([THEMEV3 isEqualToString:@"default"]||[THEMEV3 isEqualToString:@"blue"]){
        btn1.backgroundColor = RH_NavigationBar_BackgroundColor_Blue;
        btn2.backgroundColor = RH_NavigationBar_BackgroundColor_Blue;
    }else if ([THEMEV3 isEqualToString:@"orange"]||[THEMEV3 isEqualToString:@"orange_white"]){
        btn1.backgroundColor = RH_NavigationBar_BackgroundColor_Orange;
        btn2.backgroundColor = RH_NavigationBar_BackgroundColor_Orange;
    }else if ([THEMEV3 isEqualToString:@"coffee_white"]||[THEMEV3 isEqualToString:@"coffee_black"]){
        btn1.backgroundColor = RH_NavigationBar_BackgroundColor_Orange;
        btn2.backgroundColor = RH_NavigationBar_BackgroundColor_Orange;
    }else{
        btn1.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
        btn2.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
    }
}

-(void)onlineCUS
{
    
}

-(void)qqCUS
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
