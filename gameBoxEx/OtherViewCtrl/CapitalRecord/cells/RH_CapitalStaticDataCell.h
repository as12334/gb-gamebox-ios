//
//  RH_CapitalStaticDataCell.h
//  gameBoxEx
//
//  Created by Richard on 04/01/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLStaticCollectionViewCell.h"

@interface RH_CapitalStaticDataCell : CLStaticCollectionViewCell
@property (weak, nonatomic,readonly) UILabel *dateYear;
@property (weak, nonatomic,readonly) UILabel *dateMMDD;
@property (weak, nonatomic,readonly) UILabel *dateInfo;
@end
