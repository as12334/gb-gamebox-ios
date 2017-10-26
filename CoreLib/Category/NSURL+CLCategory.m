//
//  NSURL+CLCategory.m
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "NSURL+CLCategory.h"

@implementation NSURL (CLCategory)
- (NSDictionary *)queryInfos
{
    NSArray * params = [[self query] componentsSeparatedByString:@"&"];
    NSMutableDictionary * queryInfos = [NSMutableDictionary dictionaryWithCapacity:params.count];

    for (NSString * param in params) {
        NSArray * components = [param componentsSeparatedByString:@"="];
        if (components.count == 2) {
            [queryInfos setObject:components[1] forKey:components[0]];
        }
    }

    return queryInfos;
}

@end
