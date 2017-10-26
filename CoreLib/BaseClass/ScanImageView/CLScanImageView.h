//
//  CLScanImageView.h
//  TaskTracking
//
//  Created by jinguihua on 2017/3/14.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLBlurredBackgroundProtocol.h"
#import "CLScanImageData.h"
#import "help.h"

//----------------------------------------------------------

@class CLScanImageView;


@protocol CLScanImageViewDelegate <NSObject>

@optional

//完成显示了图片
- (void)scanImageView:(CLScanImageView *)scanImageView didDisplayImageAtIndex:(NSInteger)index;
////结束显示了图片
//- (void)scanImageView:(CLScanImageView *)scanImageView didEndDisplayImageAtIndex:(NSInteger)index;

//改变了完成加载原图的状态（当改变了显示的图片和显示的图片完成了加载原图时会改变当前原图完成加载的状态）
- (void)scanImageView:(CLScanImageView *)scanImageView imageDisplayStateDidChangeFromState:(CLScanImageDisplayState)state;

//将要旋转
- (BOOL)scanImageView:(CLScanImageView *)scanImageView shouldRotateToOrientation:(UIInterfaceOrientation)orientation;
//已经旋转
- (void)scanImageView:(CLScanImageView *)scanImageView didRotateToOrientation:(UIInterfaceOrientation)orientation;

//已经开始浏览
- (void)scanImageViewDidStartScan:(CLScanImageView *)scanImageView;
//将要结束浏览（返回NO阻止）
- (BOOL)scanImageViewShouldEndScan:(CLScanImageView *)scanImageView;
//已经结束浏览
- (void)scanImageViewDidEndScan:(CLScanImageView *)scanImageView;

@end

//----------------------------------------------------------

//数据源
@protocol CLScanImageViewDataSource <NSObject>

@optional

//返回图片总数(默认为1)
- (NSUInteger)scanImageView:(CLScanImageView *)scanImageView numberOfImagesForScanWithContext:(id)context;

@required

//返回用于浏览的图片
- (CLScanImageData *)scanImageView:(CLScanImageView *)scanImageView imageForScanAtIndex:(NSUInteger)index withContext:(id)context;

@end


//----------------------------------------------------------

@interface CLScanImageView : UIView <CLBlurredBackgroundProtocol>

@property(nonatomic,strong) UIView * overlayView;

//浏览的背景颜色，默认为黑色（无毛玻璃效果时有效）
@property(nonatomic) UIColor * scanBackgroundColor;

//开始浏览图片

//数据源返回
- (void)startScanImageAtIndex:(NSUInteger)index
               withDataSource:(id<CLScanImageViewDataSource>)dataSource
                      context:(id)context
                   baseWindow:(UIWindow *)baseWindow
                     animated:(BOOL)animated
               completedBlock:(void(^)())completedBlock;

//固定数目的
- (void)startScanImageAtIndex:(NSUInteger)index
                   withImages:(NSArray<CLScanImageData *> *)images
                   baseWindow:(UIWindow *)baseWindow
                     animated:(BOOL)animated
               completedBlock:(void(^)())completedBlock;

- (void)startScanImage:(CLScanImageData *)image
            baseWindow:(UIWindow *)baseWindow
              animated:(BOOL)animated
        completedBlock:(void(^)())completedBlock;

//重新加载图片，当数据源的图片数据改变时，调用该方法重新载入数据
- (void)reloadImages:(BOOL)keepDispalyImage;


//是否正在浏览
@property(nonatomic,readonly,getter=isScanning) BOOL scanning;

//结束浏览
- (void)endScanImageWithAnimated:(BOOL)animated completedBlock:(void(^)())completedBlock;

//代理和数据源
@property(nonatomic,weak) id<CLScanImageViewDelegate> delegate;
@property(nonatomic,weak,readonly) id<CLScanImageViewDataSource> dataSource;

//浏览图片的上下文，用于数据源区分
@property(nonatomic,strong,readonly) id scanContext;

//当前显示的图片索引
@property(nonatomic,readonly) NSUInteger currentDispalyImageIndex;
//图片总数
@property(nonatomic,readonly) NSUInteger numberOfImages;
//返回特定索引的图片
- (CLScanImageData *)imageAtIndex:(NSUInteger)index;


//图片的显示状态
@property(nonatomic,readonly) CLScanImageDisplayState imageDisplayState;

//是否可以长按将图片保存到相册，默认为YES
@property(nonatomic) BOOL canLongPerssSaveImageToPhotosAlbum;
//保存图片到相册
- (BOOL)saveImageToPhotosAlbum;


//是否显示索引指示，默认为YES
@property(nonatomic) BOOL displayIndexIndicater;
//显示索引指示最少需要的图片数目，（默认为2）
@property(nonatomic) NSUInteger indexIndicaterMinimumDisplayImageCount;

//显示的方向
@property(nonatomic,readonly) UIInterfaceOrientation orientation;

@end


//----------------------------------------------------------

//图片浏览的Overlay视图
@interface UIView (CLScanImageOverlayView)

@property(nonatomic,readonly) CLScanImageView * scanImageView;

//获取显示的位置
- (CGRect)frameThatFitForScanImageOverlayView:(CGRect)bounds;
//frame无效
- (void)overlayViewFrameInvalidate;

//改变了显示的图片
- (void)didChangeDisplayImage;

@end

//----------------------------------------------------------

//浏览图片的代理
@protocol CLScanImageDelegate <NSObject>

@optional

- (BOOL)object:(id)object wantToScanImage:(CLScanImageData *)image;
- (BOOL)object:(id)object wantToScanImage:(CLScanImageData *)image configureBlock:(void(^)(CLScanImageView * scanImageView))configureBlock;
- (BOOL)object:(id<CLScanImageViewDataSource>)object wantToScanImageAtIndex:(NSUInteger)index withContext:(id)context;
- (BOOL)object:(id<CLScanImageViewDataSource>)object wantToScanImageAtIndex:(NSUInteger)index withContext:(id)context configureBlock:(void(^)(CLScanImageView * scanImageView))configureBlock;

@required

//结束浏览图片
- (BOOL)object:(id<CLScanImageViewDataSource>)object wantToEndScanImageWithContex:(id)context;

//重新加载浏览图片
- (BOOL)object:(id<CLScanImageViewDataSource>)object wantToReloadScanImagesWithContex:(id)context;


@end
