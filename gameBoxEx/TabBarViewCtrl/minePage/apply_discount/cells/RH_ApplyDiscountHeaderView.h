//
//  RH_ApplyDiscountHeaderView.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_DiscountActivityTypeModel.h"
@class RH_ApplyDiscountHeaderView ;
@protocol discountTypeHeaderViewDelegate<NSObject>
@optional
-(void)DiscountTypeHeaderViewDidChangedSelectedIndex:(RH_ApplyDiscountHeaderView*)discountTypeHeaderView SelectedIndex:(NSInteger)selectedIndex ;
-(void)TouchSegmentedControlAndRemoveSuperView:(RH_ApplyDiscountHeaderView *)discountTypeHeaderView;
@end
@interface RH_ApplyDiscountHeaderView : UIView
@property (nonatomic,weak) id<discountTypeHeaderViewDelegate> delegate ;

@property (nonatomic,assign,readonly) NSInteger allTypes ;
@property (nonatomic,assign) NSInteger selectedIndex ;
@property (nonatomic,assign,readonly) CGFloat viewHeight ;
@property (strong, nonatomic)UISegmentedControl *segmentedControl;
-(void)updateView:(NSArray*)typeList ;
-(RH_DiscountActivityTypeModel*)typeModelWithIndex:(NSInteger)index ;
@end
