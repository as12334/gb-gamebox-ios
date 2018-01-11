//
//  RH_PreferentialListCell.h
//  gameBoxEx
//
//  Created by Lenny on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"

typedef enum : NSUInteger {
    PreferentialListCellBackTypeNotGrant,
    PreferentialListCellBackTypeDidGrant,
    PreferentialListCellBackTypePermitting,
} PreferentialListCellBackType;


@interface RH_PreferentialListCell : CLTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label_Title;

@property (weak, nonatomic) IBOutlet UILabel *label_Bottom;

@property (weak, nonatomic) IBOutlet UILabel *label_Time;

@property (weak, nonatomic) IBOutlet UIImageView *image_Right;

@property (weak, nonatomic) IBOutlet UILabel *label_RightMoney;

@property (weak, nonatomic) IBOutlet UILabel *label_Grant;

- (void)setCellGranted:(PreferentialListCellBackType )grant;

@end
