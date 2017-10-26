//
//  CLUserGuideView.h
//  TaskTracking
//
//  Created by apple pro on 2017/4/16.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLCellContext.h"
//----------------------------------------------------------

typedef NS_ENUM(NSInteger, CLUserGuideViewStatus) {
    CLUserGuideViewStatusNone,
    CLUserGuideViewStatusShowing,   //正在显示
    CLUserGuideViewStatusShowed,    //已经显示
    CLUserGuideViewStatusHiding,    //正在隐藏
    CLUserGuideViewStatusHidden     //隐藏
};

typedef NS_ENUM(NSInteger, CLUserGuideViewShowDirection) {
    CLUserGuideViewShowDirectionNext,  //下一个方向
    CLUserGuideViewShowDirectionPrev   //上一个方向
};


//----------------------------------------------------------

@class CLUserGuideView;

//----------------------------------------------------------

@protocol CLUserGuideViewDelegate <NSObject>

@optional

- (void)userGuideViewWantToCompletedGuide:(CLUserGuideView *)userGuideView;

@end

//----------------------------------------------------------

@interface CLUserGuideView: UIView


//开始显示或隐藏
- (void)startShow:(BOOL)show bounces:(BOOL)bounces direction:(CLUserGuideViewShowDirection)direction;
- (void)updateShow:(BOOL)show  withProgress:(CGFloat)progress;
- (void)completedShow:(BOOL)show;
- (void)cancledShow:(BOOL)show;

//动画
- (NSTimeInterval)animationDurationForShow:(BOOL)show
                                   bounces:(BOOL)bounces
                                 direction:(CLUserGuideViewShowDirection)direction;
- (void)animationForShow:(BOOL)show
                 bounces:(BOOL)bounces
                duration:(NSTimeInterval)duration
               direction:(CLUserGuideViewShowDirection)direction;

//子类覆盖
- (void)didStartShow:(BOOL)show
         withBounces:(BOOL)bounces
        andDirection:(CLUserGuideViewShowDirection)direction;

- (void)didCompletedShow:(BOOL)show
           withDirection:(CLUserGuideViewShowDirection)direction;

- (void)didCancledShow:(BOOL)show
           withBounces:(BOOL)bounces
          andDirection:(CLUserGuideViewShowDirection)direction;


@property(nonatomic,readonly) CLUserGuideViewStatus status;
@property(nonatomic,weak) id<CLUserGuideViewDelegate> delegate;

- (void)updateViewWithPageInfo:(NSDictionary *)pageInfo context:(CLCellContext *)context;
- (void)tryCompletedGuide;

@end
