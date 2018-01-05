//
//  RH_BettingSelectedDateView.h
//  cpLottery
//
//  Created by Lewis on 2017/11/8.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "CLStaticCollectionViewCell.h"

@interface RH_BettingSelectedDateView : UIView
-(void)addTarget:(id)object Selector:(SEL)selector  ;
-(void)updateUIWithDate:(NSDate*)date ;
@end
