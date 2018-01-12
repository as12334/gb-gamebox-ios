//
//  RH_ModifySafetyPwdCodeCell.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ModifySafetyPwdCodeCell.h"
#import "RH_ServiceRequest.h"
#import "coreLib.h"

@interface RH_ModifySafetyPwdCodeCell ()<RH_ServiceRequestDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *loginVerifyCodeImage;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *label_indicator;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (nonatomic,strong,readonly) RH_ServiceRequest *serviceRequest ;
@end


@implementation RH_ModifySafetyPwdCodeCell
@synthesize serviceRequest = _serviceRequest ;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.label_indicator.text = @"" ;
    [self.indicator setHidden:YES];
}

-(BOOL)isEditing
{
    return self.textField.isEditing ;
}

-(BOOL)endEditing:(BOOL)force
{
    if (self.textField.isEditing){
        [self.textField resignFirstResponder] ;
    }
    
    return YES ;
}

-(NSString *)passwordCode
{
    return [self.textField.text copy] ;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    [self startVerifyCode] ;
}

-(BOOL)becomeFirstResponder
{
    return [self.textField becomeFirstResponder] ;
}

#pragma mark-
-(IBAction)btn_obtainVerifyCode:(id)sender
{
    [self startVerifyCode] ;
}

#pragma mark-
-(void)startVerifyCode
{
    self.codeImage.hidden = YES ;
    [self.indicator startAnimating] ;
    self.label_indicator.text = @"正在获取验证码" ;
    
    [self.serviceRequest startV3GetSafetyVerifyCode] ;
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
    if (type == ServiceRequestTypeV3SafetyObtainVerifyCode){
        [self.indicator stopAnimating];
        self.label_indicator.text = @"" ;
        self.codeImage.hidden = NO;
        self.codeImage.image = ConvertToClassPointer(UIImage, data) ;
    }
}


- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3SafetyObtainVerifyCode){
        [self.indicator stopAnimating];
        self.label_indicator.text = @"" ;
    }
}


@end
