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
