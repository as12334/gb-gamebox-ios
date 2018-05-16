//
//  CLTabBarController.m
//  CoreLib
//
//  Created by jinguihua on 2016/11/29.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "CLTabBarController.h"
#import "UIViewController+CLTabBarController.h"
#import "CLTabChangeTransitioning.h"
#import "help.h"
#import "MacroDef.h"


@implementation CLTabBarController
{
    BOOL                                   _tabBarHidden;
    UIPanGestureRecognizer               * _hiddenTabBarPanGestureRecognizer;

    UIPanGestureRecognizer               * _interactiveGestureRecognizer;
    UIPercentDrivenInteractiveTransition * _interactiveTransition;

    UIViewController                     * _interactivetSelectedViewController;
    CLTabChangeDirection                   _interactiveDirection;
    float                                  _interactivePercentComplete;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.delegate = self;

    //隐藏tabbar的手势
    _hiddenTabBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_hiddenTabBarPanGestureHander:)];
    _hiddenTabBarPanGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_hiddenTabBarPanGestureRecognizer];

    //交互切换的手势
    _interactiveGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_interactiveGestureHandle:)];
    _interactiveGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_interactiveGestureRecognizer];

}

- (void)setTabBarHidden:(BOOL)tabBarHidden {
    [self setTabBarHidden:tabBarHidden animated:NO animations:nil completion:nil];
}

- (void)setTabBarHidden:(BOOL)hidden
               animated:(BOOL)animated
             animations:(void (^)(void))animations
             completion:(void (^)(void))completionBlock
{
    //系统版本在7.0以下且tabbar不是半透明不支持隐藏标题栏
    if (![SITE_TYPE isEqualToString:@"integratedv3oc"]){
        if (!GreaterThanIOS7System || self.tabBar.translucent == NO) {
            return;
        }
    }

    if (_tabBarHidden != hidden) {
        _tabBarHidden = hidden;

        CGRect tabBarRect = self.tabBar.frame;

        if (hidden) {
            tabBarRect.origin.y += CGRectGetHeight(tabBarRect);
        }else{
            if (GreaterThanIOS11System){
                tabBarRect.origin.y = [UIScreen mainScreen].bounds.size.height - CGRectGetHeight(tabBarRect) ;
            }else{
                tabBarRect.origin.y -= CGRectGetHeight(tabBarRect);
            }
        }

        self.tabBar.hidden = NO;

        if (animated) {

            [UIView animateWithDuration:UINavigationControllerHideShowBarDuration
                             animations:^{

                                 self.tabBar.frame = tabBarRect;

                                 if (animations) {
                                     animations();
                                 }

                             } completion:^(BOOL finished){
                                 self.tabBar.hidden = hidden;

                                 if (completionBlock) {
                                     completionBlock();
                                 }
                             }];

        }else{

            self.tabBar.frame = tabBarRect;
            self.tabBar.hidden = hidden;

            if (completionBlock) {
                completionBlock();
            }
        }

    }
    else{

        if (completionBlock) {
            completionBlock();
        }
    }

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIViewController * selectedViewController = self.selectedViewController;

    if (gestureRecognizer == _interactiveGestureRecognizer) {


        return (self.viewControllers.count > 1 && selectedViewController &&
                [selectedViewController isInteractiveChangeTabEnabled] &&
                [selectedViewController interactiveGestureChangeTabShouldReceiveTouch:touch]);

    }else if (gestureRecognizer == _hiddenTabBarPanGestureRecognizer){

        return (selectedViewController &&
                [selectedViewController isGestureHiddenTabBarEnabled] &&
                [selectedViewController hiddenTabBarGestureShouldReceiveTouch:touch]);
    }

    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == _interactiveGestureRecognizer){

        CGPoint translation = [_interactiveGestureRecognizer translationInView:self.view];
        if(fabs(translation.x) > fabs(translation.y)){ //左右滑动

            UIViewController * selectedViewController = self.selectedViewController;

            return (selectedViewController &&
                    [selectedViewController interactiveGestureChangeTabShouldBeginWithPoint:[_interactiveGestureRecognizer locationInView:self.view]
                                                                               andDirection:(translation.x < 0 ? CLTabChangeDirectionNext : CLTabChangeDirectionPrev)]);
        }

        return NO;

    }else if (gestureRecognizer == _hiddenTabBarPanGestureRecognizer){

        CGPoint translation = [_hiddenTabBarPanGestureRecognizer translationInView:self.view];
        //上下滑动
        return (fabs(translation.x) < fabs(translation.y));
    }

    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return (gestureRecognizer == _hiddenTabBarPanGestureRecognizer) ||
    (gestureRecognizer == _interactiveGestureRecognizer);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //其它滑动手势需要交互手势失败
    if (gestureRecognizer == _interactiveGestureRecognizer) {
        return [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] ||
        [otherGestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]];
    }

    return NO;
}


