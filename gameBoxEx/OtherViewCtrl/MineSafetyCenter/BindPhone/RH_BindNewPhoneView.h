//
//  RH_BindNewPhoneView.h
//  gameBoxEx
//
//  Created by shin on 2018/6/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RH_BindNewPhoneView;
@protocol RH_BindNewPhoneViewDelegate

- (void)bindNewPhoneViewContact:(RH_BindNewPhoneView *)view;
- (void)bindNewPhoneViewSendCode:(RH_BindNewPhoneView *)view phone:(NSString *)phone;
- (void)bindNewPhoneViewBind:(RH_BindNewPhoneView *)view phone:(NSString *)phone originalPhone:(NSString *)originalPhone code:(NSString *)code;

@end

@interface RH_BindNewPhoneView : UIView

@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, weak) id <RH_BindNewPhoneViewDelegate> delegate;

- (void)clearTimer;

@end
