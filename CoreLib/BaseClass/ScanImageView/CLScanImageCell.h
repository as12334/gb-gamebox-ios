//
//  CLScanImageCell.h
//  TaskTracking
//
//  Created by jinguihua on 2017/3/14.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLScanImageData.h"
#import "help.h"

//----------------------------------------------------------

@class CLScanImageCell;
@protocol CLScanImageCellDelegate <NSObject>

@optional

//点击了隐藏（单击）
- (void)scanImageCellDidTapHide:(CLScanImageCell *)cell;

//改变了图片加载状态
- (void)scanImageCellDidChangeImageDisplayState:(CLScanImageCell *)cell;

@end

//----------------------------------------------------------

@interface CLScanImageCell : UICollectionViewCell

- (void)displayImage:(CLScanImageData *)scanImageData;
- (void)displayImage:(CLScanImageData *)scanImageData forAnimationCalculation:(BOOL)forAnimationCalculation;

@property(nonatomic,strong,readonly) CLScanImageData * scanImageData;

//正在显示的图片
@property(nonatomic,strong,readonly) UIImage * displayingImage;
//图片的显示状态
@property(nonatomic,readonly) CLScanImageDisplayState imageDisplayState;

//图片视图
@property(nonatomic,strong,readonly) UIImageView * imageView;
@property(nonatomic,weak) id<CLScanImageCellDelegate> delegate;

//是否显示的图片是长图
@property(nonatomic,readonly) BOOL isDisplayLongImage;

@end

