//
//  RH_VerifyCloseView.h
//  gameBoxEx
//
//  Created by Richard on 2018/2/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RH_VerifyCloseView;

@protocol VerifyCloseViewDelegate
@optional
-(void)VerifyCloseViewVerifySuccessful:(RH_VerifyCloseView*)VerifyCloseView;
-(void)fogetPassWordBtnClick;
@end

@interface RH_VerifyCloseView : UIView
@property (nonatomic,weak) id<VerifyCloseViewDelegate> delegate;
@end
