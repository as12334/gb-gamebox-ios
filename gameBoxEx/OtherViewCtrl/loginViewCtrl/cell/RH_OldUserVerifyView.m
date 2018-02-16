//
//  RH_OldUserVerifyView.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_OldUserVerifyView.h"
#import "coreLib.h"

@interface RH_OldUserVerifyView ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *realNameField ;
@end
@implementation RH_OldUserVerifyView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor] ;
        self.layer.cornerRadius = 10.f;
        self.layer.masksToBounds = YES;
        UILabel *topLab = [[UILabel alloc] init];
        [self addSubview:topLab];
        topLab.whc_LeftSpace(0).whc_TopSpace(0).whc_RightSpace(0).whc_Height(30);
        topLab.textAlignment = NSTextAlignmentLeft ;
        topLab.font = [UIFont systemFontOfSize:14.f] ;
        topLab.textColor = [UIColor whiteColor] ;
        topLab.text = @"   姓名验证" ;
        topLab.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
        
        UIView *middleView = [[UIView alloc] init];
        [self addSubview:middleView];
        middleView.whc_LeftSpace(20).whc_TopSpaceToView(10, topLab).whc_RightSpace(20).whc_Height(80);
        middleView.backgroundColor = [UIColor grayColor] ;
        
        UILabel *tishiLab = [[UILabel alloc] init];
        [middleView addSubview:tishiLab];
        tishiLab.whc_TopSpace(10).whc_LeftSpace(10).whc_RightSpace(10).whc_BottomSpace(10) ;
        tishiLab.numberOfLines = 0 ;
        tishiLab.text = @"本次升级，加强了账户的安全防护体系，请验证真实姓名，验证通过后即可成功登陆";
        tishiLab.font = [UIFont systemFontOfSize:12.f] ;
        
        UILabel *tipLab = [[UILabel alloc] init];
        [self addSubview:tipLab];
        tipLab.whc_TopSpaceToView(20, middleView).whc_LeftSpace(20).whc_Height(20).whc_WidthAuto();
        tipLab.textAlignment = NSTextAlignmentLeft ;
        tipLab.text = @"请输入真实姓名：";
        tipLab.font = [UIFont systemFontOfSize:14.f] ;
        
        _realNameField = [[UITextField alloc] init];
        [self addSubview:_realNameField];
        _realNameField.whc_TopSpaceToView(5, tipLab).whc_LeftSpace(20).whc_RightSpace(20).whc_Height(30);
        _realNameField.placeholder = @"请输入真实姓名";
        _realNameField.layer.borderWidth = 1.f;
        _realNameField.delegate = self ;
        _realNameField.layer.borderColor = colorWithRGB(242, 242, 242).CGColor;
        
        
        UIButton *sureBtn = [UIButton new] ;
        [self addSubview:sureBtn];
        sureBtn.whc_LeftSpace(30).whc_TopSpaceToView(20, _realNameField).whc_Height(30).whc_Width(100) ;
        sureBtn.backgroundColor =RH_NavigationBar_BackgroundColor_Green;
        sureBtn.titleLabel.textColor = [UIColor whiteColor] ;
        [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *cancleBtn = [UIButton new] ;
        [self addSubview:cancleBtn];
        cancleBtn.backgroundColor = [UIColor whiteColor];
        cancleBtn.titleLabel.textColor = [UIColor whiteColor] ;
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self ;
}
#pragma mark -确定按钮点击
-(void)sureBtnClick
{
    ifRespondsSelector(self.delegate, @selector(oldUserVerifyViewDidTochSureBtn:withRealName:)){
        [self.delegate oldUserVerifyViewDidTochSureBtn:self withRealName:_realNameField.text] ;
    }
}
#pragma mark - 取消
-(void)cancleBtnClick
{
    ifRespondsSelector(self.delegate, @selector(oldUserVerifyViewDidTochCancleBtn:)){
        [self.delegate oldUserVerifyViewDidTochCancleBtn:self] ;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
