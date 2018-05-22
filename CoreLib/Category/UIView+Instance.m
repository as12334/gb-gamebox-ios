//
//  UIView+Instance.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/14.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "UIView+Instance.h"
#import "ScreenAdaptation.h"
#import "RH_MainTabBarController.h"
#import "RH_MainNavigationController.h"

@implementation UIView(Instance)
+ (instancetype)createInstance {
    return [self createInstanceWithNibName:nil bundle:nil context:nil];
}

+ (instancetype)createInstanceWithContext:(id)context {
    return [self createInstanceWithNibName:nil bundle:nil context:context];
}

+ (instancetype)createInstanceWithNibName:(NSString *)nibNameOrNil
                                   bundle:(NSBundle *)bundleOrNil
                                  context:(id)context
{
    nibNameOrNil = validAdaptationNibName(nibNameOrNil ?: NSStringFromClass([self class]),bundleOrNil);
    if (nibNameOrNil.length) {
        NSArray * objects = [[UINib nibWithNibName:nibNameOrNil bundle:bundleOrNil] instantiateWithOwner:nil options:nil];
        for (id object in objects) {
            if ([self isSubclassOfClass:[object class]]) {
                [object setupViewWithContext:context] ;
                return object;
            }
        }
    }
    
    return [[self alloc] initWithContext:context];
}

- (void)setupViewWithContext:(id)context
{
    
}

- (id)initWithContext:(id)context {
    self = [self init] ;
    [self setupViewWithContext:context] ;
    return self;
}

- (void)showViewController:(UIViewController*)viewController
{
    if ([viewController isKindOfClass:[UIViewController class]]){
        RH_MainTabBarController *mainTabBarController = ConvertToClassPointer(RH_MainTabBarController, [UIApplication sharedApplication].keyWindow.rootViewController) ;
        
        RH_MainNavigationController *mainNavigationController= ConvertToClassPointer(RH_MainNavigationController, mainTabBarController.selectedViewController) ;
        
        if (mainNavigationController){
            [mainNavigationController showViewController:viewController sender:self] ;
        }
    }
}

- (void)presentViewController:(UIViewController*)viewController animated: (BOOL)flag
                   completion:(void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0)
{
    if ([viewController isKindOfClass:[UIViewController class]]){
        RH_MainTabBarController *mainTabBarController = ConvertToClassPointer(RH_MainTabBarController, [UIApplication sharedApplication].keyWindow.rootViewController) ;
        
        RH_MainNavigationController *mainNavigationController= ConvertToClassPointer(RH_MainNavigationController, mainTabBarController.selectedViewController) ;
        
        if (mainNavigationController){
            [mainNavigationController presentViewController:viewController animated:flag completion:completion] ;
        }
    }
}

@end

