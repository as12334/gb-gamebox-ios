//
//  CheckTimeManager.h
//  gameBoxEx
//
//  Created by jun on 2018/8/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckTimeManager : NSObject
@property(nonatomic,copy)NSString *times;
+(instancetype)shared;
@end
