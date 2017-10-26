//
//  CLCellContext.h
//  TaskTracking
//
//  Created by apple pro on 2017/2/26.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CLCellContext : NSObject
- (id)initWithIndexPath:(NSIndexPath *)indexPath;
- (id)initWithIndexPath:(NSIndexPath *)indexPath context:(id)context;

//section等于最大section索引，item/row等于当前section最大
- (id)initWithIndexPath:(NSIndexPath *)indexPath totalInfoIndexPath:(NSIndexPath *)totalInfoIndexPath context:(id)context;
- (id)initWithIndexPath:(NSIndexPath *)indexPath totalInfoIndexPath:(NSIndexPath *)totalInfoIndexPath context:(id)context otherInfo:(NSDictionary *)otherInfo;


@property(nonatomic,strong,readonly) NSIndexPath * indexPath;
@property(nonatomic,strong,readonly) NSIndexPath * totalInfoIndexPath;
@property(nonatomic,strong,readonly) id context;
@property(nonatomic,strong,readonly) NSDictionary * otherInfo;

@end
