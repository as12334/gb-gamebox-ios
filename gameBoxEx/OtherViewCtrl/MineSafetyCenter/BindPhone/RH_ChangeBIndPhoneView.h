//
//  RH_ChangeBIndPhoneView.h
//  gameBoxEx
//
//  Created by shin on 2018/6/8.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RH_ChangeBIndPhoneView;
@protocol RH_ChangeBIndPhoneViewDelegate

- (void)changBindUserPhoneContact:(RH_ChangeBIndPhoneView *)view;
- (void)changBindUserPhoneChangeBind:(RH_ChangeBIndPhoneView *)view;

@end

@interface RH_ChangeBIndPhoneView : UIView

@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, weak) id <RH_ChangeBIndPhoneViewDelegate> delegate;

@end
