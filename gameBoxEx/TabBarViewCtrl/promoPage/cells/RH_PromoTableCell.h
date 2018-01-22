//
//  RH_PromoTableCell.h
//  gameBoxEx
//
//  Created by luis on 2018/1/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coreLib.h"
#import "RH_DiscountActivityModel.h"

@class RH_PromoTableCell ;
@protocol PromoTableCellDelegate
-(void)promoTableCellImageSizeChangedNotification:(RH_PromoTableCell*)promoTableViewCell  ;
@end

@interface RH_PromoTableCell : CLTableViewCell
@property (nonatomic,weak) id<PromoTableCellDelegate> delegate ;

@end
