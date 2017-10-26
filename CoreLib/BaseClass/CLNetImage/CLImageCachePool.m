//
//  CLImageCachePool.m
//  TaskTracking
//
//  Created by jinguihua on 2017/3/30.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLImageCachePool.h"
#import "help.h"
#import "MacroDef.h"
#import "UIImage+Representation.h"
#import "CLPathManager.h"
//----------------------------------------------------------

@interface _MyCacheImageData : NSObject

+ (_MyCacheImageData *)dataWithImage:(UIImage *)image key:(NSString *)key;
- (id)initWithImage:(UIImage *)image key:(NSString *)key;

@property(nonatomic,strong,readonly) NSString * key;
@property(nonatomic,strong,readonly) UIImage  * image;

@end

//----------------------------------------------------------

@implementation _MyCacheImageData

+ (_MyCacheImageData *)dataWithImage:(UIImage *)image key:(NSString *)key {
    return [[_MyCacheImageData alloc] initWithImage:image key:key];
}

- (id)initWithImage:(UIImage *)image key:(NSString *)key
{
    assert(image && key);

    if (self = [super init]) {
        _key = key;
        _image = image;
    }
    return self;
}

@end

#pragma mark-
@interface CLImageCachePool ()

//内部缓存
@property(nonatomic,readonly,strong) NSCache  * cache;

@end

//----------------------------------------------------------

@implementation CLImageCachePool

@synthesize cache = _cache;
//@synthesize outerCache = _outerCache;

+ (instancetype)shareImageCachePool
{
    static CLImageCachePool * shareImageCachePool = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareImageCachePool = [[self alloc] init];
    });

    return shareImageCachePool;
}

#pragma mark - life circle

+ (NSString *)cacheRootFileFloderName {
    return @"imageCache";
}

+ (NSString *)defaultCacheFileFloderName {
    return @"defaultImageCache";
}

- (id)initWithPathType:(CLPathType)pathType andCacheFileFloderName:(NSString *)cacheFileFloderName
{
    self = [super initWithPathType:pathType andCacheFileFloderName:cacheFileFloderName];

    if (self) {

        //        _maxOuterCacheCount = 50;
        self.autoChangeCapacity = YES;

        //观察通知
        NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];

        [defaultCenter addObserver:self
                          selector:@selector(_didReceiveMemoryWarningNotification:)
                              name:UIApplicationDidReceiveMemoryWarningNotification
                            object:nil];

        [defaultCenter addObserver:self
                          selector:@selector(_applicationDidEnterBackgroundNotification:)
                              name:UIApplicationDidEnterBackgroundNotification
                            object:nil];

        [defaultCenter addObserver:self
                          selector:@selector(_applicationWillEnterForegroundNotification:)
                              name:UIApplicationWillEnterForegroundNotification
                            object:nil];
    }

    return self;
}

- (void)dealloc
{
    _cache.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)_didReceiveMemoryWarningNotification:(NSNotification *)notification
{
    //内存不足清理缓存
    [self clearInsideCacheImages];
}

- (void)_applicationDidEnterBackgroundNotification:(NSNotification *)notification
{
    //应用进入后台清理缓存，防止占用太多被回收
    [self.cache removeAllObjects];
}

- (void)_applicationWillEnterForegroundNotification:(NSNotification *)notification
{
    //异步更新缓存区容量
    if (self.autoChangeCapacity) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _updateMaxCapacity];
        });
    }
}

#pragma mark -

- (NSCache *)cache
{
    if (!_cache) {

        //互斥锁防止初始化_cache时对对象的访问
        @synchronized(self) {
            _cache = [[NSCache alloc] init];
            _cache.delegate = self;
            [_cache setTotalCostLimit:self.maxCapacity * 1024];
        }
    }

    return _cache;
}

- (void)setMaxCapacity:(NSUInteger)maxCapacity
{
    if (!self.autoChangeCapacity) {
        [self _setMaxCapacity:maxCapacity];
    }
}

