//
//  RH_GestureLockMainView.m
//  gameBoxEx
//
//  Created by jun on 2018/7/5.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_GestureLockMainView.h"
#import "RH_GestureOpenLockView.h"
#import "RH_VeriftyLoginPWDViewController.h"
@interface RH_GestureLockMainView()<GestureOpenLockViewDelegate>
@property(nonatomic,strong)RH_GestureOpenLockView *openLockView;
@property(nonatomic,strong)UIViewController *tvc;
@end
@implementation RH_GestureLockMainView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
         [self addSubview:self.openLockView];
    }
    return self;
}
#pragma mark--
#pragma mark--lazy
-(RH_GestureOpenLockView *)openLockView
{
    if (!_openLockView) {
        _openLockView = [[RH_GestureOpenLockView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _openLockView.delegate = self;
        
    }
    return _openLockView;
}

-(void)gestureOpenLockViewOpenLockSuccessful:(RH_GestureOpenLockView *)gestureOpenLockView
{
    [self.delegate RH_GestureLockMainViewSeccussful];
}

- (void)forgetGesturePWD{
    RH_VeriftyLoginPWDViewController *vc = [[RH_VeriftyLoginPWDViewController alloc]init];
    [self.tvc presentViewController:vc animated:YES completion:nil];
    [self.delegate RH_GestureLockMainViewSeccussful];
    
}
-(void)gestureViewShowWithController:(UIViewController *)controller{
    self.tvc = controller;
    [UIView animateWithDuration:0.7 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
    }];
}
@end
