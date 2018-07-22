//
//  RH_ShareNavBarView.h
//  gameBoxEx
//
//  Created by Richard on 2018/2/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RH_ShareNavBarView;
@protocol RH_ShareNaviBarViewDelegate <NSObject>
@optional
-(void)shareNaviBarViewDidTouchBackButton:(RH_ShareNavBarView*)shareNaviBarView ;
-(void)shareNaviBarViewDidTouchSettingButton:(RH_ShareNavBarView*)shareNaviBarView ;
@end
@interface RH_ShareNavBarView : UIView
@property(nonatomic,weak) id<RH_ShareNaviBarViewDelegate> delegate ;
@end
