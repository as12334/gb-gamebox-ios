//
//  NSURL+CLCategory.h
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (CLCategory)
//返回查询信息的字典 k1=v1&k2=v2
@property(nonatomic,strong,readonly) NSDictionary * queryInfos;
@end
