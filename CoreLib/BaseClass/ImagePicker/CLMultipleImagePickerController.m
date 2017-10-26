//
//  CLMultipleImagePickerController.m
//  TaskTracking
//
//  Created by apple pro on 2017/2/26.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLMultipleImagePickerController.h"
#import "UIViewController+DesignatedShow.h"
#import "CLImagePickerViewController.h"
#import "CLViewControllerTransitioningDelegate.h"

@implementation CLMultipleImagePickerController
{
    CLViewControllerTransitioningDelegate * _myTransitioningDelegate;
}

+ (BOOL)isAuthorizedForImagePicker {
    return [CLImagePickerViewController isAuthorizedForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (instancetype)imagePickerViewControllerWithSelectedImageCount:(NSUInteger)selectedImageCount
                                                     filterType:(DNImagePickerFilterType)filterType
                                            canSelecteFullImage:(BOOL)canSelecteFullImage
                                                       delegate:(id<DNImagePickerControllerDelegate>)delegate
{
    if (![self isAuthorizedForImagePicker]) {
        showAlertView(@"提醒", @"应用无权访问您的相册,请在\"设置->隐私\"中设置");
    }else {

        CLMultipleImagePickerController * imagePickerViewController = [[self alloc] init];
        imagePickerViewController.maxSelectedImageCount = selectedImageCount;
        imagePickerViewController.filterType = filterType;
        imagePickerViewController.canSelecteFullImage = canSelecteFullImage;
        imagePickerViewController.imagePickerDelegate = delegate;
        return imagePickerViewController;
    }

    return nil;
}

//显示图像采集,显示成功返回实例否则返回nil
+ (instancetype)showImagePickerViewControllerWithSelectedImageCount:(NSUInteger)selectedImageCount
                                                         filterType:(DNImagePickerFilterType)filterType
                                                canSelecteFullImage:(BOOL)canSelecteFullImage
                                                basicViewController:(UIViewController *)basicViewController
                                                           delegate:(id<DNImagePickerControllerDelegate>)delegate
                                                           animated:(BOOL)animated
                                                     completedBlock:(void (^)())completedBlock
{
    CLMultipleImagePickerController * imagePickerController = [self imagePickerViewControllerWithSelectedImageCount:selectedImageCount
                                                                                                         filterType:filterType
                                                                                                canSelecteFullImage:canSelecteFullImage
                                                                                                           delegate:delegate];

    if (imagePickerController && basicViewController) {
        if ([basicViewController showViewControllerWithDesignatedWay:imagePickerController
                                                            animated:animated
                                                      completedBlock:completedBlock]) {
            return imagePickerController;
        }
    }

    return nil;
}

#pragma amrk -

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.interactiveDismissEnable = YES;

    if (![self.transitioningDelegate isKindOfClass:[CLViewControllerTransitioningDelegate class]]) {
        _myTransitioningDelegate = [[CLViewControllerTransitioningDelegate alloc] init];
        [_myTransitioningDelegate presentViewController:self];
    }
}

#pragma mark -

- (UIViewController *)childViewControllerForViewControllerTransitioning {
    return nil;
}

- (BOOL)interactiveDismissGestureShouldReceiveTouch:(UITouch *)touch {
    return CGRectContainsPoint(self.navigationBar.bounds, [touch locationInView:self.navigationBar]);
}

@end
