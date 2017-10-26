//
//  CLTabChangeTransitioning.h
//  CoreLib
//
//  Created by jinguihua on 2016/11/29.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "CLBasicViewControllerAnimatedTransitioning.h"
#import "help.h"

//----------------------------------------------------------

typedef NS_ENUM(int, CLTabChangeTransitioningType) {
    CLTabChangeTransitioningTypeRotation,
    CLTabChangeTransitioningTypeTranslation
};

//----------------------------------------------------------

@interface CLTabChangeTransitioning : CLBasicViewControllerAnimatedTransitioning
- (id)initWithTabChangeDirection:(CLTabChangeDirection)direction;

- (id)initWithTabChangeDirection:(CLTabChangeDirection)direction
                            type:(CLTabChangeTransitioningType)type
                       animation:(void(^)())animation;
@end
