//
//  CLPushPopAnimatedTransitioning.h
//  CoreLib
//
//  Created by jinguihua on 2016/12/2.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLBasicViewControllerAnimatedTransitioning.h"

//----------------------------------------------------------

#define PushPopAnimatedTypeLeft     0x0001
#define PushPopAnimatedTypeRight    0x0010
#define PushPopAnimatedTypePush     0x0100
#define PushPopAnimatedTypePop      0x1000

typedef NS_ENUM(NSUInteger, PushPopAnimatedType) {
    PushPopAnimatedTypeLeftPush  = PushPopAnimatedTypeLeft  | PushPopAnimatedTypePush,
    PushPopAnimatedTypeLeftPop   = PushPopAnimatedTypeLeft  | PushPopAnimatedTypePop,
    PushPopAnimatedTypeRightPush = PushPopAnimatedTypeRight | PushPopAnimatedTypePush,
    PushPopAnimatedTypeRightPop  = PushPopAnimatedTypeRight | PushPopAnimatedTypePop,

    PushPopAnimatedTypeNavigationPop  = PushPopAnimatedTypeRightPop,
    PushPopAnimatedTypeNavigationPush = PushPopAnimatedTypeLeftPush
};

//----------------------------------------------------------


@interface CLPushPopAnimatedTransitioning : CLBasicViewControllerAnimatedTransitioning

- (id)initWithType:(PushPopAnimatedType)type;
- (id)initWithType:(PushPopAnimatedType)type animations:(void(^)(void))animations;

//类型
@property(nonatomic,readonly) PushPopAnimatedType type;


@end
