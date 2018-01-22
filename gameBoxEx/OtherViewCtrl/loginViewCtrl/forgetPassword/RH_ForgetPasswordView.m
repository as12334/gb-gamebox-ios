//
//  RH_ForgetPasswordView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/21.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ForgetPasswordView.h"
@interface RH_ForgetPasswordView()
@property (weak, nonatomic) IBOutlet UIView *passwordView;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@end
@implementation RH_ForgetPasswordView
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    _passwordView.layer.cornerRadius = 5;
    _passwordView.layer.borderWidth = 1.f;
    _passwordView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _passwordView.layer.masksToBounds = YES;
    _submitBtn.layer.cornerRadius = 5;
    _submitBtn.layer.borderWidth = 1.f;
    _submitBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _submitBtn.layer.masksToBounds = YES;
}
@end
