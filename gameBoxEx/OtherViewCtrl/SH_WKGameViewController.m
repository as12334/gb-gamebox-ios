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
#import "RH_UserInfoManager.h"
#import "DCPathButton.h"
#import "RH_SureLeaveApiView.h"

@interface SH_WKGameViewController ()<WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate,DCPathButtonDelegate,RH_SureLeaveApiViewDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) SH_DragableMenuView *dragableMenuView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong, readonly) RH_SureLeaveApiView *sureLeaveApiView;
@property (nonatomic, copy) WKGameWebViewControllerClose closeBlock;
@property (nonatomic, copy) WKGameWebViewControllerCloseAndShowLogin closeAndShowLoginBlock;
@property (nonatomic, strong)DCPathButton *dcPathButton;
@property (nonatomic, strong) UIView *shadeView;
@end

@implementation SH_WKGameViewController
@synthesize sureLeaveApiView = _sureLeaveApiView;



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
    
    [self setHiddenStatusBar:YES];
    
    self.hiddenTabBar = YES;
    self.hiddenNavigationBar = YES;
    //    WKUserContentController *controller = [[WKUserContentController alloc] init]; [controller addScriptMessageHandler: self name: @"Could be any srting value"];
    //    WKPreferences *preferences = [[WKPreferences alloc] init]; preferences.javaScriptCanOpenWindowsAutomatically = YES;
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    //    configuration.userContentController = controller;
    //    configuration.preferences = preferences;
    //    configuration.allowsInlineMediaPlayback = YES;
    _wkWebView = [[WKWebView alloc] initWithFrame: CGRectZero configuration: configuration];
    _wkWebView.UIDelegate = self;
    _wkWebView.navigationDelegate = self;
    [self.view addSubview:_wkWebView];
    
    _wkWebView.whc_TopSpace(0).whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0) ;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    NSDictionary *headFields = request.allHTTPHeaderFields;
    NSString *    cookie = headFields[@"SID"];
    NSArray *sidStringCompArr = [[RH_UserInfoManager shareUserManager].sidString componentsSeparatedByString:@";"];
    NSString *sid = [[sidStringCompArr firstObject] stringByReplacingOccurrencesOfString:@"SID=" withString:@""];
    if (cookie == nil && ![self.url hasPrefix:@"http"]) {
        [request addValue:[NSString stringWithFormat:@"SID=%@",sid] forHTTPHeaderField:@"Cookie"];
    }
    [_wkWebView loadRequest:request];
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
        [self showAlertView];
    }];
    
    [_dragableMenuView gobackAction:^{
        if ([weakSelf.wkWebView canGoBack]) {
            [weakSelf.wkWebView goBack];
        }
        else
        {
            [self showAlertView];
        }
    }];
    
    [self  configureDCPathButton];
}

-(void) showAlertView {
    //遮罩层
    UIView *shadeView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    shadeView.backgroundColor = [UIColor lightGrayColor];
    shadeView.alpha = 0.7f;
    shadeView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeShadeView)];
    [shadeView addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview:shadeView];
    _shadeView = shadeView;
    [[UIApplication sharedApplication].keyWindow addSubview:self.sureLeaveApiView];
}

- (void) closeShadeView {
    [self.shadeView removeFromSuperview];
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

#pragma mark - WKUIDelegate M

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    [_wkWebView loadRequest:[NSMutableURLRequest requestWithURL:navigationAction.request.URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60]];
    
    return nil;
}

#pragma mark - WKNavigationDelegate M

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}

// 内容开始加载
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}

// 页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
}

// 页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    
}

// 收到服务器重定向请求
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    
}

// 在收到响应开始加载后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    WKNavigationResponsePolicy responsePolicy = WKNavigationResponsePolicyAllow;
    decisionHandler(responsePolicy);
}

// 在请求开始加载之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    WKNavigationActionPolicy Allow = WKNavigationActionPolicyAllow;
    decisionHandler(Allow);
}


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
        self.dcPathButton.dcButtonCenter = CGPointMake(MainScreenH, MainScreenW/2.0);
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

