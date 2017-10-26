//
//  CLPresentAnimatedTransitioning.h
//  CoreLib
//
//  Created by jinguihua on 2016/12/2.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLBasicViewControllerAnimatedTransitioning.h"

//----------------------------------------------------------

typedef NS_ENUM(NSInteger, PresentAnimatedTransitioningType) {
    PresentAnimatedTransitioningTypePresent,
    PresentAnimatedTransitioningTypeDismiss
};

//----------------------------------------------------------

@interface CLPresentAnimatedTransitioning : CLBasicViewControllerAnimatedTransitioning
- (id)initWithType:(PresentAnimatedTransitioningType)type;
- (id)initWithType:(PresentAnimatedTransitioningType)type animations:(void(^)(void))animations;

//类型
@property(nonatomic,readonly) PresentAnimatedTransitioningType type;

@end
