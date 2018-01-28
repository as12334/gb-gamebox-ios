//
//  RH_StaticAlertView.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/28.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_StaticAlertView.h"
#import "coreLib.h"
@interface RH_StaticAlertView()
@property (nonatomic, strong) UIButton      *cancelButton;
@end
@implementation RH_StaticAlertView
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
        imageV.whc_Center(0, -20).whc_Width(190).whc_Height(190);
        imageV.image = ImageWithName(@"gongxi");
        
        label_Notice = [UILabel new];
        [contentView addSubview:label_Notice];
        label_Notice.whc_CenterX(0).whc_TopSpaceToView(10, imageV).whc_LeftSpace(20).whc_RightSpace(20).whc_Height(20);
        label_Notice.text = @"您已修改成功！";
        label_Notice.font = [UIFont systemFontOfSize:13];
        label_Notice.textColor = RH_Label_DefaultTextColor;
        label_Notice.textAlignment = NSTextAlignmentCenter;
        
        self.cancelButton = [[UIButton alloc] init];
        [self.cancelButton setImage:ImageWithName(@"home_announce_close") forState:UIControlStateNormal];
        [self addSubview:self.cancelButton];
        self.cancelButton.whc_TopSpaceToView(5, contentView).whc_CenterX(0).whc_Width(70).whc_Height(70);
        self.cancelButton.layer.cornerRadius = 35;
        self.clipsToBounds = YES;
        self.cancelButton.alpha = 0;
        [self.cancelButton addTarget:self action:@selector(cancelButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
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
        }
    }];
}
@end
