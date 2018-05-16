//
//  RH_PromoContentPageCell.h
//  TaskTracking
//
//  Created by jinguihua on 2017/6/9.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_PageLoadContentPageCell.h"
#import "RH_DiscountActivityTypeModel.h"
#import "RH_DiscountActivityModel.h"

@class RH_PromoContentPageCell ;
@protocol PromoContentPageCellDelegate
-(void)promoContentPageCellDidTouchCell:(RH_PromoContentPageCell*)promoContentPageCell CellModel:(RH_DiscountActivityModel *)discountActivityModel ;
@end

@interface RH_PromoContentPageCell : RH_PageLoadContentPageCell
@property(nonatomic,weak) id<PromoContentPageCellDelegate> delegate ;
-(void)updateViewWithType:(RH_DiscountActivityTypeModel*)typeModel  Context:(CLPageLoadDatasContext*)context ;
@end
