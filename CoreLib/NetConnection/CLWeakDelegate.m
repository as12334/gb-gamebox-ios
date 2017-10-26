//
//  CLWeakDelegate.m
//  CoreLib
//
//  Created by apple pro on 2016/11/18.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "CLWeakDelegate.h"
#import "MacroDef.h"

@implementation CLWeakDelegate
-(id)initWithDelegate:(id)delegate
{
    self = [super init] ;
    if (self){
        _delegate = delegate ;
        _delegateKey = [[self class] keyForDelegate:delegate] ;
    }

    return self ;
}

+(id<NSCopying>)keyForDelegate:(id)delegate
{
    return NSNumberWithPointer(delegate) ;
}

//比较的指针是否指向同一个对象
-(BOOL)isEqual:(id)object
{
    BOOL bRet = NO ;
    if ([object isKindOfClass:[self class]]){
        bRet = [(id)self.delegateKey isEqual:(id)[object delegateKey]] ;
    }

    return bRet ;
}

-(NSUInteger)hash
{
    return [(id)self.delegateKey hash] ;
}


@end