-(void)configureDCPathButton{
    DCPathButton *dcPathButton = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"floating_initial"]
                                                         highlightedImage:nil];
    dcPathButton.delegate = self;
    
    // Configure item buttons
    //
    DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"floating_home"]
                                                           highlightedImage:nil
                                                            backgroundImage:nil
                                                 backgroundHighlightedImage:nil];
    
    DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"floating_return"]
                                                           highlightedImage:nil
                                                            backgroundImage:nil
                                                 backgroundHighlightedImage:nil];
    
    DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"floating_refresh"]
                                                           highlightedImage:nil
                                                            backgroundImage:nil
                                                 backgroundHighlightedImage:nil];
    
    DCPathItemButton *itemButton_4 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"floating_collection"]
                                                           highlightedImage:nil
                                                            backgroundImage:nil
                                                 backgroundHighlightedImage:nil];
    
    // Add the item button into the center button
    //
    [dcPathButton addPathItems:@[itemButton_4,
                                 itemButton_3,
                                 itemButton_2,
                                 itemButton_1
                                 ]];
    
    // Change the bloom radius, default is 105.0f
    //
    //    dcPathButton.bloomRadius = 120.0f;
    
    // Change the DCButton's center
    //
    dcPathButton.dcButtonCenter = CGPointMake(screenSize().width-25, screenSize().height/2.0);
    
    // Setting the DCButton appearance
    //
    dcPathButton.allowSounds = false;
    dcPathButton.allowCenterButtonRotation = false;
    
    dcPathButton.bottomViewColor = [UIColor clearColor];
    
    dcPathButton.bloomDirection = kDCPathButtonBloomDirectionLeft;
    
    [self.view addSubview:dcPathButton];
    
    [self.view bringSubviewToFront:dcPathButton];
    
    self.dcPathButton = dcPathButton;
}

#pragma mark - DCPathButton Delegate

- (void)willPresentDCPathButtonItems:(DCPathButton *)dcPathButton {
    
    NSLog(@"ItemButton will present");
    
}

- (void)didPresentDCPathButtonItems:(DCPathButton *)dcPathButton {
    
    NSLog(@"ItemButton did present");
    
}

- (void)pathButton:(DCPathButton *)dcPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    NSLog(@"You tap %@ at index : %lu", dcPathButton, (unsigned long)itemButtonIndex);
    if (itemButtonIndex ==1) {
        //refresh
    }else if(itemButtonIndex ==2) {
        if ([self.wkWebView canGoBack]) {
            [self.wkWebView goBack];
        }
        else
        {
            [self showAlertView];
        }
    }else if (itemButtonIndex ==3){
        [self showAlertView];
    }else if (itemButtonIndex ==0){
        // Collection
        NSArray * array = [NSArray arrayWithContentsOfFile:[self pathForFile:@"gameURL"]];
        NSMutableArray * url_array = [NSMutableArray arrayWithArray:array];
        if (![array containsObject:self.url]) {
            [url_array addObject:self.url];
            [url_array writeToFile:[self pathForFile:@"gameURL"] atomically:YES];
            NSLog(@"----%@",array);
        }else{
            showMessage(self.view, nil, @"已经收藏");
        }
    }
}

- (void)willDismissDCPathButtonItems:(DCPathButton *)dcPathButton {
    
    NSLog(@"ItemButton will dismiss");
}

- (void)didDismissDCPathButtonItems:(DCPathButton *)dcPathButton {
    
    NSLog(@"ItemButton did dismiss");
    
}

-(NSString*)pathForFile:(NSString*)fileName{
    NSString  * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePatch = [path stringByAppendingPathComponent:fileName];
    return filePatch;
}
- (void)pathButton:(DCPathButton *)dcPathButton didUpdateOrientation:(DCPathButtonOrientation)orientation{
    if (orientation == DCPathButtonOrientationLandscape) {
        self.dcPathButton.dcButtonCenter = CGPointMake(screenSize().height-25, screenSize().width/2.0);
    }else if (orientation == DCPathButtonOrientationPortrait){
        self.dcPathButton.dcButtonCenter = CGPointMake(screenSize().width-25, screenSize().height/2.0);
    }
}

- (RH_SureLeaveApiView *)sureLeaveApiView {
    if (!_sureLeaveApiView) {
        _sureLeaveApiView = [RH_SureLeaveApiView createInstance];
        _sureLeaveApiView.frame = CGRectMake(0, 0, 270, 172);
        _sureLeaveApiView.center = self.view.center;
        _sureLeaveApiView.delegate = self;
    }
    return _sureLeaveApiView;
}

#pragma RH_SureLeaveApiViewDelegate -m
- (void )sureLeaveApiViewDelegate {
    [self.shadeView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:NO];
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void) cancelLeaveApiViewDelegate {
    [self.shadeView removeFromSuperview];
}

@end
