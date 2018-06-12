//
//  RH_BindUserPhone.h
//  gameBoxEx
//
//  Created by shin on 2018/6/8.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RH_BindUserPhone;
@protocol RH_BindUserPhoneDelegate

- (void)bindUserPhoneContact:(RH_BindUserPhone *)view;
- (void)bindUserPhoneSendCode:(RH_BindUserPhone *)view phone:(NSString *)phone;
- (void)bindUserPhoneBind:(RH_BindUserPhone *)view phone:(NSString *)phone code:(NSString *)code;

@end

@interface RH_BindUserPhone : UIView

@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, weak) id <RH_BindUserPhoneDelegate> delegate;

- (void)clearTimer;

@end
