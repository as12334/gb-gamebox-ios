//
//  RH_AdvertisingView.m
//  gameBoxEx
//
//  Created by lewis on 2018/6/5.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_AdvertisingView.h"
#import "coreLib.h"
#import "RH_API.h"
@interface RH_AdvertisingView()<UIWebViewDelegate>
@property(nonatomic,strong)NSString *urlString;
@property(nonatomic,strong)UIButton *timerBtn;
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,assign)int timerNum;
@property(nonatomic,strong)dispatch_source_t sourceTimer;
@end
@implementation RH_AdvertisingView
+(RH_AdvertisingView *)ceareAdvertisingView:(NSString *)urlString
{
    static RH_AdvertisingView *advertisingView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        advertisingView = [[RH_AdvertisingView alloc]initWithFrame:CGRectMake(0,0, MainScreenW, MainScreenH)];
        advertisingView.backgroundColor = [UIColor whiteColor];
    });
    advertisingView.urlString = urlString;
    advertisingView.timerNum = 4;
    [advertisingView loadWebView];
    return advertisingView;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
-(void)loadWebView
{
//    [super layoutSubviews];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    _webView.delegate = self;
    [self.timerBtn setTitle:[NSString stringWithFormat:@"%d",self.timerNum] forState:UIControlStateNormal];
}


-(void)createUI{
    _webView = [[UIWebView alloc]initWithFrame:self.bounds];
    [self addSubview:_webView];
    self.timerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.timerBtn.frame = CGRectMake(self.frameWidth-100, 30, 50, 20);
    self.timerBtn.backgroundColor = [UIColor cyanColor];
    self.timerBtn.alpha = 0.8;
    [self.timerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.timerBtn addTarget:self action:@selector(closeAdvertising) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark ==============webview delegate================
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self addSubview:self.timerBtn];
    [self createDispatch_source_t];
}
//dispatch_source_t
-(void)createDispatch_source_t{
    
    //创建全局队列
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue = dispatch_get_main_queue();
    //使用全局队列创建计时器
    _sourceTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //定时器延迟时间
    NSTimeInterval delayTime = 1.0f;
    
    //定时器间隔时间
    NSTimeInterval timeInterval = 1.0f;
    
    //设置开始时间
    dispatch_time_t startDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC));
    
    //设置计时器
    dispatch_source_set_timer(_sourceTimer,startDelayTime,timeInterval*NSEC_PER_SEC,0.1*NSEC_PER_SEC);
    
    //执行事件
    dispatch_source_set_event_handler(_sourceTimer,^{
        self.timerNum--;
        [self.timerBtn setTitle:[NSString stringWithFormat:@"%d",self.timerNum] forState:UIControlStateNormal];
        //销毁定时器
        //dispatch_source_cancel(_myTimer);
        if (self.timerNum<0) {
            dispatch_source_cancel(_sourceTimer);
            self.block();
        }
    });
    
    //启动计时器
    dispatch_resume(_sourceTimer);
}
-(void)closeAdvertising
{
    dispatch_source_cancel(_sourceTimer);
    self.block();
}
@end
