//
//  RH_MachineAnimationView.m
//  gameBoxEx
//
//  Created by Lewis on 2018/1/1.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MachineAnimationView.h"
#import "coreLib.h"
#import "RH_ServiceRequest.h"
#import "RH_OpenActivithyView.h"
@interface RH_MachineAnimationView()<RH_ServiceRequestDelegate>
@property(nonatomic,strong,readonly)UIWindow *subwindow;
@property(nonatomic,strong,readonly)UIImageView *imageView;
@property(nonatomic,strong,readonly)UIButton *closeBtn;

@property(nonatomic,strong,readonly) RH_ServiceRequest *serviceRequest ;
@property(nonatomic,strong,readonly)RH_OpenActivithyView *activithyView;
@end
@implementation RH_MachineAnimationView
{
    int _animationTimes;
}
@synthesize subwindow = _subwindow;
@synthesize imageView = _imageView;
@synthesize closeBtn = _closeBtn;
@synthesize serviceRequest = _serviceRequest;
@synthesize activithyView = _activithyView;
-(UIWindow *)subwindow
{
    if(!_subwindow){
        _subwindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _subwindow.windowLevel = UIWindowLevelStatusBar + 1;
    }
    return _subwindow;
}
/**
 动画的图片
 */
-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 400, 120, 120)];
        [_imageView setImage:[UIImage imageNamed:@"hongbao-02hover_04"]];
    }
    return _imageView;
}
/**
 开奖时的大图
 */
-(RH_OpenActivithyView *)activithyView
{
    if (!_activithyView) {
        _activithyView = [RH_OpenActivithyView createInstance];;
        _activithyView.frame = CGRectMake(0, 0, 300, 300);
        _activithyView.center = self.center;
        _activithyView.activityModel = self.activityModel;
    }
    return _activithyView;
}
-(instancetype)initWithFrame:(CGRect)frame;
{
    if (self=[super initWithFrame:frame]) {
        self.frame = self.subwindow.bounds;
        self.subwindow.userInteractionEnabled = YES;
        [self.subwindow addSubview:self.imageView];
        [self.subwindow addSubview:self.activithyView];
        self.activithyView.center = self.subwindow.center;
        self.activithyView.alpha = 0;
        self.subwindow.backgroundColor = [UIColor grayColor];
        //显示时建立引用循环
        _animationTimes = 0;
        [self.subwindow addSubview:self];
        self.subwindow.alpha = 0;
        [self.subwindow setHidden:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeSubwindow)];
        [self.subwindow addGestureRecognizer:tap];
    }
    return self;
}
-(void)showAnimation
{
    if (!self.activithyView&&!self.closeBtn) {
        [self.subwindow addSubview:self.closeBtn];
        [self.subwindow addSubview:self.activithyView];
    }
    self.activithyView.timeLabel.text = self.activityModel.mNextLotteryTime;
    self.activithyView.chanceLabel.text = self.activityModel.mDrawTimes;
    [self startanimationRotate];
    [self startanimationTranslation];
}
-(void)startanimationTranslation
{
    // 执行动画
    [UIView animateWithDuration:1.f
                     animations:^{
                         self.imageView.center = self.subwindow.center;
                         [self.subwindow setHidden:NO];
                         self.subwindow.alpha = 0.8;
                         self.imageView.alpha = 0;
                         self.activithyView.alpha = 1.f;
                     }
                     completion:^(BOOL finished){
                   
                     }];
}
-(void)startanimationRotate
{
    CGFloat circleByOneSecond = 6.f;
    
    // 执行动画
    [UIView animateWithDuration:1.f / circleByOneSecond
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = self.imageView.frame;
                         frame.size.width*=1.2;
                         frame.size.height*=1.2;
                         self.imageView.frame=frame;
                         self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI);
                     }
                     completion:^(BOOL finished){
                         _animationTimes ++;
                         if (_animationTimes<5) {
                             self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, 0);
                             [self startanimationRotate];
                         }
                     }];
    
}
- (void)closeSubwindow
{
    if (self.subwindow) {
        //隐藏
        
        [UIView animateWithDuration:1.f animations:^{
            self.activithyView.alpha = 0;
            self.subwindow.alpha = 0;
            self.closeBtn.alpha = 0;
        } completion:^(BOOL finished) {
            [self.subwindow setHidden:YES];
            for(UIView *subView in [self.subwindow subviews])
            {
                [subView removeFromSuperview];
            }
            [self.closeBtn removeFromSuperview];
            [self.activithyView removeFromSuperview];
        }];
        
    }
}

@end
