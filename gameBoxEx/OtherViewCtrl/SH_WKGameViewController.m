//
//  SH_WKGameViewController.h.m
//  GameBox
//
//  Created by shin on 2018/7/15.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_WKGameViewController.h"
#import <WebKit/WebKit.h>
#import "SH_DragableMenuView.h"
#import "MacroDef.h"
#import "WHC_AutoLayout.h"

@interface SH_WKGameViewController ()

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) SH_DragableMenuView *dragableMenuView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, copy) WKGameWebViewControllerClose closeBlock;
@property (nonatomic, copy) WKGameWebViewControllerCloseAndShowLogin closeAndShowLoginBlock;

@end

@implementation SH_WKGameViewController

- (void)dealloc
{
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

-(BOOL)isSubViewController
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    __weak typeof(self) weakSelf = self;
    if (iPhoneX) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarOrientationChange:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    _wkWebView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
    [self.view addSubview:_wkWebView];
    _wkWebView.whc_TopSpace(0).whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0) ;

    [_wkWebView loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60]];
    
    // KVO，监听webView属性值得变化(estimatedProgress)
    [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.trackTintColor = [UIColor clearColor];
    _progressView.progressTintColor = colorWithRGB(39, 61, 157);
    [_progressView setProgress:0.05 animated:YES];
    [self.view addSubview:_progressView];
    _progressView.whc_TopSpace(0).whc_LeftSpace(0).whc_RightSpace(0).whc_Height(4) ;
    
    _dragableMenuView = [[[NSBundle mainBundle] loadNibNamed:@"SH_DragableMenuView" owner:nil options:nil] lastObject];
    [self.view addSubview:_dragableMenuView];
    UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;
    _dragableMenuView.whc_TopSpace(60).whc_RightSpace(iPhoneX && oriention == UIInterfaceOrientationLandscapeLeft ? 30 :  0).whc_Height(67).whc_Width(32);

    [_dragableMenuView closeAction:^{
        [weakSelf.navigationController popViewControllerAnimated:NO];
        if (weakSelf.closeBlock) {
            weakSelf.closeBlock();
        }
    }];
    
    [_dragableMenuView gobackAction:^{
        if ([weakSelf.wkWebView canGoBack]) {
            [weakSelf.wkWebView goBack];
        }
        else
        {
            [weakSelf.navigationController popViewControllerAnimated:NO];
            if (weakSelf.closeBlock) {
                weakSelf.closeBlock();
            }
        }
    }];
}

- (void)close:(WKGameWebViewControllerClose)closeBlock
{
    self.closeBlock = closeBlock;
}

- (void)closeAndShowLogin:(WKGameWebViewControllerClose)closeAndShowLoginBlock
{
    self.closeAndShowLoginBlock = closeAndShowLoginBlock;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:self.wkWebView] && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            // 加载完成
            // 首先加载到头
            [self.progressView setProgress:newprogress animated:YES];
            // 之后0.3秒延迟隐藏
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                weakSelf.progressView.hidden = YES;
                [weakSelf.progressView setProgress:0 animated:NO];
            });
        }
        else {
            // 加载中
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
    else
    {
        // 其他
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;
    if (oriention == UIInterfaceOrientationLandscapeLeft) {
        self.dragableMenuView.whc_TopSpace(60).whc_RightSpace(iPhoneX && oriention == UIInterfaceOrientationLandscapeLeft ? 30 :  0).whc_Height(67).whc_Width(32);
    }
    else
    {
        self.dragableMenuView.whc_TopSpace(60).whc_RightSpace(0).whc_Height(67).whc_Width(32);
    }
}

- (BOOL)shouldAutorotate
{
    //是否支持转屏
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //支持哪些转屏方向
    return UIInterfaceOrientationMaskAll;
}

@end