- (void)_hiddenTabBarPanGestureHander:(UIGestureRecognizer *)gestureRecognizer
{
    UIViewController * selectedViewController = self.selectedViewController;
    CGPoint translation = [_hiddenTabBarPanGestureRecognizer translationInView:self.view];
    //达到响应条件
    if (fabs(translation.y) >= [selectedViewController minMoveValueForHiddenTabBar]) {

        BOOL hidden = translation.y < 0;

        [selectedViewController gestureWantToHiddenTabBar:hidden];

        if (_tabBarHidden != hidden &&
            [selectedViewController tabBarWillGestureHidden:hidden]) {

            [self setTabBarHidden:hidden animated:YES
                       animations:^{
                           //动作
                           [selectedViewController animationWhenTabBarGestureHidden:hidden];
                       }
                       completion:^{
                           //结束
                           [selectedViewController tabBarDidGestureHidden:hidden];
                       }];

        }

        //重新计数
        [_hiddenTabBarPanGestureRecognizer setTranslation:CGPointZero inView:self.view];
    }
}

- (void)_interactiveGestureHandle:(UIGestureRecognizer *)gestureRecognizer
{
    UIGestureRecognizerState state = gestureRecognizer.state;

    if (state == UIGestureRecognizerStateBegan) {

        _interactivetSelectedViewController = self.selectedViewController;
        _interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        _interactiveTransition.completionCurve = UIViewAnimationCurveLinear;
        _interactivePercentComplete = 0.f;

        //方向
        _interactiveDirection = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.view].x < 0 ? CLTabChangeDirectionNext : CLTabChangeDirectionPrev;

        //获取目的索引
        NSInteger tragetIndex = (_interactiveDirection == CLTabChangeDirectionNext) ? self.selectedIndex + 1 : self.selectedIndex - 1;
        tragetIndex = (tragetIndex < 0) ? (self.viewControllers.count -1) : ((tragetIndex >= self.viewControllers.count) ? 0 : tragetIndex);

        _interacting = YES;

        //切换到目的索引
        self.selectedIndex = tragetIndex;

        //开始
        [_interactivetSelectedViewController startInteractiveChangeTabWithDirection:_interactiveDirection];

    }else{

        CGPoint locationPoint =  [gestureRecognizer locationInView:self.view];
        CGPoint translation   =  [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.view];

        //计算进度
        _interactivePercentComplete += [_interactivetSelectedViewController interactiveChangeTabCompletePercentForTranslation:translation direction:_interactiveDirection startPoint:locationPoint];

        if (state == UIGestureRecognizerStateChanged) {

            _interactivePercentComplete = ChangeInMinToMax(_interactivePercentComplete, 0.f, 1.f);
            [_interactiveTransition updateInteractiveTransition:_interactivePercentComplete];

        }else{

            //速度
            CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.view];

            //添加速度进度
            _interactivePercentComplete += [_interactivetSelectedViewController interactiveChangeTabCompletePercentForTranslation:velocity direction:_interactiveDirection startPoint:locationPoint];


            if (state == UIGestureRecognizerStateEnded && _interactivePercentComplete >= 0.5f) {

                //完成
                [_interactiveTransition finishInteractiveTransition];
                [_interactivetSelectedViewController finishInteractiveChangeTabWithDirection:_interactiveDirection];

            }else{

                //取消
                [_interactiveTransition cancelInteractiveTransition];
                [_interactivetSelectedViewController cancelInteractiveChangeTabWithDirection:_interactiveDirection];
            }

            _interacting = NO;
            _interactiveDirection = CLTabChangeDirectionNone;
            _interactivetSelectedViewController = nil;
            _interactiveTransition = nil;
            _interactivePercentComplete = 0.f;
        }

        //移动偏移置0
        [(UIPanGestureRecognizer *)gestureRecognizer setTranslation:CGPointZero inView:self.view];
    }
}

- (void)viewControllerAnimatedTransitioning:(CLBasicViewControllerAnimatedTransitioning *)viewControllerAnimatedTransitioning
                        didEndTransitioning:(BOOL)completed
{
    _transitioning = NO;
}


- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (!_interactiveTransition) {
        return nil;
    }

    UIViewController * selectedViewController = self.selectedViewController;
    CLTabChangeDirection direction = _interactiveDirection;

    //当前无方向则通过索引计算方向
    if (direction == CLTabChangeDirectionNone) {
        NSUInteger fromIndex = [self.viewControllers indexOfObject:fromVC];
        NSUInteger toIndex = [self.viewControllers indexOfObject:toVC];
        direction = (toIndex > fromIndex)? CLTabChangeDirectionNext : CLTabChangeDirectionPrev;
    }

    CLBasicViewControllerAnimatedTransitioning * transitioning = [selectedViewController changeTabAnimatedTransitioningForDiretion:direction];

    if (!transitioning) {
        transitioning = [[CLTabChangeTransitioning alloc] initWithTabChangeDirection:direction
                                                                                type:CLTabChangeTransitioningTypeTranslation
                                                                           animation:nil];
    }

    transitioning.delegate = self;
    _transitioning = YES;

    return transitioning;
}

- (id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return _interactiveTransition;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return ![tabBarController isTabBarInteracting];
}


@end
