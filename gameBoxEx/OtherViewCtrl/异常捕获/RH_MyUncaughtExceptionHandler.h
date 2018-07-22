//
//  RH_MyUncaughtExceptionHandler.h
//  gameBoxEx
//
//  Created by Richard on 2018/4/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <Foundation/Foundation.h>
// 崩溃日志
@interface RH_MyUncaughtExceptionHandler : NSObject
+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler *)getHandler;
+ (void)TakeException:(NSException *) exception;
@end
