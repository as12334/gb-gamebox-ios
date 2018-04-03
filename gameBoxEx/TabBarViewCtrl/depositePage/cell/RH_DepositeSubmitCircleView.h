//
//  RH_DepositeSubmitCircleView.h
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_DepositeSubmitCircleView.h"
@class RH_DepositeSubmitCircleView;
@protocol DepositeSubmitCircleViewDelegate<NSObject>
@optional
-(void)depositeSubmitCircleViewTransferMoney:(RH_DepositeSubmitCircleView *)circleView;
-(void)depositeSubmitCircleViewChooseDiscount:(NSInteger)activityId;
@end
@interface RH_DepositeSubmitCircleView : UIView
@property(nonatomic,weak)id<DepositeSubmitCircleViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *moneyNumLabel;
@end
