//
//  RH_ActivityDateSingle.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RH_ActivityDateSingle : NSObject
+(instancetype) shareInstance ;
@property(nonatomic,copy)NSDate *singleDte;
@end