- (void)_setMaxCapacity:(NSUInteger)maxCapacity
{
    maxCapacity = MAX(1, maxCapacity);

    if (_maxCapacity != maxCapacity) {
        _maxCapacity = maxCapacity;

        [_cache setTotalCostLimit:_maxCapacity * 1024];

        DebugLog(ImageCachePool, @"当前缓存区最大容量为%iMB",(int)maxCapacity);
    }
}

- (void)setAutoChangeCapacity:(BOOL)autoChangeCapacity
{
    if (autoChangeCapacity != _autoChangeCapacity) {
        _autoChangeCapacity = autoChangeCapacity;

        if (self.autoChangeCapacity) {
            [self _updateMaxCapacity];
        }else {
            self.maxCapacity = 30;
        }
    }
}

- (void)_updateMaxCapacity
{
    if (self.autoChangeCapacity) {

        //获取可用内存大小
        double availableMemorySize = memorySizeForType(CLMemoryTypeAvailable);

        //容量未知则设置为默认值
        if (availableMemorySize == CLMemorySizeUnknown) {
            [self _setMaxCapacity:30];
        }else { //容量不超过可用内存的2/5
            [self _setMaxCapacity:floor(availableMemorySize * 0.4)];
        }
    }
}

#pragma mark - cache image handle

//屏蔽
- (void)cacheData:(NSData *)data forKey:(NSString *)key async:(BOOL)async blockQueue:(NSOperationQueue *)blockQueue completedBlock:(void (^)(BOOL))completedBlock {
    // do nothing
}

- (void)cacheDataWithFilePath:(NSString *)path forKey:(NSString *)key async:(BOOL)async blockQueue:(NSOperationQueue *)blockQueue completedBlock:(void (^)(BOOL))completedBlock {
    // do nothing
}

- (void)cacheImage:(UIImage *)image key:(NSString *)key {
    [self cacheImage:image key:key policy:CLCacheImagePolicyDefault async:YES];
}

- (void)cacheImage:(UIImage *)image key:(NSString *)key policy:(CLCacheImagePolicy)policy async:(BOOL)async
{
    if (image == nil || key == nil) {
        @throw [[NSException alloc] initWithName:NSInvalidArgumentException
                                          reason:@"image和key不能为nil"
                                        userInfo:nil];
    }

    //缓存
    [self _cacheImage:image key:key policy:policy];

    //缓存图片到文件
    if (CacheImageUseFileCachePolicy(policy)) {

        if (async) {

            //异步生成图片数据并缓存
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [super cacheData:[image representationData:1.f] forKey:key async:YES blockQueue:nil completedBlock:nil];
            });

        }else {
            [super cacheData:[image representationData:1.f] forKey:key async:NO blockQueue:nil completedBlock:nil];
        }

    }else {
        [self removeCacheFileForKey:key async:async];
    }
}

- (void)cacheImageWithFilePath:(NSString *)imageFilePath key:(NSString *)key async:(BOOL)async
{
    if (imageFilePath == nil || key == nil) {
        @throw [[NSException alloc] initWithName:NSInvalidArgumentException
                                          reason:@"imageFilePath和key不能为nil"
                                        userInfo:nil];
    }

    if (fileExistAtPath(imageFilePath)) {

        //移除内存缓存
        [self.cache removeObjectForKey:key];

        //缓存数据
        [super cacheDataWithFilePath:imageFilePath forKey:key async:async blockQueue:nil completedBlock:nil];

    }else {
        NSLog(@"文件不存在，缓存失败");
    }
}

- (void)removeCacheImageForKey:(NSString *)key removeFile:(BOOL)removeFile async:(BOOL)async
{
    if (key) {

        //从内存删除
        [self.cache removeObjectForKey:key];
        //        [self.outerCache removeObjectForKey:key];

        if (removeFile) { //删除文件缓存
            [self removeCacheFileForKey:key async:async];
        }
    }
}

