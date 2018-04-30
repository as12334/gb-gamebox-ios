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
    
    
    lab.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+20).whc_Height(40).whc_LeftSpace(MainScreenW/8.5).whc_RightSpace(MainScreenW/8.5);
    lab.text = @"No ACCESS";
    lab.textColor = [UIColor lightGrayColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:MainScreenW/8.5];
    
    lab2.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+20+40+10).whc_Height(40).whc_LeftSpace(MainScreenW/8.5).whc_RightSpace(MainScreenW/8.5);
    lab2.text = @"您所在的地区禁止访问";
//    lab2.textColor = [UIColor lightGrayColor];
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.font = [UIFont systemFontOfSize:MainScreenW/16];
    
    lineView.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+20+40+40+10+8).whc_Height(1).whc_LeftSpace(MainScreenW/8.5).whc_RightSpace(MainScreenW/8.5);
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    lab4.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+20+40+40+10+8+8+1).whc_Height(85).whc_LeftSpace(MainScreenW/8.5).whc_RightSpace(MainScreenW/8.5);
    lab4.text = @"由于您所在地不在我们的服务允许范围内，我们暂时无法为您服务，如果您有任何问题，请联系我们的客服。";
//    lab4.textColor = [UIColor lightGrayColor];
    lab4.textAlignment = NSTextAlignmentCenter;
    lab4.font = [UIFont systemFontOfSize:MainScreenW/26];
    lab4.numberOfLines = 3;
    
    btn1.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+20+40+40+10+18+18+1+85+8).whc_Height(44).whc_LeftSpace(MainScreenW/8.5);
    [btn1 setTitle:@"在线客服" forState:UIControlStateNormal];
    [btn1 setImage:ImageWithName(@"cs-white") forState:UIControlStateNormal];
    [btn1 setBackgroundImage:ImageWithName(@"cs_btn_bg") forState:UIControlStateNormal];
    
    btn2.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+20+40+40+10+18+18+1+85+8).whc_Height(44).whc_RightSpace(MainScreenW/8.5);
    [btn2 setTitle:@"QQ客服" forState:UIControlStateNormal];
    [btn2 setImage:ImageWithName(@"cs-white") forState:UIControlStateNormal];
    [btn2 setBackgroundImage:ImageWithName(@"cs_btn_bg") forState:UIControlStateNormal];
}

-(void)aaa
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
