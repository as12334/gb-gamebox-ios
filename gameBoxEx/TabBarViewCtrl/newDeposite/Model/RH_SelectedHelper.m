//
//  RH_SelectedHelper.m
//  gameBoxEx
//
//  Created by jun on 2018/9/28.
//  Copyright © 2018 luis. All rights reserved.
//

#import "RH_SelectedHelper.h"
static RH_SelectedHelper *_helper;
@implementation RH_SelectedHelper
+(instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_helper) {
            _helper = [[self alloc]init];
        }
    });
    return _helper;
}
@end
