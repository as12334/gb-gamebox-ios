//
//  RH_LoginViewController.m
//  TaskTracking
//
//  Created by apple pro on 2017/2/18.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_LoginViewController.h"
#import "RH_CommonInputContainerView.h"
#import "coreLib.h"
#import "RH_UserManager.h"


@interface RH_LoginViewController ()<UITextFieldDelegate>
@property(nonatomic,strong) IBOutlet UIScrollView *scrollView ;
@property (strong, nonatomic) IBOutlet RH_CommonInputContainerView *phoneNumberInputView;
@property (strong, nonatomic) IBOutlet RH_CommonInputContainerView *passwordInputView;
@property (strong,nonatomic) IBOutlet UIImageView *loginICON ;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *layoutICONWidth ;

@property(strong,nonatomic) IBOutlet   CLButton *loginButton ;

@end

@implementation RH_LoginViewController
RH_LoginViewController * _shareLoginViewController = nil;
+(instancetype)shareLoginViewController{
    return _shareLoginViewController ;
}

-(BOOL)hasNavigationBar
{
    return NO ;
}

-(CLViewControllerDesignatedShowWay)viewControllerDesignatedShowWay
{
    return CLViewControllerDesignatedShowWayPresent ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _shareLoginViewController = self ;
    self.hiddenStatusBar = YES ;
    
    self.scrollView.backgroundColor = [UIColor clearColor] ;
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.contentInset = UIEdgeInsetsMake(NavigationBarHeight + StatusBarHeight, 0.f, 44.f, 0.f);
    [self.contentView addSubview:self.scrollView] ;
    
    self.needObserverKeyboard = YES ;
    self.adjustFrameBasicKeyboardView = self.scrollView ;
    self.needObserverTapGesture = YES ;
    
    self.phoneNumberInputView.type = RH_CommonInputContainerViewTypeLine;
    self.passwordInputView.type = RH_CommonInputContainerViewTypeLine;
    
    self.phoneNumberInputView.textField.delegate = self ;
    self.passwordInputView.textField.delegate = self ;
    
    [self.loginICON setImage:ImageWithName(@"ic_login_Big")] ;
    
    [self.phoneNumberInputView.textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"请输入用户名" attributes:@{NSFontAttributeName : self.phoneNumberInputView.textField.font, NSForegroundColorAttributeName : ColorWithNumberRGB(0xcacaca)}]];
    [self.passwordInputView.textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSFontAttributeName : self.passwordInputView.textField.font, NSForegroundColorAttributeName : ColorWithNumberRGB(0xcacaca)}]];
    
    [self setLoginICONSize:CGSizeMake(102.0f, 102.0f)] ;
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews] ;
    if (self.needObserverKeyboard){
        [self adjustViewFrameBasicKeyboard] ;
    }
}

-(void)setLoginICONSize:(CGSize)cgsize
{
    if (!CGSizeEqualToSize(cgsize, self.loginICON.bounds.size)){
        CGSize screenSize = [UIScreen mainScreen].bounds.size ;
        self.loginICON.frame = CGRectMake(floorf((screenSize.width - cgsize.width)/2.0), 30.0f, cgsize.width, cgsize.height) ;
    }
}

#pragma mark -

-(void)textFieldDidChangeText:(UITextField *)textField{
    [self _updateLoginButtonStatus];
}

-(void)_updateLoginButtonStatus
{
    self.loginButton.enabled = (self.phoneNumberInputView.textField.text.length && self.passwordInputView.textField.text.length);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.phoneNumberInputView.textField) {
        [self.passwordInputView.textField becomeFirstResponder];
    }else if (self.loginButton.enabled){
        [self _loginButtonHandle:nil];
    }else{
        [self.passwordInputView.textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.passwordInputView.textField && textField.isSecureTextEntry ) {
        textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        [self _updateLoginButtonStatus];
        return NO;
    }
    
    return YES;
}

#pragma mark-
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return self.phoneNumberInputView.textField.isEditing || self.passwordInputView.textField.isEditing ;
}

