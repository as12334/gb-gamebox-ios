//
//  RH_PromoTypeHeaderView.h
//  lotteryBox
//
//  Created by luis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_DiscountActivityTypeModel.h"

@class RH_PromoTypeHeaderView ;
@protocol PromoTypeHeaderViewDelegate
@optional
-(void)promoTypeHeaderViewDidChangedSelectedIndex:(RH_PromoTypeHeaderView*)promoTypeHeaderView SelectedIndex:(NSInteger)selectedIndex ;
@end

@interface RH_PromoTypeHeaderView : UIView
@property (nonatomic,weak) id<PromoTypeHeaderViewDelegate> delegate ;

@property (nonatomic,assign,readonly) NSInteger allTypes ;
@property (nonatomic,assign) NSInteger selectedIndex ;
@property (nonatomic,assign,readonly) CGFloat viewHeight ;

-(void)updateView:(NSArray*)typeList ;
-(RH_DiscountActivityTypeModel*)typeModelWithIndex:(NSInteger)index ;

@end
