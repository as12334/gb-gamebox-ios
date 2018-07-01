//
//  RH_GestureOpenLockView.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/7.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RH_GestureOpenLockView ;

@protocol GestureOpenLockViewDelegate
@optional
-(void)gestureOpenLockViewOpenLockSuccessful:(RH_GestureOpenLockView*)gestureOpenLockView;
@end

@interface RH_GestureOpenLockView : UIView
@property (nonatomic,weak) id<GestureOpenLockViewDelegate> delegate;
@end
