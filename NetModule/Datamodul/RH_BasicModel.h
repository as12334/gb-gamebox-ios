//
//  RH_BasicModel.h
//  TaskTracking
//
//  Created by jinguihua on 2017/2/22.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RH_BasicModel : NSObject<NSCoding>
+ (NSMutableArray *)dataArrayWithPlistFileName:(NSString *)fileName;
+ (NSMutableArray *)dataArrayWithInfoArray:(NSArray *)infoArray;

- (id)initWithInfoDic:(NSDictionary *)info;
- (NSInteger)ID;

-(BOOL)isEqual:(id)object ;
@end
