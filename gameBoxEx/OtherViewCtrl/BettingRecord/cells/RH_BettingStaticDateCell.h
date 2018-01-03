//
//  RH_BettingStaticDateCell.h
//  cpLottery
//
//  Created by Lewis on 2017/11/8.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "CLStaticCollectionViewCell.h"

@interface RH_BettingStaticDateCell : CLStaticCollectionViewCell
@property (weak, nonatomic,readonly) UILabel *dateYear;
@property (weak, nonatomic,readonly) UILabel *dateMMDD;
@property (weak, nonatomic,readonly) UILabel *dateInfo;
@end
