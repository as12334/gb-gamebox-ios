//
//  CLLoadingIndicateView.h
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "CLIndicateView.h"

//----------------------------------------------------------

#define DefaultContextTag       -1
#define LoadingContextTag       101
#define LoadingErrorContextTag  102
#define NoNetworkContextTag     103
#define NothingContextTag       104

//----------------------------------------------------------


//----------------------------------------------------------

@class CLLoadingIndicateView;

//----------------------------------------------------------

@protocol CLLoadingIndicateViewDelegate

@optional

//点击或网络可用
- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView;

//已经显示
- (void)loadingIndicateViewDidShow:(CLLoadingIndicateView *)loadingIndicateView;

//已经隐藏
- (void)loadingIndicateViewDidHidden:(CLLoadingIndicateView *)loadingIndicateView;

@end

//----------------------------------------------------------


@interface CLLoadingIndicateView : CLIndicateView

@property(nonatomic,weak) id<CLLoadingIndicateViewDelegate> delegate;

//支持点击事件，默认为NO
@property(nonatomic) BOOL supportTapGesture;

//上下文标记
@property(nonatomic,readonly) NSInteger contextTag;


//加载
- (void)showLoadingStatusWithTitle:(NSString *)title detailText:(NSString *)detailText;


//无网络
- (void)showNoNetworkStatus;
- (void)showNoNetworkStatusWithImage:(UIImage *)image
                               title:(NSString *)title
                          detailText:(NSString *)detailText
               observerNetworkChange:(BOOL)observerNetworkChange;


//显示图片
- (void)showImageStatusWithImage:(UIImage  *)image
                           title:(NSString *)title
                      detailText:(NSString *)detailText;
- (void)showImageStatusWithImage:(UIImage  *)image
                           title:(NSString *)title
                      detailText:(NSString *)detailText
                      contextTag:(NSInteger)contextTag;

//加载失败
- (void)showLoadingErrorStatusWithTitle:(NSString *)title detailText:(NSString *)detailText;
- (void)showLoadingErrorStatusWithImage:(UIImage *)image
                                  title:(NSString *)title
                             detailText:(NSString *)detailText;

//无内容
- (void)showNothingWithTitle:(NSString *)title;
- (void)showNothingWithTitle:(NSString *)title detailText:(NSString *)detailText;
- (void)showNothingWithImage:(UIImage *)image title:(NSString *)title detailText:(NSString *)detailText;

//显示自定义视图
- (void)showCustomViewStatusWithCustomView:(UIView *)customView
                                     title:(NSString *)title
                                detailText:(NSString *)detailText;
- (void)showCustomViewStatusWithCustomView:(UIView *)customView
                                     title:(NSString *)title
                                detailText:(NSString *)detailText
                                contextTag:(NSInteger)contextTag;

//显示文本视图
- (void)showTextViewWithTitle:(NSString *)title
                   detailText:(NSString *)detailText;
- (void)showTextViewWithTitle:(NSString *)title
                   detailText:(NSString *)detailText
                   contextTag:(NSInteger)contextTag;


//显示
- (void)showView;

//隐藏
- (void)hiddenView;


@end
