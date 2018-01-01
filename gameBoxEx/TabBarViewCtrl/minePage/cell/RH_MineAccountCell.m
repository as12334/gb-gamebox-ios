//
//  RH_MineAccountCell.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_MineAccountCell.h"
#import "CLSelectionControl.h"
@interface RH_MineAccountCell()
@property (weak, nonatomic) IBOutlet CLSelectionControl *rechargeControl;
@property (weak, nonatomic) IBOutlet CLSelectionControl *withDrawControl;

@end
@implementation RH_MineAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.rechargeControl.selectionOption = CLSelectionOptionHighlighted ;
    self.rechargeControl.selectionColor = [UIColor lightGrayColor] ;
    self.rechargeControl.selectionColorAlpha = 0.3f ;
    self.withDrawControl.selectionOption = CLSelectionOptionHighlighted ;
    self.withDrawControl.selectionColor = [UIColor lightGrayColor] ;
    self.withDrawControl.selectionColorAlpha = 0.3f ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
