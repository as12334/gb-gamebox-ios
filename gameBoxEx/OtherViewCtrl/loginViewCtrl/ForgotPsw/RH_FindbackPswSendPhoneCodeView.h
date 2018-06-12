//
//  RH_FindbackPswSendPhoneCodeView.h
//  gameBoxEx
//
//  Created by shin on 2018/6/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RH_FindbackPswSendPhoneCodeView;
@protocol RH_FindbackPswSendPhoneCodeViewDelegate

@optional
- (void)findbackPswSendPhoneCodeViewSendCode:(RH_FindbackPswSendPhoneCodeView *)view;
- (void)findbackPswSendPhoneCodeViewNext:(RH_FindbackPswSendPhoneCodeView *)view code:(NSString *)code;

@end

@interface RH_FindbackPswSendPhoneCodeView : UIView

@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, weak) id <RH_FindbackPswSendPhoneCodeViewDelegate> delegate;

- (void)clearTimer;
- (void)autoSendCode;

@end
