//
//  UIView+IntervalAnimation.h
//  CoreLib
//
//  Created by apple pro on 2016/11/22.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "help.h"

@interface UIView (IntervalAnimation)
@property(nonatomic) BOOL onlyAnimatedSelf;

- (NSArray *)needAnimatedViewsForShow:(BOOL)show context:(id)context;
- (NSArray *)needAnimatedViewsWithDirection:(CLMoveAnimtedDirection)moveAnimtedDirection
                                    forShow:(BOOL)show
                                    context:(id)context;

@end
