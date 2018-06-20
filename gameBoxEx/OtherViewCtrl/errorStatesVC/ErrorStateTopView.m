//
//  ErrorStateTopView.m
//  gameBoxEx
//
//  Created by sam on 2018/4/28.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "ErrorStateTopView.h"
#import "coreLib.h"
//Maintain
@implementation ErrorStateTopView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, MainScreenW, 35)];
    titleImageView.backgroundColor = [UIColor cyanColor];
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *logoName = [NSString stringWithFormat:@"app_logo_%@",SID] ;
    titleImageView.image = ImageWithName(logoName);
    [self addSubview:titleImageView];
    
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,85 , MainScreenW,MainScreenH/3.5+20+NavigationBarHeight+MainScreenH/21-85)];
    backImageView.image = [UIImage imageNamed:@"Maintain"];
    backImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:backImageView];
    
    CGFloat labH = 30;
    CGFloat lab2H = 30;
    CGFloat lineViewH = 1;
    CGFloat lab4H = 95;
    UILabel *lab = [UILabel new];
    [self addSubview:lab];
    
    UILabel *lab2 = [UILabel new];
    [self addSubview:lab2];
    
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    
    UILabel *lab3 = [UILabel new];
    [self addSubview:lab3];
    
    UILabel *lab4 = [UILabel new];
    [self addSubview:lab4];
    
    UIButton *btn1 = [UIButton new];
    [self addSubview:btn1];
    
    
    UIButton *btn2 = [UIButton new];
    [self addSubview:btn2];
    
    UIImageView *imageView = [UIImageView new];
    [self addSubview:imageView];
    
    
    lab.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+MainScreenH/21).whc_Height(labH).whc_LeftSpace(MainScreenW/8.5).whc_RightSpace(MainScreenW/8.5);
    lab.text = @"UNDER MAINTEMANCE";
    lab.textColor = [UIColor lightGrayColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:MainScreenW/15];
    
    lab2.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+MainScreenH/21+labH+10).whc_Height(lab2H).whc_LeftSpace(MainScreenW/8.5).whc_RightSpace(MainScreenW/8.5);
    lab2.text = @"网站维护中， 暂停访问";
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.font = [UIFont systemFontOfSize:MainScreenW/16];
    
    lineView.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+MainScreenH/21+labH+lab2H+10+8).whc_Height(lineViewH).whc_LeftSpace(MainScreenW/8.5).whc_RightSpace(MainScreenW/8.5);
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    lab4.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+MainScreenH/21+labH+lab2H+10+8+8+lineViewH).whc_Height(lab4H).whc_LeftSpace(MainScreenW/8.5).whc_RightSpace(MainScreenW/8.5);
    lab3.textColor = [UIColor redColor];
    lab3.text = @"";
    //    lab4.text = @"由于您所在地不在我们的服务允许范围内，我们暂时无法为您服务，如果您有任何问题，请联系我们的客服。";
    lab4.text = @"抱歉！本系统程序升级，将暂停访问，敬请期待。维护完成时间：于北京时间2018-05-20 08:30-13:00，如果有什么疑问，请联系我们的客服";
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:lab4.text];
    //设置：在单位长度内的内容显示成红色
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(34, 22)];
    lab4.attributedText = str;
    lab4.textAlignment = NSTextAlignmentCenter;
    lab4.font = [UIFont systemFontOfSize:MainScreenW/26];
    lab4.numberOfLines = 4;
    
    btn1.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+MainScreenH/21+labH+lab2H+10+MainScreenH/23+MainScreenH/23+lineViewH+lab4H+8).whc_Height(44).whc_RightSpaceToView(MainScreenW/12, btn2).whc_Width(MainScreenW/3).whc_LeftSpace(MainScreenW/8.5);
    btn1.layer.cornerRadius = 5.0;
    [btn1 setTitle:@"在线客服" forState:UIControlStateNormal];
    [btn1 setImage:ImageWithName(@"cs-white") forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(onlineCUS) forControlEvents:UIControlEventTouchUpInside];
    //    [btn1 setBackgroundImage:ImageWithName(@"cs_btn_bg") forState:UIControlStateNormal];
    
    btn2.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+MainScreenH/21+labH+lab2H+10+MainScreenH/23+MainScreenH/23+lineViewH+lab4H+8).whc_Height(44).whc_LeftSpaceToView(MainScreenW/12, btn1).whc_Width(MainScreenW/3);
    btn2.layer.cornerRadius = 5.0;
    [btn2 setTitle:@"QQ客服" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(qqCUS) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setImage:ImageWithName(@"cs-white") forState:UIControlStateNormal];
    //    [btn2 setBackgroundImage:ImageWithName(@"cs_btn_bg") forState:UIControlStateNormal];
    
    
    
    imageView.image = ImageWithName(@"rectangle");
    imageView.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+MainScreenH/21+labH+lab2H+10+MainScreenH/21+MainScreenH/21+lineViewH+lab4H+8+44+40).whc_Height(10).whc_Width(MainScreenW);
    
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
    ifRespondsSelector(self.delegate, @selector(errorStatusOpenOnlinecustom:)){
        [self.delegate errorStatusOpenOnlinecustom:self];
    }
}
-(void)qqCUS{
    ifRespondsSelector(self.delegate, @selector(errorStatusQQcustom:)){
        [self.delegate errorStatusQQcustom:self];
    }
}
@end
