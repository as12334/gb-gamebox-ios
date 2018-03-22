//
//  RH_LimitTransferTopView.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_LimitTransferTopView.h"
#import "coreLib.h"

@implementation RH_LimitTransferTopView
{
    UIView *topView ;
    UILabel *transferLab ;  //转账处理中
    UILabel *moneyLab ;  //金额显示
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self configUI] ;
    }
    return self ;
}

-(void)configUI
{
    self.backgroundColor = colorWithRGB(239, 239, 239) ;
    topView = [[UIView alloc] init];
    [self addSubview:topView];
    topView.whc_LeftSpace(0).whc_TopSpace(0).whc_RightSpace(0).whc_Height(40.f) ;
    topView.backgroundColor = [UIColor whiteColor] ;
    transferLab = [[UILabel alloc] init] ;
    [topView addSubview:transferLab];
    transferLab.whc_LeftSpace(20).whc_TopSpace(10).whc_BottomSpace(10).whc_WidthAuto() ;
    transferLab.text = @"转账处理中：";
    transferLab.textColor = colorWithRGB(153, 153, 153) ;
    transferLab.font = [UIFont systemFontOfSize:12.f] ;
    
    moneyLab = [[UILabel alloc] init];
    [topView addSubview:moneyLab] ;
    moneyLab.whc_LeftSpaceToView(0, transferLab).whc_TopSpace(10.f).whc_BottomSpace(10).whc_WidthAuto() ;
    moneyLab.text =@"￥0.00";
    moneyLab.font = [UIFont systemFontOfSize:12.f] ;
    moneyLab.textColor = [UIColor orangeColor] ;
    
    
    UIView *bottomView = [[UIView alloc] init ];
    [self addSubview:bottomView];
    bottomView.whc_LeftSpace(0).whc_TopSpaceToView(10, topView).whc_RightSpace(0).whc_Height(120) ;
    bottomView.backgroundColor = [UIColor whiteColor] ;
    
    UIView *transferOutView = [UIView new] ; //转出账户
    [bottomView addSubview:transferOutView];
    transferOutView.whc_LeftSpace(0).whc_TopSpace(0).whc_RightSpace(0).whc_Height(39) ;
  
    
    UILabel *transferOutLab = [UILabel new] ;
    [transferOutView addSubview:transferOutLab];
    transferOutLab.whc_LeftSpace(10).whc_CenterY(0).whc_HeightAuto().whc_WidthAuto() ;
    transferOutLab.text = @"转出账户" ;
    transferOutLab.font = [UIFont systemFontOfSize:14.f] ;
    
    UIButton *transferOutBtn = [UIButton new] ;
    [transferOutView addSubview:transferOutBtn];
    transferOutBtn.whc_RightSpace(10).whc_CenterY(0).whc_HeightAuto().whc_WidthAuto() ;
    [transferOutBtn setTitle:@"我的钱包" forState:UIControlStateNormal];
    [transferOutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    transferOutBtn.titleLabel.font = [UIFont systemFontOfSize:14.f] ;
    [transferOutBtn setTitleColor:colorWithRGB(153, 153, 153) forState:UIControlStateNormal];
                               
    
    
    UILabel *line1 = [[UILabel alloc] init] ;
    [bottomView addSubview:line1];
    line1.whc_LeftSpace(10).whc_TopSpaceToView(0, transferOutView).whc_RightSpace(0).whc_Height(1.f) ;
    line1.backgroundColor = colorWithRGB(242, 242, 242) ;
    /******/
    UIView *transferInView = [UIView new] ; // 转入账户
    [bottomView addSubview:transferInView] ;
    transferInView.whc_LeftSpace(0).whc_TopSpaceToView(0, line1).whc_RightSpace(0).whc_Height(39) ;
    
    UILabel *transferInLab = [UILabel new] ;
    [transferInView addSubview:transferInLab];
    transferInLab.whc_LeftSpace(10).whc_CenterY(0).whc_HeightAuto().whc_WidthAuto() ;
    transferInLab.text = @"转入账户" ;
    transferInLab.font = [UIFont systemFontOfSize:14.f] ;
    
    UIButton *transferInBtn = [UIButton new] ;
    [transferInView addSubview:transferInBtn];
    transferInBtn.whc_RightSpace(10).whc_CenterY(0).whc_HeightAuto().whc_WidthAuto() ;
    [transferInBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [transferInBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    transferInBtn.titleLabel.font = [UIFont systemFontOfSize:14.f] ;
    [transferInBtn setTitleColor:colorWithRGB(153, 153, 153) forState:UIControlStateNormal];
    
    UILabel *line2 = [[UILabel alloc] init] ;
    [bottomView addSubview:line2];
    line2.whc_LeftSpace(10).whc_TopSpaceToView(0, transferInView).whc_RightSpace(0).whc_Height(1.f) ;
    line2.backgroundColor = colorWithRGB(242, 242, 242) ;
    
    UIView *amountView = [UIView new] ; // 金额
    [bottomView addSubview:amountView];
    amountView.whc_LeftSpace(0).whc_TopSpaceToView(0, line2).whc_RightSpace(0).whc_Height(39) ;
    
    UILabel *amountLab = [UILabel new] ;
    [amountView addSubview:amountLab];
    amountLab.whc_LeftSpace(10).whc_CenterY(0).whc_HeightAuto().whc_WidthAuto() ;
    amountLab.text = @"金额" ;
    amountLab.font = [UIFont systemFontOfSize:14.f] ;
    
    UITextField *amountTextfield = [UITextField new] ;
    [amountView addSubview:amountTextfield];
    amountTextfield.whc_RightSpace(10).whc_CenterY(0).whc_HeightAuto().whc_WidthAuto() ;
    amountTextfield.placeholder = @"请输入" ;
    amountTextfield.font = [UIFont systemFontOfSize:14.f] ;
    amountTextfield.textAlignment = NSTextAlignmentRight ;
    
    UILabel *line3 = [[UILabel alloc] init] ;
    [bottomView addSubview:line3];
    line3.whc_LeftSpace(0).whc_TopSpaceToView(0, amountView).whc_RightSpace(0).whc_Height(1.f) ;
    line3.backgroundColor = colorWithRGB(242, 242, 242) ;
    
    
    UIButton *sureSubmitBtn = [UIButton new] ;
    [self addSubview:sureSubmitBtn] ;
    sureSubmitBtn.whc_LeftSpace(10).whc_TopSpaceToView(10, bottomView).whc_RightSpace(10).whc_Height(40.f) ;
    [sureSubmitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [sureSubmitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [sureSubmitBtn addTarget:self action:@selector(sureSubmitClick:) forControlEvents:UIControlEventTouchUpInside] ;
    sureSubmitBtn.layer.cornerRadius = 5;
    sureSubmitBtn.layer.masksToBounds = YES;
    sureSubmitBtn.titleLabel.font = [UIFont systemFontOfSize:14.f] ;
    
    if ([THEMEV3 isEqualToString:@"green"]){
        sureSubmitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
        sureSubmitBtn.layer.borderColor = RH_NavigationBar_BackgroundColor_Green.CGColor;
    }else if ([THEMEV3 isEqualToString:@"red"]){
        sureSubmitBtn.backgroundColor =RH_NavigationBar_BackgroundColor_Red;
        sureSubmitBtn.layer.borderColor = RH_NavigationBar_BackgroundColor_Red.CGColor;
    }else if ([THEMEV3 isEqualToString:@"black"]){
        sureSubmitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
        sureSubmitBtn.layer.borderColor = RH_NavigationBar_BackgroundColor_Black.CGColor;
    }else{
        sureSubmitBtn.backgroundColor = RH_NavigationBar_BackgroundColor;
        sureSubmitBtn.layer.borderColor = RH_NavigationBar_BackgroundColor.CGColor;;
    }
    
    UIButton *refreshBalanceBtn = [UIButton new] ;
    [self addSubview:refreshBalanceBtn];
    refreshBalanceBtn.whc_TopSpaceToView(10, sureSubmitBtn).whc_RightSpace(10).whc_Height(25).whc_Width(60) ;
    [refreshBalanceBtn setTitle:@"刷新余额" forState:UIControlStateNormal];
    refreshBalanceBtn.backgroundColor =[UIColor whiteColor] ;
    refreshBalanceBtn.layer.borderWidth = 0.5f;
    refreshBalanceBtn.layer.borderColor = [UIColor grayColor].CGColor ;
    [refreshBalanceBtn setTitleColor:colorWithRGB(153, 153, 153) forState:UIControlStateNormal];
    refreshBalanceBtn.titleLabel.font = [UIFont systemFontOfSize:12.f] ;
    refreshBalanceBtn.layer.cornerRadius = 5;
    refreshBalanceBtn.layer.masksToBounds =  YES ;
    
}

-(void)sureSubmitClick:(UIButton *)sender
{
    
}
@end
