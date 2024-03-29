//
//  RH_LoadingIndicateView.m
//  TaskTracking
//
//  Created by apple pro on 2017/2/28.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_LoadingIndicateView.h"
#import "coreLib.h"
#import "RH_ErrorCode.h"

@implementation RH_LoadingIndicateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.titleLabelFont = [UIFont systemFontOfSize:15.f];
        self.detailLabelFont = [UIFont systemFontOfSize:13.f];
        self.titleLabelColor  = ColorWithNumberRGB(0x808080);
        self.detailLabelColor = ColorWithNumberRGB(0xCCCCCC);
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.titleLabelFont = [UIFont systemFontOfSize:15.f];
        self.detailLabelFont = [UIFont systemFontOfSize:13.f];
        self.titleLabelColor  = ColorWithNumberRGB(0x808080);
        self.detailLabelColor = ColorWithNumberRGB(0xCCCCCC);
    }

    return self;
}


#pragma mark -

- (void)showDefaultLoadingErrorStatus
{
    [self showLoadingErrorStatusWithImage:ImageWithName(@"icon_error_reload")
                                    title:@"数据加载出错"
                               detailText:@"点击页面重试"];
}

- (void)showDefaultNeedLoginStatus
{
    [self showLoadingErrorStatusWithImage:ImageWithName(@"icon_error_reload")
                                    title:@"用户未登录"
                               detailText:@"点击页面登录"];
}

- (void)showDefaultLoadingErrorStatus:(NSError*)error
{
    if (error.code==RH_API_ERRORCODE_NO_JSON_ERROR){
        [self showLoadingErrorStatusWithImage:ImageWithName(@"icon_error_reload")
                                        title:[NSString stringWithFormat:@"%@",error.localizedDescription]
                                   detailText:@"点击页面重试"];
    }else{
        [self showLoadingErrorStatusWithImage:ImageWithName(@"icon_error_reload")
                                        title:[NSString stringWithFormat:@"%@",error.localizedDescription]
                                   detailText:@"点击页面重试"];
    }
}

- (void)showNoNetworkStatus
{
    [self showNoNetworkStatusWithImage:ImageWithName(@"icon_none_network")
                                 title:nil
                            detailText:@"网络不存在"
                 observerNetworkChange:YES];
}

- (void)showNothingWithTitle:(NSString *)title detailText:(NSString *)detailText {
    [self showNothingWithImage:ImageWithName(@"icon_empty_Data") title:title detailText:detailText];
}


- (void)showInfoInInvalidWithTitle:(NSString *)title detailText:(NSString *)detailText
{
    [self showNothingWithTitle:title detailText:detailText];
    self.supportTapGesture = NO;
}

- (void)showSearchEmptyStatus
{
    [self showImageStatusWithImage:ImageWithName(@"empty_searchRec_image")
                             title:nil
                        detailText:@"您暂无相关数据记录"];
}

@end
