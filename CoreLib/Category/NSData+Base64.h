//
//  NSData+Base64.h
//  CoreLib
//
//  Created by apple pro on 2016/11/22.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(Base64)
/**
 *  @brief  base64字符串转解码后的data
 *
 *  @param base64String 传入字符串
 *
 *  @return 返回解码后的data
 */
+ (NSData *)dataWithBase64EncodedString:(NSString *)base64String;

/**
 *  @brief  base64数据转解码后的data
 *
 *  @param base64Data 传入数据
 *
 *  @return 返回解码后的data
 */
+ (NSData *)dataWithBase64EncodedData:(NSData *)base64Data;


/**
 *  @brief  NSData转base64字符串
 *
 *  @param wrapWidth 换行长度  76  64
 *
 *  @return base64后的字符串
 */
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSData *)base64EncodedDataWithWrapWidth:(NSUInteger)wrapWidth;

/**
 *  @brief  NSData转base64字符串
 *
 *  @return base64后的字符串
 */
- (NSString *)base64EncodedString;
- (NSData *)base64EncodedData;

- (NSString *)base64DecodedString;
- (NSData *)base64DecodedData;
@end
