//
//  RH_LoginViewCell.m
//  gameBoxEx
//
//  Created by luis on 2017/12/5.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_LoginViewCell.h"
#import "RH_CommonInputContainerView.h"
#import "coreLib.h"
#import "RH_ServiceRequest.h"
#import "RH_APPDelegate.h"

@interface RH_LoginViewCell()<UITextFieldDelegate,RH_ServiceRequestDelegate>
@property (strong, nonatomic) IBOutlet RH_CommonInputContainerView *userNameView;
@property (strong, nonatomic) IBOutlet RH_CommonInputContainerView *userPwdView;
@property (strong, nonatomic) IBOutlet RH_CommonInputContainerView *verifyCodeView;
@property (strong, nonatomic) IBOutlet CLButton *btnLogin;
@property (strong, nonatomic) IBOutlet CLButton *btnCreateUser;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *loginTopLayoutConst ;


@property (nonatomic,strong,readonly) RH_ServiceRequest *serviceRequest ;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *activityIndicatorView ;
@property (nonatomic,strong) IBOutlet UILabel *labVerifyCode ;
@property (nonatomic,strong) IBOutlet UIImageView *imgVerifyCode ;

@end

@implementation RH_LoginViewCell
@synthesize serviceRequest = _serviceRequest ;

+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    BOOL isNeedVerCode = [context boolValue] ;
   
    return isNeedVerCode?380.0f:260.0f ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.userNameView.type = RH_CommonInputContainerViewTypeLine;
    self.userNameView.textField.delegate = self ;
    
    [self.userNameView.textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"请输入用户名" attributes:@{NSFontAttributeName : self.userNameView.textField.font, NSForegroundColorAttributeName : ColorWithNumberRGB(0xcacaca)}]];
    [self.userPwdView.textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSFontAttributeName : self.userPwdView.textField.font, NSForegroundColorAttributeName : ColorWithNumberRGB(0xcacaca)}]];
    [self.verifyCodeView.textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSFontAttributeName : self.verifyCodeView.textField.font, NSForegroundColorAttributeName : ColorWithNumberRGB(0xcacaca)}]];
    
    self.userNameView.layer.cornerRadius = floorf(self.userNameView.frameHeigh/2.0) ;
    self.userNameView.layer.borderColor = [UIColor grayColor].CGColor ;
    self.userNameView.layer.borderWidth = PixelToPoint(1.0f) ;
    self.userPwdView.layer.cornerRadius = floorf(self.userPwdView.frameHeigh/2.0) ;
    self.userPwdView.layer.borderColor = [UIColor grayColor].CGColor ;
    self.userPwdView.layer.borderWidth = PixelToPoint(1.0f) ;
    self.verifyCodeView.layer.cornerRadius = floorf(self.verifyCodeView.frameHeigh/2.0) ;
    self.verifyCodeView.layer.borderColor = [UIColor grayColor].CGColor ;
    self.verifyCodeView.layer.borderWidth = PixelToPoint(1.0f) ;
    
    [self.btnLogin setBackgroundColor:ColorWithNumberRGB(0xFF1766bb) forState:UIControlStateNormal] ;
    [self.btnLogin setBackgroundColor:ColorWithNumberRGBA(0x333333, 0.3f) forState:UIControlStateHighlighted] ;
    [self.btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    self.btnLogin.layer.cornerRadius = floorf(self.btnLogin.frameHeigh/2.0) ;
    
    [self.btnCreateUser setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal] ;
    [self.btnCreateUser setBackgroundColor:ColorWithNumberRGBA(0x333333, 0.3f) forState:UIControlStateHighlighted] ;
    [self.btnCreateUser setTitleColor:ColorWithNumberRGB(0xFF1766bb) forState:UIControlStateNormal] ;
    self.btnCreateUser.layer.borderColor = ColorWithNumberRGB(0xFF1766bb).CGColor ;
    self.btnCreateUser.layer.borderWidth = PixelToPoint(1.0f) ;
    self.btnCreateUser.layer.cornerRadius = floorf(self.btnCreateUser.frameHeigh/2.0) ;
    
    self.activityIndicatorView.hidesWhenStopped = YES ;
    
    //初始化用户
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userNameView.textField.text = [defaults stringForKey:@"account"] ;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    BOOL isNeedVerCode = [context boolValue] ;
    self.verifyCodeView.hidden = !isNeedVerCode ;
    self.loginTopLayoutConst.constant = isNeedVerCode?100.0f :30.0f ;
    
    if (isNeedVerCode){
        [self startVerifyCode] ;
    }
}

#pragma mark-
-(void)startVerifyCode
{
    self.imgVerifyCode.hidden = YES ;
    [self.activityIndicatorView startAnimating] ;
    self.labVerifyCode.text = @"正在获取验证码" ;
    
    [self.serviceRequest startGetVerifyCode] ;
}

-(RH_ServiceRequest *)serviceRequest
{
    if (!_serviceRequest){
        _serviceRequest = [[RH_ServiceRequest alloc] init] ;
        _serviceRequest.delegate = self ;
    }
    
    return _serviceRequest ;
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeObtainVerifyCode){
        [self.activityIndicatorView stopAnimating];
        self.labVerifyCode.text = @"" ;
        self.imgVerifyCode.hidden = NO;
        self.imgVerifyCode.image = ConvertToClassPointer(UIImage, data) ;
    }
}


- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeObtainVerifyCode){
        [self.activityIndicatorView stopAnimating];
        self.labVerifyCode.text = @"" ;
    }
}

#pragma mark-
-(NSString *)userName
{
    return [self.userNameView.textField.text.trim copy] ;
}

-(NSString*)userPassword
{
    return [self.userPwdView.textField.text.trim copy] ;
}

-(NSString *)verifyCode
{
    return (self.verifyCodeView.hidden?nil:self.verifyCodeView.textField.text.trim) ;
}

-(IBAction)btn_obtainVerifyCode:(id)sender
{
    [self startVerifyCode] ;
}

-(IBAction)btn_login:(id)sender
{
    [self endEditing:YES] ;
    
    if (self.userName.length<1){
        showAlertView(@"提示", @"用户名不能为空!") ;
        [self.userNameView.textField becomeFirstResponder] ;
        return ;
    }
    
    if (self.userPassword.length<1){
        showAlertView(@"提示", @"密码不能为空!") ;
        [self.userPwdView.textField becomeFirstResponder] ;
        return ;
    }
    
    if (self.verifyCodeView.hidden==false){
        if (self.verifyCode.length<1){
            showAlertView(@"提示", @"验证码不能为空!") ;
            [self.verifyCodeView.textField becomeFirstResponder] ;
            return ;
        }
    }
    
    ifRespondsSelector(self.delegate, @selector(loginViewCellTouchLoginButton:)){
        [self.delegate loginViewCellTouchLoginButton:self] ;
    }
}

-(IBAction)btn_createUser:(id)sender
{
    [self endEditing:YES] ;
    
    ifRespondsSelector(self.delegate, @selector(loginViewCellTouchCreateButton:)){
        [self.delegate loginViewCellTouchCreateButton:self] ;
    }
}

#pragma mark-
-(BOOL)isEditing
{
    return self.userNameView.textField.isEditing || self.userPwdView.textField.isEditing || self.verifyCodeView.textField.isEditing;
}

-(BOOL)endEditing:(BOOL)force
{
    if (force){
        [self.userNameView.textField resignFirstResponder] ;
        [self.userPwdView.textField resignFirstResponder] ;
        [self.verifyCodeView.textField resignFirstResponder] ;
    }
    
    return [super endEditing:force] ;
}
@end