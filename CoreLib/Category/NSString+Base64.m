//
//  NSString+Base64.m
//  CoreLib
//
//  Created by apple pro on 2016/11/22.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "NSString+Base64.h"
#import "NSData+Base64.h"

@implementation NSString (Base64)
+ (NSString *)stringWithBase64EncodedString:(NSString *)base64String
{
    NSData *data = [NSData dataWithBase64EncodedString:base64String];
    return data ? [[self alloc] initWithData:data encoding:NSUTF8StringEncoding]: nil;
}

+ (NSString *)stringWithBase64EncodedData:(NSData *)base64Data
{
    NSData *data = [NSData dataWithBase64EncodedData:base64Data];
    return data ? [[self alloc] initWithData:data encoding:NSUTF8StringEncoding]: nil;
}

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedStringWithWrapWidth:wrapWidth];
}

- (NSData *)base64EncodedDataWithWrapWidth:(NSUInteger)wrapWidth
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedDataWithWrapWidth:wrapWidth];
}

- (NSString *)base64EncodedString {
    return [self base64EncodedStringWithWrapWidth:0];
}

- (NSData *)base64EncodedData {
    return [self base64EncodedDataWithWrapWidth:0];
}

- (NSString *)base64DecodedString {
    return [NSString stringWithBase64EncodedString:self];
}

- (NSData *)base64DecodedData {
    return [NSData dataWithBase64EncodedString:self];
}

@end
