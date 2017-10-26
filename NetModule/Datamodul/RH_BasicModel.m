//
//  RH_BasicModel.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/22.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_BasicModel.h"
#import "MacroDef.h"

@implementation RH_BasicModel
+ (NSMutableArray *)dataArrayWithPlistFileName:(NSString *)fileName {
    return [self dataArrayWithInfoArray:[NSArray arrayWithContentsOfFile:PlistResourceFilePath(fileName)]];
}

+ (NSMutableArray *)dataArrayWithInfoArray:(NSArray *)infoArray
{
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:infoArray.count];
    for (NSDictionary *info in infoArray) {

        if ([info isKindOfClass:[NSDictionary class]]) {
            id data = [[self alloc] initWithInfoDic:info];
            if (data) [datas addObject:data];
        }
    }

    return datas;
}

- (id)initWithInfoDic:(NSDictionary *)info {
    return info ? [self init] : nil;
}

- (NSInteger)ID {
    return NSNotFound;
}

- (BOOL)isEqual:(id)object
{
    if(self == object) {
        return YES;
    }else if ([object isMemberOfClass:[self class]]) {
//        return  CLStringIsEqual(self.ID,[(typeof(self))object ID]);
        return (self.ID==[(typeof(self))object ID]) ;
    }

    return NO;
}

#pragma mark -

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self init];
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    //do nothing
}

@end
