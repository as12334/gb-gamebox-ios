//
//  RH_FBPChangePwView.h
//  gameBoxEx
//
//  Created by shin on 2018/6/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RH_FBPChangePwView;
@protocol RH_FBPChangePwViewDelegate

@optional
- (void)changePwViewSubmit:(RH_FBPChangePwView *)view psw:(NSString *)psw;

@end

@interface RH_FBPChangePwView : UIView

@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, weak) id <RH_FBPChangePwViewDelegate> delegate;

@end
