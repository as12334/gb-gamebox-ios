//
//  CLRefreshControl.h
//  CoreLib
//
//  Created by jinguihua on 2017/1/20.
//  Copyright © 2017年 GIGA. All rights reserved.
//

#import "CLScrollTriggerView.h"

//----------------------------------------------------------

#define CLRefreshControlTriggerDistance 50.f

//----------------------------------------------------------

/**
 * 刷新控件的类型，上刷新控件和下刷新控件
 */
typedef NS_ENUM(int, CLRefreshControlType){
    /* 上刷新控件 */
    CLRefreshControlTypeTop,
    /* 下刷新控件 */
    CLRefreshControlTypeBottom
};


/**
 * 刷新控件的风格
 */
typedef NS_ENUM(int, CLRefreshControlStyle){
    /* 箭头风格 */
    CLRefreshControlStyleArrow,
    /* 进度风格 */
    CLRefreshControlStyleProgress
};




@interface CLRefreshControl : CLScrollTriggerView

/**
 * 默认风格为CLRefreshControlStyleArrow
 */
- (id)initWithType:(CLRefreshControlType)type;
- (id)initWithType:(CLRefreshControlType)type style:(CLRefreshControlStyle)style;

/**
 * 刷新控件的风格
 */
@property(nonatomic,readonly) CLRefreshControlStyle style;

/**
 * 刷新控件的类型
 */
@property(nonatomic,readonly) CLRefreshControlType type;


/**
 * 标签的文本的颜色，默认为黑色
 */
@property(nonatomic,strong) UIColor *textColor;
@property(nonatomic,strong) UIFont  *textFont;

/**
 * 文字
 */
- (void)setText:(NSString *)text forStatus:(CLScrollTriggerViewStatus)status;
- (NSString *)textForStatus:(CLScrollTriggerViewStatus)status;

/**
 *  刷新状态，为YES则在刷新
 */
@property(nonatomic,readonly,getter = isRefreshing) BOOL refreshing;


/**
 * 手动开始刷新
 */
- (void)beginRefreshing;
- (void)beginRefreshing_e:(BOOL)scrollToShow;

/**
 * 手动结束刷新
 */
- (void)endRefreshing;


@end
