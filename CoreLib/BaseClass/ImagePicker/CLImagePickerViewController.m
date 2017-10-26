//
//  CLImagePickerViewController.m
//  TaskTracking
//
//  Created by apple pro on 2017/2/26.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLImagePickerViewController.h"
#import "CLViewControllerTransitioningDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "UIViewController+DesignatedShow.h"
#import "MacroDef.h"
#import "help.h"

@interface CLImagePickerViewController ()< UINavigationControllerDelegate,UIImagePickerControllerDelegate >

@end

@implementation CLImagePickerViewController
{
    CLViewControllerTransitioningDelegate * _myTransitioningDelegate;
}

+ (BOOL)isAuthorizedForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if(sourceType == UIImagePickerControllerSourceTypeCamera){

        AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        return authorizationStatus == AVAuthorizationStatusAuthorized || authorizationStatus == AVAuthorizationStatusNotDetermined;
    }else{

        ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
        return authorizationStatus == ALAuthorizationStatusAuthorized || authorizationStatus == ALAuthorizationStatusNotDetermined;
    }
}

+ (instancetype)imagePickerViewControllerForSourceType:(UIImagePickerControllerSourceType)sourceType
                                              delegate:(id<CLImagePickerControllerDelegate>)delegate
{
    if (![self isSourceTypeAvailable:sourceType]) {
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            showAlertView(@"提醒", @"无相机资源可获取");
        }else{
            showAlertView(@"提醒", @"无相册资源可获取");
        }
    }else if (![self isAuthorizedForSourceType:sourceType]){
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            showAlertView(@"提醒", @"应用无权访问您的相机,请在\"设置->隐私\"中设置");
        }else{
            showAlertView(@"提醒", @"应用无权访问您的相册,请在\"设置->隐私\"中设置");
        }
    }else{
        CLImagePickerViewController * imagePickerViewController = [[self alloc] init];
        imagePickerViewController.sourceType = sourceType;
        imagePickerViewController.imagePickerDelegate = delegate;
        return imagePickerViewController;
    }

    return nil;
}

+ (instancetype)showImagePickerViewControllerForSourceType:(UIImagePickerControllerSourceType)sourceType
                                       basicViewController:(UIViewController *)basicViewController
                                                  delegate:(id<CLImagePickerControllerDelegate>)delegate
                                                  animated:(BOOL)animated
                                            completedBlock:(void (^)())completedBlock
{
    CLImagePickerViewController * imagePickerViewController = [self imagePickerViewControllerForSourceType:sourceType delegate:delegate];

    if (imagePickerViewController && basicViewController) {

        if ([basicViewController showViewControllerWithDesignatedWay:imagePickerViewController
                                                            animated:animated
                                                      completedBlock:completedBlock]) {
            return imagePickerViewController;
        }
    }

    return nil;
}

#pragma amrk -

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.interactiveDismissEnable = YES;
    self.delegate = self;

    if (![self.transitioningDelegate isKindOfClass:[CLViewControllerTransitioningDelegate class]]) {
        _myTransitioningDelegate = [[CLViewControllerTransitioningDelegate alloc] init];
        [_myTransitioningDelegate presentViewController:self];
    }
}

#pragma amrk -

- (UIViewController *)childViewControllerForViewControllerTransitioning {
    return nil;
}

- (BOOL)interactiveDismissGestureShouldReceiveTouch:(UITouch *)touch
{
    if (self.sourceType != UIImagePickerControllerSourceTypeCamera) {
        return CGRectContainsPoint(self.navigationBar.bounds, [touch locationInView:self.navigationBar]);
    }

    return YES;
}

#pragma mark -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<CLImagePickerControllerDelegate> imagePickerDelegate = self.imagePickerDelegate;
    ifRespondsSelector(imagePickerDelegate, @selector(imagePickerController:didFinishPickingMediaWithInfo:)){
        [imagePickerDelegate imagePickerController:(CLImagePickerViewController*)picker
                     didFinishPickingMediaWithInfo:info];
    }else{
        [picker hideWithDesignatedWay:YES completedBlock:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    id<CLImagePickerControllerDelegate> imagePickerDelegate = self.imagePickerDelegate;
    ifRespondsSelector(imagePickerDelegate, @selector(imagePickerControllerDidCancel:)){
        [imagePickerDelegate imagePickerControllerDidCancel:(CLImagePickerViewController *)picker];
    }else{
        [picker hideWithDesignatedWay:YES completedBlock:nil];
    }
}

#pragma mark -

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarHidden:self.sourceType == UIImagePickerControllerSourceTypeCamera];
}

#pragma mark -

- (UIViewController *)childViewControllerForStatusBarStyle {
    return nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return self.sourceType == UIImagePickerControllerSourceTypeCamera;
}


@end
