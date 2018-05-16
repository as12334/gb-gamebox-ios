//
//  RH_CapitalRecordBottomView.h
//  gameBoxEx
//
//  Created by Richard on 04/01/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RH_CapitalRecordBottomView : UIView
-(void)updateUIInfoWithRechargeSum:(CGFloat)rechargeSum
                       WithDrawSum:(CGFloat)withDrawSum
                      FavorableSum:(CGFloat)favorableSum
                          Rakeback:(CGFloat)rakeBackSum ;
@end
