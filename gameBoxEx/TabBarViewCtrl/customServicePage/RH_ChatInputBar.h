//
//  RH_ChatInputBar.h
//  gameBoxEx
//
//  Created by luis on 2017/10/18.
//  Copyright © 2017年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RH_ChatInputBar ;

@protocol RH_ChatInputBarDelegate <NSObject>
@optional
-(void)ChatInputBarInputTextDidChanged:(RH_ChatInputBar*)chatInputBar ;
-(void)ChatInputBarInputTextTouchSend:(RH_ChatInputBar*)chatInputBar ;
@end

@interface RH_ChatInputBar : UIView

@property(nonatomic, weak) id<RH_ChatInputBarDelegate> delegate;
@property(nonatomic,readonly,strong) UITextView* textView;

- (id)initWithFrame:(CGRect)frame ;

/** 更新frame */
- (void)updateFrame:(CGRect)frame;

@end