-(void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.contentView endEditing:YES] ;
}

-(void)keyboardFrameDidChange
{
    //针对不同的输入焦点，来调整 offset
    CGPoint offset = CGPointZero ;
    if ([self.phoneNumberInputView.textField isFirstResponder]){
        CGFloat height = CGRectGetMaxY([self.phoneNumberInputView.textField convertRect:self.phoneNumberInputView.bounds toView:self.scrollView]) ;
        offset.y = height - self.scrollView.frameHeigh  ;

        if (self.scrollView.contentOffset.y<offset.y){
            [UIView animateWithDuration:.5f animations:^{
                self.scrollView.contentOffset = offset ;
            }] ;
        }
    }else if ([self.passwordInputView.textField isFirstResponder]){
        CGFloat height = CGRectGetMaxY(([self.passwordInputView.textField convertRect:self.passwordInputView.bounds toView:self.scrollView])) ;
        offset.y = height - self.scrollView.frameHeigh   ;
        if (self.scrollView.contentOffset.y<offset.y){
            [UIView animateWithDuration:.5f animations:^{
                self.scrollView.contentOffset = offset ;
            }] ;
        }
    }
    
    if (self.phoneNumberInputView.textField.isFirstResponder ||
        self.passwordInputView.textField.isFirstResponder){
        [UIView animateWithDuration:.3f animations:^{
//            [self.loginICON setImage:ImageWithName(@"ic_login-Small")] ;
            //self.layoutICONWidth.constant = 70.0f ;
            [self setLoginICONSize:CGSizeMake(77.0f, 77.0f)];
        }] ;
        
    }else
    {
        [UIView animateWithDuration:.3f animations:^{
//            [self.loginICON setImage:ImageWithName(@"ic_login_Big")] ;
            //self.layoutICONWidth.constant = 102.0f ;
            [self setLoginICONSize:CGSizeMake(102.0f, 102.0f)];
        }] ;
    }
}

#pragma mark -

- (IBAction)_loginButtonHandle:(id)sender
{
    [self.scrollView endEditing:YES];
    
    if (!self.self.phoneNumberInputView.textField.text.length)
    {
        showErrorMessage(nil, nil, @"用户名不能为空") ;
        [self.phoneNumberInputView.textField becomeFirstResponder] ;
        return ;
    }
    
    if (!self.passwordInputView.textField.text.length){
        showErrorMessage(nil, nil, @"请输入密码") ;
        [self.passwordInputView.textField becomeFirstResponder] ;
        return ;
    }
    
    
    if (NetworkAvailable()){
        [self showProgressIndicatorViewWithAnimated:YES title:@"正在登入中"] ;
        [self.serviceRequest startLogin:self.phoneNumberInputView.textField.text
                               Password:self.passwordInputView.textField.text] ;
    }else{
        showAlertView(@"网络不存在,请稍候再试", nil) ;
    }
}

#pragma mark -

- (void)       serviceRequest:(RH_ServiceRequest *)serviceRequest
                  serviceType:(ServiceRequestType)type
    didSuccessRequestWithData:(id)data
{
    if (type==ServiceRequestTypeLogin)
    {
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            [self _sendLoginSuccessMessage] ;
        }] ;
    }
}


- (void)     serviceRequest:(RH_ServiceRequest *)serviceRequest
                serviceType:(ServiceRequestType)type
    didFailRequestWithError:(NSError *)error
{
    if (type==ServiceRequestTypeLogin)
    {
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
//            showAlertView(@"服务器验证错误", @"登入失败");
            showErrorMessage(self.view, error, @"登入失败") ;
        }] ;
    }
}



#pragma mark -

- (void)_sendLoginSuccessMessage
{
    id<RH_LoginViewControllerDelegate> delegate = self.delegate;
    ifRespondsSelector(delegate, @selector(userLoginViewControllerDidSucceedLogin:)){
        [delegate userLoginViewControllerDidSucceedLogin:self];
    }else{
        [self hideWithDesignatedWay:YES completedBlock:nil];
    }
}



@end
