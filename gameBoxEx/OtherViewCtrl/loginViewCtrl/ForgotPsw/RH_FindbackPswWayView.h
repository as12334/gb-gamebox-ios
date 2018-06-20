//
//  RH_FindbackPswWaysView.h
//  gameBoxEx
//
//  Created by shin on 2018/6/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RH_FindbackPswWayView;

@protocol RH_FindbackPswWayViewDelegate

@optional
- (void)findbackPswWayViewFindByPhone:(RH_FindbackPswWayView *)view;
- (void)findbackPswWayViewFindByCust:(RH_FindbackPswWayView *)view;
- (void)findbackPswWayViewBindPhone:(RH_FindbackPswWayView *)view;

@end

@interface RH_FindbackPswWayView : UIView

@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, weak) id <RH_FindbackPswWayViewDelegate> delegate;

@end
