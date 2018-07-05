//
//  RH_GestureLockMainView.h
//  gameBoxEx
//
//  Created by jun on 2018/7/5.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RH_GestureLockMainViewDelegate<NSObject>
-(void)RH_GestureLockMainViewSeccussful;
@end
@interface RH_GestureLockMainView : UIView
@property(nonatomic,weak)id<RH_GestureLockMainViewDelegate>delegate;
-(void)gestureViewShowWithController:(UIViewController *)controller;
@end
