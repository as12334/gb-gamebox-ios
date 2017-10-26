//
//  NSObject+IntervalAnimation.h
//  CoreLib
//
//  Created by apple pro on 2016/11/22.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "help.h"

@interface NSObject(IntervalAnimation)
//开始动作
- (void)startCommitIntervalAnimatedWithDirection:(CLMoveAnimtedDirection)moveAnimtedDirection
                                        duration:(NSTimeInterval)duration
                                           delay:(NSTimeInterval)delay
                                         forShow:(BOOL)show
                                         context:(id)context
                                  completedBlock:(void(^)(BOOL finished))completedBlock;

//动作循环
- (void)commitIntervalAnimatedWithDirection:(CLMoveAnimtedDirection)moveAnimtedDirection
                              containerSize:(CGSize)containerSize
                                   duration:(NSTimeInterval)duration
                                      delay:(NSTimeInterval)delay
                                    forShow:(BOOL)show
                                    context:(id)context
                             completedBlock:(void(^)(BOOL finished))completedBlock;
//动画
- (void)animationWithDirection:(CLMoveAnimtedDirection)moveAnimtedDirection
                 containerSize:(CGSize)containerSize
                      duration:(NSTimeInterval)duration
                         delay:(NSTimeInterval)delay
                       forShow:(BOOL)show
                       context:(id)context
                completedBlock:(void(^)(BOOL finished))completedBlock;

- (NSArray *)needAnimatedObjectsWithDirection:(CLMoveAnimtedDirection)moveAnimtedDirection
                                      forShow:(BOOL)show
                                      context:(id)context;

//组之间的间隔,默认返回0.2f
- (NSTimeInterval)animationIntervalForDuration:(NSTimeInterval)duration forShow:(BOOL)show;
//组内的间隔
- (NSTimeInterval)animationIntervalForGroupWithDuration:(NSTimeInterval)duration  forShow:(BOOL)show;

- (CGFloat)animationDampingRatioForDuration:(NSTimeInterval)duration;
- (CGFloat)initialSpringVelocityForDuration:(NSTimeInterval)duration;

@end
