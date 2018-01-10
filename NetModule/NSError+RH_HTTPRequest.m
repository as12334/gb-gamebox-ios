//
//  NSError+NSError_RH_HTTPRequest.m
//  CoreLib
//
//  Created by jinguihua on 2016/11/30.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "NSError+RH_HTTPRequest.h"
#import "RH_ErrorCode.h"
#import "MacroDef.h"
#import "NSDictionary+CLCategory.h"
#import "RH_API.h"


//---------------------------------------

NSString * const HTTPRequestNetErrorDomin = @"HTTPRequestNetErrorDomin";
NSString * const HTTPRequestResultErrorDomin = @"HTTPRequestResultErrorDomin";

//---------------------------------------

@implementation NSError (RH_HTTPRequest)

+ (NSError *)netErrorWithError:(NSError *)error
{
    return [NSError errorWithDomain:HTTPRequestNetErrorDomin
                               code:error.code
                           userInfo:error.userInfo];
}

+ (NSError *)resultDataNoJSONError
{
    return ERROR_CREATE(HTTPRequestResultErrorDomin,
                        RH_API_ERRORCODE_NO_JSON_ERROR,
                        NSLocalizedString(@"ls_return_data_error",nil),nil);
}

+ (NSError *)unknownResultError {
    return [self resultErrorWithResultInfo:nil];
}

+ (NSError *)resultErrorWithURLResponse:(NSHTTPURLResponse *)response
{
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"]){
        NSInteger errorCode = response.statusCode ;
        NSString *errorMessage = nil ;
        switch (errorCode) {
            case 403:
                errorMessage = @"无权限访问" ;
                break;
           
            case 404:
                errorMessage = @"请求链接或页面找不到" ;
                break;
            
            case 500:
                errorMessage = @"代码错误" ;
                break;
            
            case 502:
                errorMessage = @"运维服务问题" ;
                break;
            
            case 600:
                errorMessage = @"session过期" ;
                break;
            
            case 601:
                errorMessage = @"需要输入安全密码" ;
                break;
             
            case 602:
                errorMessage = @"服务忙" ;
                break;
            
            case 603:
                errorMessage = @"域名不存在" ;
                break;
            
            case 604:
                errorMessage = @"临时域名过期" ;
                break;
            
            case 605:
                errorMessage = @"ip被限制" ;
                break;
            
            case 606:
                errorMessage = @"被强制踢出" ;
                break;
            
            case 607:
                errorMessage = @"站点维护" ;
                break;
            
            case 608:
                errorMessage = @"重复请求" ;
                break;
            
            case 609:
                errorMessage = @"站点不存在" ;
                break;
                
            default:
                break;
        }
        
        if (errorMessage.length){
            return ERROR_CREATE(HTTPRequestResultErrorDomin,
                                errorCode,errorMessage,nil);
        }
    }
    
    return nil ;
}

+ (NSError *)resultErrorWithResultInfo:(NSDictionary *)info
{
    NSInteger errorCode = [info integerValueForKey:RH_GP_V3_CODE];
    errorCode = errorCode ?: RH_API_ERRORCODE_UNKNOW_ERROR;
    NSString * message = [info stringValueForKey:RH_GP_V3_MESSAGE];
    return ERROR_CREATE(HTTPRequestResultErrorDomin,
                        errorCode,
                        message ?: NSLocalizedString(@"ls_access_server_error",nil),nil);
}

@end
