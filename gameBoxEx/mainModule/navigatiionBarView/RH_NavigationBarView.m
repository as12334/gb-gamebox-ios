//
//  RH_SubNavigationBarView.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/20.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_NavigationBarView.h"
#import "coreLib.h"
#import "RH_userInfoView.h"
#import "RH_UserInfoManager.h"
#import "RH_APPDelegate.h"
#import "RH_NavigationUserInfoView.h"

@interface RH_NavigationBarView ()
@property(nonatomic,weak) IBOutlet UILabel *labTitle    ;
@property(nonatomic,weak) IBOutlet UIImageView *logoImageView ;
@property(nonatomic,weak) IBOutlet UIView *navigationBarView ;

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *layoutImageWidth ;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *layoutImageHeight ;
@property (nonatomic,strong) CLButton *loginButton ;
@property (nonatomic,strong) CLButton *signButton ;
@property (nonatomic,strong) RH_NavigationUserInfoView *userInfoBtnView ;

@end


@implementation RH_NavigationBarView
@synthesize loginButton = _loginButton ;
@synthesize signButton = _signButton   ;
@synthesize userInfoBtnView = _userInfoBtnView ;

-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.backgroundColor = RH_NavigationBar_BackgroundColor ;
    self.labTitle.font = RH_NavigationBar_TitleFontSize ;
    self.labTitle.textColor = RH_NavigationBar_ForegroundColor ;

    NSString *logoName = [NSString stringWithFormat:@"app_logo_%@",SID] ;
    UIImage *menuImage = ImageWithName(logoName);
    self.layoutImageWidth.constant = menuImage.size.width ;
    self.layoutImageHeight.constant = menuImage.size.height ;
    self.logoImageView.image =  menuImage ;
    self.labTitle.text = @"" ;
    
    [self updateView] ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:NT_LoginStatusChangedNotification object:nil] ;
    UIView *line = [UIView new];
    [self addSubview:line];
    line.whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0).whc_Height(1);
    line.backgroundColor = colorWithRGB(107, 172, 244);
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

#pragma mark-
-(void)handleNotification:(NSNotification*)nt
{
    if ([nt.name isEqualToString:NT_LoginStatusChangedNotification]){
        [self performSelectorOnMainThread:@selector(updateView) withObject:self waitUntilDone:NO] ;
    }
}

-(void)updateTitle:(NSString*)title
{
    self.labTitle.text = title ;
}

#pragma mark -updateView
-(void)updateView
{
    if ([RH_UserInfoManager shareUserManager].hasLogin){
        //已login
        if (_loginButton.superview){
            [_loginButton removeFromSuperview] ;
            [_loginButton whc_ResetConstraints];
        }
        
        if (_signButton.superview){
            [_signButton removeFromSuperview] ;
            [_signButton whc_ResetConstraints];
        }
        
        if (_userInfoBtnView.superview==nil){
            [self.navigationBarView addSubview:self.userInfoBtnView] ;
        }
        
        [self.userInfoBtnView whc_ResetConstraints] ;
        self.userInfoBtnView.whc_RightSpace(10).whc_CenterY(0).whc_Width(75).whc_Height(40) ;
    }else{
        if (_loginButton.superview==nil){
            [self.navigationBarView addSubview:self.loginButton] ;
        }
        
        if (_signButton.superview==nil){
            [self.navigationBarView addSubview:self.signButton] ;
        }
        
        if (_userInfoBtnView.superview){
            [_userInfoBtnView removeFromSuperview] ;
        }
        
        [self.signButton whc_ResetConstraints] ;
        [self.loginButton whc_ResetConstraints] ;
        self.signButton.whc_RightSpace(10).whc_CenterY(0).whc_Width(40).whc_Height(27) ;
        self.loginButton.whc_RightSpaceToView(10, self.signButton).whc_CenterY(0).whc_Width(40).whc_Height(27) ;
    }
}

#pragma mark- loginButton
-(CLButton *)loginButton
{
    if (!_loginButton){
        _loginButton = [CLButton buttonWithType:UIButtonTypeSystem];
        _loginButton.frame = CGRectMake(0, 0, 40,27);
        [_loginButton setBackgroundColor:colorWithRGB(29, 194, 142) forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal] ;
        [_loginButton addTarget:self action:@selector(_loginButtonHandle) forControlEvents:UIControlEventTouchUpInside] ;
        _loginButton.layer.cornerRadius = 4.0f ;
        _loginButton.layer.masksToBounds = YES ;
        [_loginButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]] ;
    }
    
    return _loginButton ;
}

-(void)_loginButtonHandle
{
    ifRespondsSelector(self.delegate, @selector(navigationBarViewDidTouchLoginButton:)){
        [self.delegate navigationBarViewDidTouchLoginButton:self] ;
    }
}

#pragma mark-
-(CLButton *)signButton
{
    if (!_signButton){
        _signButton = [CLButton buttonWithType:UIButtonTypeSystem];
        _signButton.frame = CGRectMake(0, 0, 40,27);
        [_signButton setBackgroundColor:colorWithRGB(240, 175, 1) forState:UIControlStateNormal];
        [_signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        [_signButton setTitle:@"注册" forState:UIControlStateNormal] ;
        [_signButton addTarget:self action:@selector(_signButtonHandle) forControlEvents:UIControlEventTouchUpInside] ;
        _signButton.layer.cornerRadius = 4.0f ;
        _signButton.layer.masksToBounds = YES ;
        [_signButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]] ;
    }
    
    return _signButton ;
}

-(void)_signButtonHandle
{
    ifRespondsSelector(self.delegate, @selector(navigationBarViewDidTouchSignButton:)){
        [self.delegate navigationBarViewDidTouchSignButton:self] ;
    }
}


#pragma mark - userInfoView
-(RH_NavigationUserInfoView *)userInfoBtnView
{
    if (!_userInfoBtnView){
        _userInfoBtnView = [RH_NavigationUserInfoView createInstance] ;
        [_userInfoBtnView.buttonCover addTarget:self
                                                action:@selector(_userInfoBtnViewHandle) forControlEvents:UIControlEventTouchUpInside] ;
        _userInfoBtnView.frame = CGRectMake(0, 0, 75.0f, 40.0f) ;
    }
    
    return _userInfoBtnView ;
}

-(void)_userInfoBtnViewHandle
{
    ifRespondsSelector(self.delegate, @selector(navigationBarViewDidTouchUserInfoButton:)){
        [self.delegate navigationBarViewDidTouchUserInfoButton:self];
    }
}

@end