- (UIImage *)imageWithKey:(NSString *)key {
    return [self imageWithKey:key policy:CLCacheImagePolicyDefault type:NULL];
}

- (UIImage *)imageWithKey:(NSString *)key policy:(CLCacheImagePolicy)policy type:(MyImageCacheType *)type
{
    UIImage * resultImage = nil;
    MyImageCacheType resultType = MyImageCacheTypeNone;

    if (key) {

        //首先查找内部缓存
        if ((resultImage = [(_MyCacheImageData *)[self.cache objectForKey:key] image])) {
            resultType = MyImageCacheTypeInsideCache;
        }

        if (!resultImage && CacheImageUseFileCachePolicy(policy)) {

            //尝试使用文件缓存
            NSData * cacheData = [self cacheFileDataForKey:key];
            if (cacheData) {

                resultImage = [UIImage imageWithData:cacheData];

                //文件是图片则缓存到内存，否则删除错误数据文件
                if (resultImage) {
                    resultType = MyImageCacheTypeFileCache;
                    [self _cacheImage:resultImage key:key policy:policy];
                }else {
                    [self removeCacheFileForKey:key async:YES];
                }
            }
        }
    }

    if (type) {
        *type = resultType;
    }

    return resultImage;
}

- (void)_cacheImage:(UIImage *)image key:(NSString *)key policy:(CLCacheImagePolicy)policy
{
    //储存图片的花费为其所占用的内存大小，即占多少kb(>>13 == /(8 * 1024))
    [self.cache setObject:[_MyCacheImageData dataWithImage:image key:key]
                   forKey:key
                     cost:MAX(1, [image imageMemorySize] >> 13)];
}


#pragma mark -

- (BOOL)hadCacheImageForKey:(NSString *)key {
    return [self hadCacheImageForKey:key policy:CLCacheImagePolicyDefault type:NULL];
}

- (BOOL)hadCacheImageForKey:(NSString *)key policy:(CLCacheImagePolicy)policy type:(MyImageCacheType *)type
{
    MyImageCacheType resultType = MyImageCacheTypeNone;

    if (key) {

        //内部缓存
        if ([self.cache objectForKey:key]) {
            resultType = MyImageCacheTypeInsideCache;
        }

        //文件缓存
        if (resultType == MyImageCacheTypeNone &&
            CacheImageUseFileCachePolicy(policy) &&
            [self hadCacheFileForKey:key]) {
            resultType = MyImageCacheTypeFileCache;
        }
    }

    if (type) {
        *type = resultType;
    }

    return resultType != MyImageCacheTypeNone;
}


#pragma mark -

- (void)clearInsideCacheImages
{
    [self.cache removeAllObjects];

    //异步更新缓存区容量
    if (self.autoChangeCapacity) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _updateMaxCapacity];
        });
    }
}

- (void)clearAllCacheImages:(void(^)())completeBlock
{
    [self clearInsideCacheImages];
    //    [self clearOuterCacheImages];
    [self clearCacheFilesWithCompletedBlock:completeBlock];
}

#pragma mark -

- (void)cache:(NSCache *)cache willEvictObject:(id)obj
{
    id<CLImageCachePoolDelegate> delegate = self.delegate;

    ifRespondsSelector(delegate, @selector(imageCachePool:willRemoveImage:andKey:)){
        //主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            _MyCacheImageData *data = obj;
            [delegate imageCachePool:self willRemoveImage:data.image andKey:data.key];
        });
    }
}

#pragma mark -

+ (NSString *)cacheFileNameForKey:(NSString *)key {
    return [[super cacheFileNameForKey:key] stringByAppendingPathExtension:@"jpg"];
}

+ (dispatch_queue_t)cacheFileHandleQueue
{
    static dispatch_queue_t shareImageFileCacheQueue = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareImageFileCacheQueue = dispatch_queue_create("ImageCachePool.shareImageFileCacheQueue",DISPATCH_QUEUE_CONCURRENT);
    });

    return shareImageFileCacheQueue;
}



@end

