//
//  CLMultipleImagePickerController.h
//  TaskTracking
//
//  Created by apple pro on 2017/2/26.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "DNImagePickerController.h"

@interface CLMultipleImagePickerController : DNImagePickerController
//是否认证通过采集图片
+ (BOOL)isAuthorizedForImagePicker;


//生成图片采集控制器
+ (instancetype)imagePickerViewControllerWithSelectedImageCount:(NSUInteger)selectedImageCount
                                                     filterType:(DNImagePickerFilterType)filterType
                                            canSelecteFullImage:(BOOL)canSelecteFullImage
                                                       delegate:(id<DNImagePickerControllerDelegate>)delegate;

//显示图像采集,显示成功返回实例否则返回nil
+ (instancetype)showImagePickerViewControllerWithSelectedImageCount:(NSUInteger)selectedImageCount
                                                         filterType:(DNImagePickerFilterType)filterType
                                                canSelecteFullImage:(BOOL)canSelecteFullImage
                                                basicViewController:(UIViewController *)basicViewController
                                                           delegate:(id<DNImagePickerControllerDelegate>)delegate
                                                           animated:(BOOL)animated
                                                     completedBlock:(void (^)())completedBlock;
@end
