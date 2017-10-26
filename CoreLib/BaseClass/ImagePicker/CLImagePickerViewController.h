//
//  CLImagePickerViewController.h
//  TaskTracking
//
//  Created by apple pro on 2017/2/26.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <UIKit/UIKit.h>

//----------------------------------------------------------

@class CLImagePickerViewController;

//----------------------------------------------------------

@protocol CLImagePickerControllerDelegate<NSObject>

@optional

- (void)imagePickerController:(CLImagePickerViewController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(CLImagePickerViewController *)picker;

@end

@interface CLImagePickerViewController : UIImagePickerController
//是否认证通过
+ (BOOL)isAuthorizedForSourceType:(UIImagePickerControllerSourceType)sourceType;


+ (instancetype)imagePickerViewControllerForSourceType:(UIImagePickerControllerSourceType)sourceType
                                              delegate:(id<CLImagePickerControllerDelegate>)delegate;

//显示图像采集,显示成功返回实例否则返回nil
+ (instancetype)showImagePickerViewControllerForSourceType:(UIImagePickerControllerSourceType)sourceType
                                       basicViewController:(UIViewController *)basicViewController
                                                  delegate:(id<CLImagePickerControllerDelegate>)delegate
                                                  animated:(BOOL)animated
                                            completedBlock:(void (^)())completedBlock;

@property(nonatomic) UIStatusBarStyle statusBarStyle;
@property(nonatomic,weak) id<CLImagePickerControllerDelegate> imagePickerDelegate;
@end
