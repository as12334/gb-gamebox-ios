//
//  NSData+Base64.m
//  CoreLib
//
//  Created by apple pro on 2016/11/22.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "NSData+Base64.h"
#import "NSString+Base64.h"

@implementation NSData(Base64)
/**
 *  @brief  字符串base64后转data
 *
 *  @param base64String 传入字符串
 *
 *  @return 传入字符串 base64后的data
 */
+ (NSData *)dataWithBase64EncodedString:(NSString *)base64String
{
    if (![base64String length]) return nil;
    NSData *decoded = nil;
#if  __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (![NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)])
    {
        decoded = [[self alloc] initWithBase64Encoding:[base64String stringByReplacingOccurrencesOfString:@"[^A-Za-z0-9+/=]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [string length])]];
    }
    else
#endif
    {
        decoded = [[self alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    return [decoded length]? decoded: nil;
}

+ (NSData *)dataWithBase64EncodedData:(NSData *)base64Data
{
    if (!base64Data.length) return nil;

    NSData *decoded = nil;
#if  __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (![NSData instancesRespondToSelector:@selector(initWithBase64EncodedData:options:)])
    {
        decoded = [self dataWithBase64EncodedString:[[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding]];
    }
    else
#endif

    {
        decoded = [[self alloc] initWithBase64EncodedData:base64Data options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }

    return [decoded length]? decoded: nil;
}

/**
 *  @brief  NSData转string
 *
 *  @param wrapWidth 换行长度  76  64
 *
 *  @return base64后的字符串
 */
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    if (![self length]) return nil;
    NSString *encoded = nil;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (![NSData instancesRespondToSelector:@selector(base64EncodedStringWithOptions:)])
    {
        encoded = [self base64Encoding];
    }
    else
#endif
    {
        switch (wrapWidth)
        {
            case 64:
            {
                return [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            }
            case 76:
            {
                return [self base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
            }
            default:
            {
                encoded = [self base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
            }
        }
    }
    if (!wrapWidth || wrapWidth >= [encoded length])
    {
        return encoded;
    }
    wrapWidth = (wrapWidth / 4) * 4;
    NSMutableString *result = [NSMutableString string];
    for (NSUInteger i = 0; i < [encoded length]; i+= wrapWidth)
    {
        if (i + wrapWidth >= [encoded length])
        {
            [result appendString:[encoded substringFromIndex:i]];
            break;
        }
        [result appendString:[encoded substringWithRange:NSMakeRange(i, wrapWidth)]];
        [result appendString:@"\r\n"];
    }
    return result;
}
/**
 *  @brief  NSData转string 换行长度默认64
 *
 *  @return base64后的字符串
 */
- (NSString *)base64EncodedString {
    return [self base64EncodedStringWithWrapWidth:0];
}

- (NSData *)base64EncodedDataWithWrapWidth:(NSUInteger)wrapWidth
{
    NSString * base64String = [self base64EncodedStringWithWrapWidth:wrapWidth];
    return base64String.length ? [base64String dataUsingEncoding:NSUTF8StringEncoding] : nil;
}

- (NSData *)base64EncodedData {
    return [self base64EncodedDataWithWrapWidth:0];
}

- (NSString *)base64DecodedString {
    return [NSString stringWithBase64EncodedData:self];
}

- (NSData *)base64DecodedData {
    return [[self class] dataWithBase64EncodedData:self];
}

@end
