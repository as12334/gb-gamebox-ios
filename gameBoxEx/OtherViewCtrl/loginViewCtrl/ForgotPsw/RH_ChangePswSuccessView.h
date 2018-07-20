//
//  RH_ChangePswSuccessView.h
//  gameBoxEx
//
//  Created by shin on 2018/6/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RH_ChangePswSuccessView;
@protocol RH_ChangePswSuccessViewDelegate

- (void)changePswSuccessViewClose:(RH_ChangePswSuccessView *)view;
@end

@interface RH_ChangePswSuccessView : UIView

@property (nonatomic, weak) id <RH_ChangePswSuccessViewDelegate> delegate;

@end
