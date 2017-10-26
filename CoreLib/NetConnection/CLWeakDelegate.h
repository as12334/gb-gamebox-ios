//
//  CLWeakDelegate.h
//  CoreLib
//
//  Created by apple pro on 2016/11/18.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLWeakDelegate<__covariant ObjectType> : NSObject
@property(nonatomic,weak,readonly) ObjectType delegate ;
@property(nonatomic,strong,readonly) id<NSCopying> delegateKey ;

-(id)initWithDelegate:(ObjectType)delegate ;
////生成delegate的key
+(id<NSCopying>)keyForDelegate:(ObjectType)delegate ;
@end
