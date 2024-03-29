//
//  CLScrollTriggerView.h
//  CoreLib
//
//  Created by jinguihua on 2017/1/19.
//  Copyright © 2017年 GIGA. All rights reserved.
//

#import <UIKit/UIKit.h>

//----------------------------------------------------------

//滑动触发视图的定位
typedef NS_ENUM(NSInteger, CLScrollTriggerViewLocation) {
    CLScrollTriggerViewLocationTop,
    CLScrollTriggerViewLocationBottom,
    CLScrollTriggerViewLocationLeft,
    CLScrollTriggerViewLocationRight
};

//滑动触发视图状态变
typedef NS_ENUM(NSInteger, CLScrollTriggerViewStatus) {
    CLScrollTriggerViewStatusNormal,            //正常状态
    CLScrollTriggerViewStatusBeginReadyTrigger, //开始准备触发（即开始显示）
    CLScrollTriggerViewStatusReadyToTrigger,    //准备触发（滑动到触发的临界点）
    CLScrollTriggerViewStatusTriggering,        //正在触发
};


//触发的模式
typedef NS_OPTIONS(NSUInteger, CLScrollTriggerViewTriggerMode) {
    CLScrollTriggerViewTriggerModeNormal       = 0 ,      //正常模式
    CLScrollTriggerViewTriggerModeMomentary    = 1 ,      //是否是短暂，即不会悬停
};

//----------------------------------------------------------


@interface CLScrollTriggerView : UIControl
- (id)initWithLocation:(CLScrollTriggerViewLocation)location;
- (id)initWithLocation:(CLScrollTriggerViewLocation)location minTriggerDistance:(CGFloat)minTriggerDistance;

//位置,默认为CLScrollTriggerViewLocationTop
@property(nonatomic,readonly) CLScrollTriggerViewLocation location;

//最小的触发距离，默认为50.f
@property(nonatomic,readonly) CGFloat minTriggerDistance;
//最小触发距离的偏移，更改会导致会导致触发状态结束，默认为0.f
@property(nonatomic) CGFloat minTriggerDistanceOffset;
//定位的偏移，更改会导致会导致触发状态结束，默认为CGPointZero
@property(nonatomic) CGPoint locationOffset;

//动画时长
@property(nonatomic) NSTimeInterval animationrDuration;
//视图透明度是否随着滑动改变
@property(nonatomic) BOOL alphaChangeWithScroll;


////是否是短暂的，更改会导致会导致触发状态结束,如果设置为YES，则触发后不会悬停，默认为NO
//@property(nonatomic,getter=isMomentary) BOOL momentary;
//触发的模式，默认为正常模式，即需要松手且悬停
@property(nonatomic) CLScrollTriggerViewTriggerMode mode;



//开始触发，对于momentary为YES的无任何效果,scrollToShow指示是否滑动到显示，默认为YES
- (void)beginTrigger;
- (void)beginTrigger_e:(BOOL)scrollToShow;

//结束触发
- (void)endTrigger;

// 滑动触发视图的状态
@property(nonatomic,readonly) CLScrollTriggerViewStatus status;
//状态改变（可重载进行自定义显示，需调用父类方法）
- (void)statusDidChangeFromStatus:(CLScrollTriggerViewStatus)fromStatus;


//当前回合的滑动无效（当改变某些变量只会导致滑动过程改变则需要调用改方法使当前滑动回合失效），会导致触发状态结束
- (void)invalidate;
//当前回合是否失效
@property(nonatomic,readonly,getter=isInvalidated) BOOL invalidate;


//下面几个方法不要直接调用，请在子类重载各方法以自定义更新视图，需调用父类方法

//重置更新视图，进行视图初始化状态更新
- (void)updateViewForReset;

//触发的进度
- (void)updateViewForTriggerProgress:(float)progress;

////开始准备刷新，CLScrollTriggerViewTriggerModeImmediately模式下不会触发
//- (void)updateViewForReadyToTrigger:(BOOL)ready;


//- (void)updateViewForBeginTrigger:(BOOL)animated;
//- (void)animationForBeginTrigger;

//- (void)updateViewForBeginEndTrigger:(BOOL)animated;
//- (void)animationForEndTrigger;
//- (void)updateViewForEndTrigger;


//返回依附的滑动视图
- (UIScrollView *)scrollView;
@end
