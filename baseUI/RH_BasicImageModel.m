//
//  RH_BasicImageModel.m
//  TaskTracking
//
//  Created by apple pro on 2017/2/26.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_BasicImageModel.h"
#import "coreLib.h"

@interface RH_BasicImageModel()
@property(nonatomic,strong,readonly) NSMutableDictionary * callbackBlocks;
@end

@implementation RH_BasicImageModel
@synthesize callbackBlocks = _callbackBlocks;

#pragma mark -

+ (CLDocumentCachePool *)_doPostAndReplyResourceCachePool
{
    static CLDocumentCachePool * doPostAndReplyResourceCachePool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        doPostAndReplyResourceCachePool = [[CLDocumentCachePool alloc] initWithPathType:CLPathTypeDocument
                                                                 andCacheFileFloderName:@"DoPostAndReplyResourceCache"];
    });

    return doPostAndReplyResourceCachePool;
}

+ (NSString *)cacheImage:(UIImage *)image
{
    if (image) {

        NSString * imageKey = getUniqueID();
        [[self _doPostAndReplyResourceCachePool] cacheData:[image imageDataForUpload] forKey:imageKey async:NO];

        return imageKey;
    }

    return nil;
}

+ (void)removeResourceForKey:(NSString *)resourceKey
{
    //移除资源数据
    [[self _doPostAndReplyResourceCachePool] removeCacheFileForKey:resourceKey async:YES];
}

+ (NSURL *)cacheResourceURLForKey:(NSString *)resourceKey {
    return [[self _doPostAndReplyResourceCachePool] cacheFileURLForKey:resourceKey];
}

+ (BOOL)hadCacheResourceForKey:(NSString *)resourceKey {
    return [[self _doPostAndReplyResourceCachePool] hadCacheFileForKey:resourceKey];
}


#pragma mark-

- (id)initWithSourceImage:(UIImage *)sourceImage
{
    MyAssert(sourceImage != nil);

    self = [super init];
    if (self) {

        _image = _thumbImage = sourceImage;
        _imageSize = [sourceImage perfectShowSizeInScale:1.f];

        //主线程异步防止主线程等待
        typeof(self) __weak  weak_self = self;
        dispatch_async(dispatch_get_main_queue(), ^{

            //后台生成缩略图及缓存图片
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

                //生成缩略图
                UIImage * thumbImage = [sourceImage thumbnailWithSize:90.f];

                //生成压缩后的图片
                UIImage * newSourceImage = [sourceImage imageZoomInToMaxSize:CGSizeMake(1536.f, 1536.f)];

                //缓存图片
                NSString * imageCacheKey = [[self class] cacheImage:newSourceImage];

                //图片尺寸
                CGSize imageSize = [newSourceImage perfectShowSizeInScale:1.f];

                dispatch_async(dispatch_get_main_queue(), ^{

                    typeof(weak_self) _self = weak_self;
                    if (_self) {
                        [_self _completedCacheImageWithThumbImage:thumbImage imageSize:imageSize imageCacheKey:imageCacheKey];
                    }else { //删除缓存图片
                        [[self class] removeResourceForKey:imageCacheKey];
                    }
                });
            });
        });
    }

    return self;
}

- (id)initWithAsset:(ALAsset *)asset
{
    MyAssert(asset != nil);

    self = [super init];
    if (self) {

        _asset = asset;

        _thumbImage = _image = [UIImage imageWithCGImage:[asset thumbnail]];
        _imageSize = [_thumbImage perfectShowSizeInScale:1.f];

        //主线程异步防止主线程等待
        typeof(self) __weak weak_self = self;
        dispatch_async(dispatch_get_main_queue(), ^{

            //后台生成缩略图及缓存图片
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

                //生成缩略图(拷贝)
                UIImage * thumbImage = [asset suitableAspectRatioThumbnail:YES];
                //生成全屏显示图片
                UIImage * newSourceImage = [asset suitableFullScreenImage];

                //缓存图片
                NSString * imageCacheKey = [[self class] cacheImage:newSourceImage];

                //图片尺寸
                CGSize imageSize = [newSourceImage perfectShowSizeInScale:1.f];


                dispatch_async(dispatch_get_main_queue(), ^{

                    typeof(weak_self) _self = weak_self;
                    if (_self != nil) {
                        [_self _completedCacheImageWithThumbImage:thumbImage imageSize:imageSize imageCacheKey:imageCacheKey];
                    }else { //删除缓存图片
                        [[self class] removeResourceForKey:imageCacheKey];
                    }
                });
            });

        });
    }

    return self;
}

- (void)_completedCacheImageWithThumbImage:(UIImage *)thumbImage imageSize:(CGSize)imageSize imageCacheKey:(NSString *)imageCacheKey
{
    _hadCompletedCache = YES;
    _thumbImage = thumbImage;
    _imageSize = imageSize;
    _imageCacheKey = imageCacheKey;
    _image = nil;
    _asset = nil;

    //回调
    for (RH_BasicImageModelCompletedCacheBlock callbackBlock in _callbackBlocks.allValues) {
        callbackBlock(self);
    }
    _callbackBlocks = nil;
}

- (void)dealloc
{
    //删除缓存图片
    if (!self.didCacheForResend && _imageCacheKey) {
        [[self class] removeResourceForKey:_imageCacheKey];
    }
}

#pragma mark -

- (NSMutableDictionary *)callbackBlocks
{
    if (!_callbackBlocks) {
        _callbackBlocks = [NSMutableDictionary dictionary];
    }

    return _callbackBlocks;
}

- (void)addCompletedCacheCallbackBlcok:(RH_BasicImageModelCompletedCacheBlock)callbackBlock forObject:(id)object
{
    if (!_hadCompletedCache && callbackBlock && object) {
        [self.callbackBlocks setObject:[callbackBlock copy] forKey:NSNumberWithPointer(object)];
    }
}

- (void)removeCompletedCacheCallbackBlcokForObject:(id)object
{
    if (object && _callbackBlocks) {
        [_callbackBlocks removeObjectForKey:NSNumberWithPointer(object)];
    }
}

#pragma mark -

- (NSURL *)imageCacheURL {
    return _imageCacheKey ? [[self class] cacheResourceURLForKey:_imageCacheKey] : nil;
}

- (BOOL)hasVaildImage {
    return _hadCompletedCache ? _imageCacheKey != nil : (_image || _asset);
}

#pragma mark -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    if (self) {
        _thumbImage = [aDecoder decodeObjectForKey:@"_thumbImage"];
        _imageCacheKey = [aDecoder decodeObjectForKey:@"_imageCacheKey"];
        _imageSize = [aDecoder decodeCGSizeForKey:@"_imageSize"];
        _hadCompletedCache = YES;

        if (![[self class] hadCacheResourceForKey:_imageCacheKey]) {
#if DEBUG
            NSLog(@"图片资源被删除,数据解码失败");
#endif
            _imageCacheKey = nil;
        }
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if (_hadCompletedCache) { //完成缓存图片
        [aCoder encodeObject:_thumbImage forKey:@"_thumbImage"];
        [aCoder encodeObject:_imageCacheKey forKey:@"_imageCacheKey"];
        [aCoder encodeCGSize:_imageSize forKey:@"_imageSize"];
    }

#if DEBUG

    else {
        NSLog(@"图片信息还未完成缓存，持续化编码失败");
    }

#endif
}

@end
