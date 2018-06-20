//
//  RH_SubsafetyNaviBarView.h
//  TaskTracking
//
//  Created by jinguihua on 2017/2/20.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_userInfoView.h"

@class RH_SafetyNaviBarView ;
@protocol RH_SafetyNaviBarViewDelegate <NSObject>
@optional
-(void)safetyNaviBarViewDidTouchBackButton:(RH_SafetyNaviBarView*)safetyNaviBarView ;
@end

@interface RH_SafetyNaviBarView : UIView
@property(nonatomic,weak) id<RH_SafetyNaviBarViewDelegate> delegate ;
@end
