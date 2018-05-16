//
//  RH_StaticAlertView.h
//  gameBoxEx
//
//  Created by Lenny on 2018/1/28.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RH_StaticAlertViewDelegate
@optional
- (void)didStaticAlertViewCancelButtonClicked;
@end
@interface RH_StaticAlertView : UIView
@property (nonatomic, strong) id <RH_StaticAlertViewDelegate> delegate;
- (void)showContentView;
@end
