//
//  RH_SureLeaveApiView.h
//  gameBoxEx
//
//  Created by sam on 2018/10/1.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_SureLeaveApiView.h"

@class RH_SureLeaveApiView;
@protocol RH_SureLeaveApiViewDelegate <NSObject>
@optional
- (void )sureLeaveApiViewDelegate;
- (void )cancelLeaveApiViewDelegate;
@end

NS_ASSUME_NONNULL_BEGIN
@interface RH_SureLeaveApiView : UIView
@property (nonatomic, weak) id<RH_SureLeaveApiViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
