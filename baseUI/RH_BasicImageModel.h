//
//  RH_BasicImageModel.h
//  TaskTracking
//
//  Created by apple pro on 2017/2/26.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_BasicModel.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class RH_BasicImageModel;
typedef void(^RH_BasicImageModelCompletedCacheBlock)(RH_BasicImageModel * imageInfo);

@interface RH_BasicImageModel : RH_BasicModel
//通过图片初始化
- (id)initWithSourceImage:(UIImage *)sourceImage;
//通过资源初始化
- (id)initWithAsset:(ALAsset *)asset;

//缩略图
@property(nonatomic,strong,readonly) UIImage * thumbImage;
//图片大小
@property(nonatomic,readonly) CGSize imageSize;

//是否完成缓存
@property(nonatomic,readonly) BOOL hadCompletedCache;

//添加回调block，已经完成缓存的调用该方法将无效
- (void)addCompletedCacheCallbackBlcok:(RH_BasicImageModelCompletedCacheBlock)callbackBlock forObject:(id)object;
//移除回调
- (void)removeCompletedCacheCallbackBlcokForObject:(id)object;


//资源（当完成缓存前该值有效）
@property(nonatomic,strong,readonly) ALAsset * asset;
//显示的图片（当完成缓存前该值有效）
@property(nonatomic,strong,readonly) UIImage * image;


//缓存的URL（当完成缓存后改值有效）
@property(nonatomic,strong,readonly) NSString * imageCacheKey;
//缓存的key（当完成缓存后改值有效）
@property(nonatomic,strong,readonly) NSURL * imageCacheURL;

//是否包含有效的图片
@property(nonatomic,readonly) BOOL hasVaildImage;

//是否加入草稿箱（加入草稿箱销毁时不会删除缓存的图片）
@property(nonatomic) BOOL didCacheForResend;

@end
