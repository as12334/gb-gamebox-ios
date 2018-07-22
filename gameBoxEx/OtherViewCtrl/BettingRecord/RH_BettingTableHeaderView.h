//
//  RH_BettingTableHeaderView.h
//  lotteryBox
//
//  Created by luis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLBorderView.h"

@interface RH_BettingTableHeaderView : CLBorderView
-(void)updateUIInfoWithTotalNumber:(NSInteger)totalNumber SigleAmount:(CGFloat)single ProfitAmount:(CGFloat)profitAmount ;
@end
