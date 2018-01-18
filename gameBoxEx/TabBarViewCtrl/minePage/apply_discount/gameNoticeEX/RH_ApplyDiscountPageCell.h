//
//  RH_ApplyDiscountPageCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PageLoadContentPageCell.h"
#import "RH_DiscountActivityTypeModel.h"
@interface RH_ApplyDiscountPageCell : RH_PageLoadContentPageCell
-(void)updateViewWithContext:(CLPageLoadDatasContext*)context ;
-(void)updateViewWithType:(RH_DiscountActivityTypeModel*)typeModel  Context:(CLPageLoadDatasContext*)context ;
@end
