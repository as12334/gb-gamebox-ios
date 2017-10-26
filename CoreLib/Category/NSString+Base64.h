//
//  NSString+Base64.h
//  CoreLib
//
//  Created by apple pro on 2016/11/22.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)
+ (NSString *)stringWithBase64EncodedString:(NSString *)base64String;
+ (NSString *)stringWithBase64EncodedData:(NSData *)base64Data;

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSData *)base64EncodedDataWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;
- (NSData *)base64EncodedData;

- (NSString *)base64DecodedString;
- (NSData *)base64DecodedData;
@end
