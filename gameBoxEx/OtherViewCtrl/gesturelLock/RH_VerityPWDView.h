//
//  RH_VerityPWDView.h
//  gameBoxEx
//
//  Created by jun on 2018/7/3.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RH_VerityPWDViewDelegate<NSObject>
-(void)forgetPSWBtnClick;
-(void)jumpTologin;
-(void)setPSW;
@end
@interface RH_VerityPWDView : UIView
@property(nonatomic,weak)id<RH_VerityPWDViewDelegate>delegate;
@end
