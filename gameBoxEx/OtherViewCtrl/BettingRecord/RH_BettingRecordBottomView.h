//
//  RH_OrderSortFooterView.h
//  lotteryBox
//
//  Created by luis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RH_BettingRecordBottomView : UIView


/**

 @param totalNumber 笔数
 @param single 投注总额
 @param profitAmount 派彩奖金
 @param effective 有效投注
 */
-(void)updateUIInfoWithTotalNumber:(NSInteger)totalNumber SigleAmount:(CGFloat)single ProfitAmount:(CGFloat)profitAmount effective:(CGFloat)effective;
@end
