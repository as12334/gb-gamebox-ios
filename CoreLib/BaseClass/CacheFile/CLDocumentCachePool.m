//
//  CLDocumentCachePool.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/22.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLDocumentCachePool.h"
#import "MacroDef.h"
#import "help.h"

@implementation CLDocumentCachePool
+ (CLDocumentCachePool *)sharePool;
{
    static CLDocumentCachePool * sharePool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharePool = [[CLDocumentCachePool alloc] initWithPathType:CLPathTypeDocument];
    });

    return sharePool;
}

+ (CLDocumentCachePool *)shareTempCachePool
{
    static CLDocumentCachePool * shareTempCachePool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareTempCachePool = [[CLDocumentCachePool alloc] initWithPathType:CLPathTypeTemp];
    });

    return shareTempCachePool;
}

#pragma mark -

+ (NSString *)cacheRootFileFloderName {
    return @"DocumentCache";
}

+ (NSString *)defaultCacheFileFloderName {
    return @"DefaultDocumentCache";
}

+ (dispatch_queue_t)cacheFileHandleQueue
{
    static dispatch_queue_t shareCacheFileHandleQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareCacheFileHandleQueue = dispatch_queue_create("CLDocumentCachePool.shareCacheFileHandleQueue", DISPATCH_QUEUE_CONCURRENT);
    });

    return shareCacheFileHandleQueue;
}

#pragma mark -

- (void)cacheKeyedArchiverDataWithRootObject:(id<NSCoding>)object forKey:(NSString *)key async:(BOOL)async
{
    if (!object || !key) {
        @throw [[NSException alloc] initWithName:NSInvalidArgumentException
                                          reason:@"object和key不能为nil"
                                        userInfo:nil];
    }

    if (async) {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData * archiverData = [NSKeyedArchiver archivedDataWithRootObject:object];
            [self cacheData:archiverData forKey:key async:NO];
        });

    }else {

        NSData * archiverData = [NSKeyedArchiver archivedDataWithRootObject:object];
        [self cacheData:archiverData forKey:key async:NO];
    }
}

- (id)cacheKeyedUnArchiverRootObjectForKey:(NSString *)key
{
    NSData * cacheData = [self cacheFileDataForKey:key];

    if (cacheData) {

        @try {
            return [NSKeyedUnarchiver unarchiveObjectWithData:cacheData];
        }
        @catch (NSException *exception) {
            NSLog(@"key为%@的缓存数据Unarchive失败",key);
            return nil;
        }
    }else {
        return nil;
    }
}


- (id)cacheKeyedUnArchiverRootObjectForKey:(NSString *)key expectType:(Class)expectType
{
    id data = [self cacheKeyedUnArchiverRootObjectForKey:key];

    if (data && expectType && ![data isKindOfClass:expectType]) {
        data = nil;
//        DefaultDebugLog(@"缓存的数据类型与期待不一致，数据删除");
        [self removeCacheFileForKey:key async:YES];
    }

    return data;
}

@end
