//  ----------------------------------------------------------------------
//  Copyright (C) 2017  即时通讯网(52im.net) & Jack Jiang.
//  The MobileIMSDK_X (MobileIMSDK v3.x) Project.
//  All rights reserved.
//
//  > Github地址: https://github.com/JackJiang2011/MobileIMSDK
//  > 文档地址: http://www.52im.net/forum-89-1.html
//  > 即时通讯技术社区：http://www.52im.net/
//  > 即时通讯技术交流群：320837163 (http://www.52im.net/topic-qqgroup.html)
//
//  "即时通讯网(52im.net) - 即时通讯开发者社区!" 推荐开源工程。
//
//  如需联系作者，请发邮件至 jack.jiang@52im.net 或 jb2011@163.com.
//  ----------------------------------------------------------------------
//
//  ToolKits.m
//  MibileIMSDK4i_X (MobileIMSDK v3.0 at Summer 2017)
//
//  Created by JackJiang on 14/10/22.
//  Copyright (c) 2017年 52im.net. All rights reserved.
//

#import "ToolKits.h"
#import "CharsetHelper.h"
#import "RMMapper.h"

@implementation ToolKits


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 其它实用方法
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (NSString *) generateUUID
{
    //** 生成UUID的第1种方法：以下方法在在iPhone6、5S上可用，在4s、5等模拟器上会崩溃
//    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
//    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
//
//    CFRelease(uuid_ref);
//    NSString *uuid = [NSString stringWithString:(NSString*)CFBridgingRelease(uuid_string_ref)];
//
//    CFRelease(uuid_string_ref);
//
//    return [uuid autorelease];

    //** 生成UUID的第2种方法：以下方法在在模拟器上正常运行，但它只在iOS6及以后版本中可用
    NSString *uuid = [[NSUUID UUID] UUIDString];
    return uuid;
}

+ (NSTimeInterval) getTimeStampWithMillisecond
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970] * 1000;
    return a;
}

+ (long) getTimeStampWithMillisecond_l
{
    return [[NSNumber numberWithDouble:[ToolKits getTimeStampWithMillisecond]] longValue];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - JSON转换相关方法
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (NSString *) toJSONString:(NSData *)datas
{
    // 将2进制数据转JSON字符串
    NSString *jsonStr = [CharsetHelper getString:datas];
    return jsonStr;
}
+ (NSData *) toJSONBytesWithDictionary:(NSDictionary *)dic
{
    // 再将Dictionary转成JSON的2进制表示
    NSData *jsonData = [CharsetHelper getJSONBytesWithDictionary:dic];
    return jsonData;
}


+ (NSMutableDictionary *) toMutableDictionary:(id)obj
{
    // 对象先转key-values
    NSMutableDictionary *dic = [RMMapper mutableDictionaryForObject:obj];
    return dic;
}

+ (NSDictionary *) fromJSONBytesToDictionary:(NSData *)jsonBytes
{
    return [NSJSONSerialization JSONObjectWithData:jsonBytes options:0 error:nil];
}
+ (id) fromDictionaryToObject:(NSDictionary *)dic withClass:(Class)clazz
{
    return[RMMapper objectWithClass:clazz fromDictionary:dic];
}


@end
