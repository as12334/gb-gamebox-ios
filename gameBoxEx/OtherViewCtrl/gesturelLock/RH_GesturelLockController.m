//
//  RH_GesturelLockController.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/17.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_GesturelLockController.h"
#import "RH_GesturelLockView.h"
#import "RH_LockSetPWDController.h"
#import "MBProgressHUD.h"
#import "RH_GestureOpenLockView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface RH_GesturelLockController ()<GestureOpenLockViewDelegate>
//@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)RH_GestureOpenLockView *openLockView;
@end

@implementation RH_GesturelLockController
@synthesize openLockView = _openLockView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hiddenStatusBar = YES ;
    self.hiddenTabBar = YES ;
    self.hiddenNavigationBar = YES ;
    
    [self.view addSubview:self.openLockView];
    
}

-(RH_GestureOpenLockView *)openLockView
{
    if (!_openLockView) {
        _openLockView = [[RH_GestureOpenLockView alloc] initWithFrame:self.view.bounds];
        _openLockView.delegate = self ;
        
    }
    return _openLockView;
}

-(void)gestureOpenLockViewOpenLockSuccessful:(RH_GestureOpenLockView*)gestureOpenLockView
{
    if (self.presentingViewController){
        [self dismissViewControllerAnimated:YES completion:nil] ;
    }else{
        [self.navigationController popViewControllerAnimated:YES] ;
    }
}

@end
