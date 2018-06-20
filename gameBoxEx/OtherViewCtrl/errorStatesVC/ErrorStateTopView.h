//
//  ErrorStateTopView.h
//  gameBoxEx
//
//  Created by sam on 2018/4/28.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ErrorStateTopView;
@protocol ErrorStateTopViewDelegate<NSObject>
@optional
-(void)errorStatusOpenOnlinecustom:(ErrorStateTopView *)errorView;
-(void)errorStatusQQcustom:(ErrorStateTopView *)errorView;
@end
@interface ErrorStateTopView : UIView
@property(nonatomic,weak)id<ErrorStateTopViewDelegate>delegate;
@end
