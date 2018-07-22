//
//  RH_StaticAlertView.m
//  gameBoxEx
//
//  Created by Richard on 2018/4/2.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositSuccessAlertView.h"
#import "coreLib.h"
@interface RH_DepositSuccessAlertView()
@property (nonatomic, strong) UIButton      *cancelButton;
@end
@implementation RH_DepositSuccessAlertView
{
    UIView *contentView;
    UILabel *label_Notice;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        contentView = [UIView new];
        [self addSubview:contentView];
        contentView.whc_Center(0, 0).whc_Width(screenSize().width*3/5).whc_Height(screenSize().width*4/5);
        contentView.backgroundColor = colorWithRGB(255, 255, 255);
        contentView.transform = CGAffineTransformMakeScale(0, 0);
        contentView.layer.cornerRadius = 10;
        contentView.clipsToBounds = YES;
        self.backgroundColor = ColorWithRGBA(134, 134, 134, 0.3);
        
        UIImageView *imageV = [UIImageView new];
        [contentView addSubview:imageV];
        imageV.whc_Center(0, -100).whc_Width(130).whc_Height(130);
        imageV.image = ImageWithName(@"gongxi");
        
        label_Notice = [UILabel new];
        [contentView addSubview:label_Notice];
        label_Notice.whc_CenterX(0).whc_TopSpaceToView(8, imageV).whc_LeftSpace(20).whc_RightSpace(20).whc_Height(20);
        label_Notice.text = @"存款成功";
        label_Notice.font = [UIFont boldSystemFontOfSize:17];
        label_Notice.textColor = colorWithRGB(66, 164, 79);
        label_Notice.textAlignment = NSTextAlignmentCenter;
        
        UILabel *subLab1 = [UILabel new] ;
        [contentView addSubview:subLab1];
        subLab1.whc_CenterX(0).whc_TopSpaceToView(13, label_Notice).whc_LeftSpace(20).whc_RightSpace(20).whc_Height(20);
        subLab1.textColor = colorWithRGB(68, 68, 68) ;
        subLab1.font = [UIFont systemFontOfSize:14.f] ;
        subLab1.textAlignment = NSTextAlignmentCenter ;
        subLab1.text = @"正在等待系统处理";
        
        UILabel *subLab2 = [UILabel new] ;
        [contentView addSubview:subLab2];
        subLab2.whc_CenterX(0).whc_TopSpaceToView(5, subLab1).whc_LeftSpace(20).whc_RightSpace(20).whc_Height(20);
        subLab2.textColor = colorWithRGB(68, 68, 68) ;
        subLab2.font = [UIFont systemFontOfSize:14.f] ;
        subLab2.textAlignment = NSTextAlignmentCenter ;
        subLab2.text = @"请注意查看钱包余额" ;
        
        UIButton *saveAgainBtn = [UIButton new] ;
        [contentView addSubview:saveAgainBtn];
        saveAgainBtn.whc_LeftSpace(20).whc_TopSpaceToView(20, subLab2).whc_RightSpace(20).whc_Height(35) ;
        [saveAgainBtn setTitle:@"再存一次" forState:UIControlStateNormal];
        saveAgainBtn.layer.cornerRadius = 5.f ;
        saveAgainBtn.layer.masksToBounds = YES ;
        saveAgainBtn.backgroundColor = colorWithRGB(27, 117, 217) ;
        saveAgainBtn.titleLabel.font = [UIFont systemFontOfSize:14.f] ;
        [saveAgainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveAgainBtn addTarget:self action:@selector(saveAgainBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *checkCapitalBtn = [UIButton new] ;
        [contentView addSubview:checkCapitalBtn];
        checkCapitalBtn.whc_LeftSpace(20).whc_TopSpaceToView(8, saveAgainBtn).whc_RightSpace(20).whc_Height(35) ;
        [checkCapitalBtn setTitle:@"查看资金记录" forState:UIControlStateNormal];
        checkCapitalBtn.layer.cornerRadius = 5.f ;
        checkCapitalBtn.layer.masksToBounds = YES ;
        checkCapitalBtn.backgroundColor = [UIColor whiteColor] ;
        checkCapitalBtn.titleLabel.font = [UIFont systemFontOfSize:14.f] ;
        [checkCapitalBtn setTitleColor:colorWithRGB(68, 68, 68) forState:UIControlStateNormal];
        checkCapitalBtn.layer.borderWidth = 1.f;
        checkCapitalBtn.layer.borderColor = colorWithRGB(226, 226, 226).CGColor ;
        [checkCapitalBtn addTarget:self action:@selector(checkCapitalBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.cancelButton = [[UIButton alloc] init];
        if ([THEMEV3 isEqualToString:@"green"]||[THEMEV3 isEqualToString:@"green_white"]){
            [self.cancelButton setImage:ImageWithName(@"home_announce_close_green") forState:UIControlStateNormal];
            
        }else if ([THEMEV3 isEqualToString:@"red"]||[THEMEV3 isEqualToString:@"red_white"]){
            [self.cancelButton setImage:ImageWithName(@"home_announce_close_red") forState:UIControlStateNormal];
            
        }else if ([THEMEV3 isEqualToString:@"black"]){
            [self.cancelButton setImage:ImageWithName(@"home_announce_close_black") forState:UIControlStateNormal];
            
        }else if ([THEMEV3 isEqualToString:@"orange"]||[THEMEV3 isEqualToString:@"orange_white"]){
            //shaole
            [self.cancelButton setImage:ImageWithName(@"home_announce_close_orange") forState:UIControlStateNormal];
        }else if ([THEMEV3 isEqualToString:@"coffee_black"]||[THEMEV3 isEqualToString:@"coffee_white"]){
            //shaole
            [self.cancelButton setImage:ImageWithName(@"home_announce_close_coffee") forState:UIControlStateNormal];
        }else{
            [self.cancelButton setImage:ImageWithName(@"home_announce_close_default") forState:UIControlStateNormal];
        }
        
        [self addSubview:self.cancelButton];
        self.cancelButton.whc_TopSpaceToView(5, contentView).whc_CenterX(0).whc_Width(70).whc_Height(70);
        self.cancelButton.layer.cornerRadius = 35;
        self.clipsToBounds = YES;
        self.cancelButton.alpha = 0;
        [self.cancelButton addTarget:self action:@selector(cancelButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
#pragma mark - 再存一次
-(void)saveAgainBtnClick
{
    ifRespondsSelector(self.delegate, @selector(depositSuccessAlertViewDidTouchSaveAgainBtn)){
        [self.delegate depositSuccessAlertViewDidTouchSaveAgainBtn] ;
    }
}

#pragma mark - 查看资金记录
-(void)checkCapitalBtnClick
{
    ifRespondsSelector(self.delegate, @selector(depositSuccessAlertViewDidTouchCheckCapitalBtn)){
        [self.delegate depositSuccessAlertViewDidTouchCheckCapitalBtn] ;
    }
}

- (void)showContentView {
    
    [UIView animateWithDuration:0.3 animations:^{
        contentView.transform = CGAffineTransformIdentity;
        self.cancelButton.alpha = 1;
    }];
}

- (void)cancelButtonDidTap:(UIButton *)button {
    
    [UIView animateWithDuration:0.3 animations:^{
        contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        contentView.alpha = 0.1;
        self.cancelButton.alpha = 0.1;
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            ifRespondsSelector(self.delegate, @selector(depositSuccessAlertViewDidTouchCancelButton)) {
                [self.delegate depositSuccessAlertViewDidTouchCancelButton];
            }
        }
    }];
}
@end
