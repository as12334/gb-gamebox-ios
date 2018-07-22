//
//  RH_StaticAlertView.h
//  gameBoxEx
//
//  Created by Richard on 2018/4/2.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DepositSuccessAlertViewDelegate
@optional
- (void)depositSuccessAlertViewDidTouchCancelButton ;
- (void)depositSuccessAlertViewDidTouchSaveAgainBtn ;
- (void)depositSuccessAlertViewDidTouchCheckCapitalBtn ;
@end
@interface RH_DepositSuccessAlertView : UIView
@property (nonatomic, strong) id <DepositSuccessAlertViewDelegate> delegate;
- (void)showContentView;
@end
