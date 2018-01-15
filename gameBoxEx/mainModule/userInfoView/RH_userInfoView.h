//
//  RH_userInfoView.h
//  lotteryBox
//
//  Created by Lewis on 2017/12/25.
//  Copyright © 2017年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coreLib.h"

#define userInfoViewWidth                                               200.0f
#define userInfoViewHeigh                                               400.0f

@class RH_userInfoView ;
@protocol UserInfoViewDelegate
@optional
-(void)userInfoViewDidTouchOneStepRecoryButton:(RH_userInfoView*)userInfoView ;
-(void)userInfoViewDidTouchOneStepDepositeButton:(RH_userInfoView*)userInfoView ;
@end

@interface RH_userInfoView : CLBorderView
@property(nonatomic,weak) id<UserInfoViewDelegate> delegate ;
@end
