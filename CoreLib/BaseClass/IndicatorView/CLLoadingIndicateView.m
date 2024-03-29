//
//  CLLoadingIndicateView.m
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "CLLoadingIndicateView.h"
#import "help.h"
#import "MacroDef.h"
#import "CLNetReachability.h"


@implementation CLLoadingIndicateView
{
    UITapGestureRecognizer * _tapGestureRecognizer;
}

#pragma mark -

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        _supportTapGesture = NO;
        _contextTag        = DefaultContextTag;
        super.hidden = YES;
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -

- (void)setHidden:(BOOL)hidden {
    //禁止设置可见性
}

- (void)hiddenView
{
    if (!self.isHidden) {
        super.hidden = YES;

        self.supportTapGesture = NO;
        _contextTag = DefaultContextTag;
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NT_NetReachabilityChangedNotification
                                                      object:nil];

        id<CLLoadingIndicateViewDelegate> delegate = self.delegate;
        ifRespondsSelector(delegate, @selector(loadingIndicateViewDidHidden:)) {
            [delegate loadingIndicateViewDidHidden:self];
        }
    }
}

- (void)showView
{
    if (self.isHidden) {
        super.hidden = NO;

        id<CLLoadingIndicateViewDelegate> delegate = self.delegate;
        ifRespondsSelector(delegate, @selector(loadingIndicateViewDidShow:)) {
            [delegate loadingIndicateViewDidShow:self];
        }
    }
}

#pragma mark -

- (void)showLoadingStatusWithTitle:(NSString *)title detailText:(NSString *)detailText
{
    [self hiddenView];

    self.style = CLIndicateViewStyleActivityView;
    self.titleLabelText = title;
    self.detailLabelText = detailText;

    _contextTag = LoadingContextTag;

    [self showView];
}

- (void)showLoadingErrorStatusWithTitle:(NSString *)title detailText:(NSString *)detailText
{
    [self showLoadingErrorStatusWithImage:ImageWithName(@"error_reload.png") title:title detailText:detailText];
}

- (void)showLoadingErrorStatusWithImage:(UIImage *)image
                                  title:(NSString *)title
                             detailText:(NSString *)detailText
{
    [self showImageStatusWithImage:image
                             title:title
                        detailText:detailText
                        contextTag:LoadingErrorContextTag];

    self.supportTapGesture = YES;
}

#pragma mark -

- (void)showNoNetworkStatus
{
    [self showNoNetworkStatusWithImage:ImageWithName(@"error_no_network.png")
                                 title:@"网络似乎断开了连接"
                            detailText:@"请检查网络设置"
                 observerNetworkChange:YES];
}

- (void)showNoNetworkStatusWithImage:(UIImage *)image
                               title:(NSString *)title
                          detailText:(NSString *)detailText
               observerNetworkChange:(BOOL)observerNetworkChange
{
    [self hiddenView];

    self.image = image;
    self.style = CLIndicateViewStyleImageView;

    self.titleLabelText  = title;
    self.detailLabelText = detailText;

    _contextTag = NoNetworkContextTag;

    if (observerNetworkChange) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_networkChangeNotification:)
                                                     name:NT_NetReachabilityChangedNotification
                                                   object:nil];
    }

    [self showView];
}

#pragma mark -

- (void)showNothingWithTitle:(NSString *)title {
    [self showNothingWithTitle:title detailText:@"点击页面刷新"];
}

- (void)showNothingWithTitle:(NSString *)title detailText:(NSString *)detailText {
    [self showNothingWithImage:ImageWithName(@"error_weep") title:title detailText:detailText];
}

- (void)showNothingWithImage:(UIImage *)image title:(NSString *)title detailText:(NSString *)detailText
{
    [self showImageStatusWithImage:image
                             title:title
                        detailText:detailText
                        contextTag:NothingContextTag];

    self.supportTapGesture = YES;
}

#pragma mark -

- (void)showImageStatusWithImage:(UIImage *)image
                           title:(NSString *)title
                      detailText:(NSString *)detailText
{
    [self showImageStatusWithImage:image
                             title:title
                        detailText:detailText
                        contextTag:DefaultContextTag];
}

- (void)showImageStatusWithImage:(UIImage *)image
                           title:(NSString *)title
                      detailText:(NSString *)detailText
                      contextTag:(NSInteger)contextTag
{
    [self hiddenView];

    self.image = image;

    self.style = CLIndicateViewStyleImageView;
    self.titleLabelText = title;
    self.detailLabelText = detailText;

    _contextTag = contextTag;

    [self showView];
}

- (void)showCustomViewStatusWithCustomView:(UIView *)customView
                                     title:(NSString *)title
                                detailText:(NSString *)detailText
{
    [self showCustomViewStatusWithCustomView:customView
                                       title:title
                                  detailText:detailText
                                  contextTag:DefaultContextTag];
}

- (void)showCustomViewStatusWithCustomView:(UIView *)customView
                                     title:(NSString *)title
                                detailText:(NSString *)detailText
                                contextTag:(NSInteger)contextTag
{
    [self hiddenView];

    self.customView = customView;

    self.style = CLIndicateViewStyleCustomView;
    self.titleLabelText = title;
    self.detailLabelText = detailText;

    _contextTag = contextTag;

    [self showView];
}

- (void)showTextViewWithTitle:(NSString *)title
                   detailText:(NSString *)detailText
{
    [self showTextViewWithTitle:title detailText:detailText contextTag:DefaultContextTag];
}

- (void)showTextViewWithTitle:(NSString *)title
                   detailText:(NSString *)detailText
                   contextTag:(NSInteger)contextTag
{
    [self hiddenView];
    self.style = CLIndicateViewStyleNoneView;
    self.titleLabelText = title;
    self.detailLabelText = detailText;

    _contextTag = contextTag;

    [self showView];
}

#pragma mark -

- (void)setSupportTapGesture:(BOOL)supportTapGesture
{
    if (_supportTapGesture != supportTapGesture) {

        if (_supportTapGesture && _tapGestureRecognizer) {
            [self removeGestureRecognizer:_tapGestureRecognizer];
        }

        _supportTapGesture = supportTapGesture;

        if (_supportTapGesture) {

            if (!_tapGestureRecognizer) {
                _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapGestureHandle)];
            }

            [self addGestureRecognizer:_tapGestureRecognizer];
        }
    }
}

- (void)_tapGestureHandle
{
    id<CLLoadingIndicateViewDelegate> delegate = self.delegate;
    ifRespondsSelector(delegate, @selector(loadingIndicateViewDidTap:)){
        [delegate loadingIndicateViewDidTap:self];
    }
}

- (void)_networkChangeNotification:(NSNotification *)notification
{
    if (_contextTag == NoNetworkContextTag && NetworkAvailable()) {
        [self _tapGestureHandle];
    }else if (_contextTag != NoNetworkContextTag){
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NT_NetReachabilityChangedNotification
                                                      object:nil];
    }
}

@end
