//
//  CheckTimeManager.m
//  gameBoxEx
//
//  Created by jun on 2018/8/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CheckTimeManager.h"
static CheckTimeManager *_manager;
@implementation CheckTimeManager
+(instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_manager) {
            _manager = [[self alloc]init];
        }
    });
    return _manager;
}

@end
