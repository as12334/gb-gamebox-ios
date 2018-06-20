//
//  NSError+NSError_RH_HTTPRequest.h
//  CoreLib
//
//  Created by jinguihua on 2016/11/30.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>

//---------------------------------------

extern NSString * const HTTPRequestNetErrorDomin            ;
extern NSString * const HTTPRequestResultErrorDomin         ;

//---------------------------------------

//是否是网络错误
#define ISHTTPRequestNetError(_error)  IS_DOMAIN_ERROR(_error,HTTPRequestNetErrorDomin)
//是否是特定类型的网络错误
#define ISHTTPRequestNetError_S(_error,_errorCode)  IS_SPECIFIC_ERROR(_error,HTTPRequestNetErrorDomin,_errorCode)

//是否是结果错误
#define ISHTTPRequestResultError(_error)  IS_DOMAIN_ERROR(_error,HTTPRequestResultErrorDomin)
//是否是特定类型的结果错误
#define ISHTTPRequestResultError_S(_error,_errorCode) IS_SPECIFIC_ERROR(_error,HTTPRequestResultErrorDomin,_errorCode)

//------------------------------------------------------------------

@interface NSError (RH_HTTPRequest)
+ (NSError *)netErrorWithError:(NSError *)error;

+ (NSError *)resultErrorWithURLResponse:(NSHTTPURLResponse *)response ;
+ (NSError *)resultDataNoJSONError;
+ (NSError *)resultErrorWithResultInfo:(NSDictionary *)info;

//未知的结果错误
+ (NSError *)unknownResultError;

@end
