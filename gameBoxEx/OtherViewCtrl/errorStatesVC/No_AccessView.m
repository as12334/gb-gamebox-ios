//
//  No_AccessView.m
//  gameBoxEx
//
//  Created by sam on 2018/6/26.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "No_AccessView.h"
#import "coreLib.h"

@implementation No_AccessView
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
    backImageView.image = [UIImage imageNamed:@"No_Access_image"];
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
    
    
    lab.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+MainScreenH/21).whc_Height(labH).whc_LeftSpace(MainScreenW/8.5).whc_RightSpace(MainScreenW/8.5);
    lab.text = @"NO   ACCESS";
    lab.textColor = [UIColor lightGrayColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:MainScreenW/15];
    
    lab2.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+MainScreenH/21+labH+10).whc_Height(lab2H).whc_LeftSpace(MainScreenW/8.5).whc_RightSpace(MainScreenW/8.5);
    lab2.text = @"您所在的地区禁止访问";
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.font = [UIFont systemFontOfSize:MainScreenW/16];
    
    lineView.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+MainScreenH/21+labH+lab2H+10+8).whc_Height(lineViewH).whc_LeftSpace(MainScreenW/8.5).whc_RightSpace(MainScreenW/8.5);
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    lab4.whc_TopSpace(MainScreenH/3.5+20+NavigationBarHeight+MainScreenH/21+labH+lab2H+10+8+8+lineViewH).whc_Height(lab4H).whc_LeftSpace(MainScreenW/8.5).whc_RightSpace(MainScreenW/8.5);
    lab3.textColor = [UIColor redColor];
    lab3.text = @"";
    //    lab4.text = @"由于您所在地不在我们的服务允许范围内，我们暂时无法为您服务，如果您有任何问题，请联系我们的客服。";
    lab4.text = @"由于您所在地不在我们的服务允许范围内，我们暂时无法为您服务！如果有什么疑问，请联系我们的客服。";
    lab4.numberOfLines = 3;
    
}

@end
