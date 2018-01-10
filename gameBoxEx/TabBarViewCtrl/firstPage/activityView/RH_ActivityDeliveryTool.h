//
//  RH_ActivityDeliveryTool.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RH_ActivityDeliveryTool : NSObject
@property(nonatomic,copy)NSString *openActivityStr;
@property(nonatomic,copy)NSString *nextTimeStr;
+(instancetype)deliveryStrTool;
@end
