//
//  RH_InputAccountView.h
//  gameBoxEx
//
//  Created by shin on 2018/6/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RH_InputAccountView;
@protocol RH_InputAccountViewDelegate

- (void)inputAccountView:(RH_InputAccountView *)view next:(NSString *)account;
@end

@interface RH_InputAccountView : UIView

@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, weak) id <RH_InputAccountViewDelegate> delegate;

@end
