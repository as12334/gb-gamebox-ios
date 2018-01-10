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
#import "RH_NormalActivithyView.h"
@interface RH_MachineAnimationView()<RH_ServiceRequestDelegate>
@property(nonatomic,strong,readonly)UIImageView *imageView;
@property(nonatomic,strong,readonly)UIButton *closeBtn;

@property(nonatomic,strong,readonly) RH_ServiceRequest *serviceRequest ;
@property(nonatomic,strong,readonly)RH_OpenActivithyView *activithyView;
@property(nonatomic,strong,readonly)RH_NormalActivithyView *normalActivityView;
@end
@implementation RH_MachineAnimationView
{
    int _animationTimes;
}
@synthesize imageView = _imageView;
@synthesize closeBtn = _closeBtn;
@synthesize serviceRequest = _serviceRequest;
@synthesize activithyView = _activithyView;
@synthesize normalActivityView = _normalActivityView;
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
//-(RH_OpenActivithyView *)activithyView
//{
//    if (!_activithyView) {
//        _activithyView = [RH_OpenActivithyView createInstance];;
//        _activithyView.frame = CGRectMake(0, 0, 300, 300);
//        _activithyView.center = self.center;
//        _activithyView. = self.activityModel;
//    }
//    return _activithyView;
//}
/**
    未打开的红包大图
 */
-(RH_NormalActivithyView *)normalActivityView
{
    if (!_normalActivityView) {
        _normalActivityView = [RH_NormalActivithyView createInstance];
        _normalActivityView.frame =CGRectMake(0, 0, 300,350);
//        _normalActivityView
    }
    return _normalActivityView;
}
-(instancetype)initWithFrame:(CGRect)frame;
{
    if (self=[super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self addSubview:self.imageView];
        [self addSubview:self.normalActivityView];
        self.normalActivityView.center = self.center;
        self.normalActivityView.alpha = 0;
        //显示时建立引用循环
        _animationTimes = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeSubwindow)];
//        [self.subwindow addGestureRecognizer:tap];
    }
    return self;
}
-(void)showAnimation
{
    if (!self.normalActivityView&&!self.closeBtn) {
        [self addSubview:self.closeBtn];
        [self addSubview:self.normalActivityView];
    }
    self.normalActivityView.nextOpentimeLabel.text = self.openActivityModel.mNextLotteryTime;
    [self startanimationRotate];
    [self startanimationTranslation];
}

-(void)startanimationTranslation
{
    // 执行动画
    [UIView animateWithDuration:1.f
                     animations:^{
                         self.imageView.center = self.center;
                         self.imageView.alpha = 0;
                         self.normalActivityView.alpha = 1.f;
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
   
}

@end
