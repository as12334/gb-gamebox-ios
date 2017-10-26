//
//  NSObject+ShowViewControllerDelegate.h
//  CoreLib
//
//  Created by apple pro on 2016/11/22.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//----------------------------------------------------------

@protocol CLShowViewControllerDelegate <NSObject>

@optional

- (BOOL)object:(id)object wantToShowViewController:(UIViewController *)viewController animated:(BOOL)animated completedBlock:(void(^)())completedBlock;

- (BOOL)objectWantToHideViewController:(id)object animated:(BOOL)animated completedBlock:(void(^)())completedBlock;

@end

//----------------------------------------------------------


@interface NSObject (ShowViewControllerDelegate)<CLShowViewControllerDelegate>

//转发对象
- (id<CLShowViewControllerDelegate>)forwardingTargetForShowViewController:(UIViewController *)viewController;

@end
