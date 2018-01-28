//
//  RH_SubNavigationBarView.h
//  TaskTracking
//
//  Created by jinguihua on 2017/2/20.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_userInfoView.h"

@class RH_NavigationBarView ;
@protocol RH_NavigationBarViewDelegate <NSObject>
@optional
-(void)navigationBarViewDidTouchLoginButton:(RH_NavigationBarView*)navigationBarView ;
-(void)navigationBarViewDidTouchSignButton:(RH_NavigationBarView*)navigationBarView ;
-(void)navigationBarViewDidTouchUserInfoButton:(RH_NavigationBarView*)navigationBarView ;
@end

@interface RH_NavigationBarView : UIView
@property(nonatomic,weak) id<RH_NavigationBarViewDelegate> delegate ;
-(void)updateTitle:(NSString*)title ;
@end
