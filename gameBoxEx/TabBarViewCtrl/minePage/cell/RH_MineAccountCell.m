//
//  RH_MineAccountCell.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_MineAccountCell.h"
#import "CLSelectionControl.h"
#import "coreLib.h"
@interface RH_MineAccountCell()
@property (weak, nonatomic) IBOutlet CLSelectionControl *rechargeControl;
@property (weak, nonatomic) IBOutlet CLSelectionControl *withDrawControl;

@property (strong, nonatomic) IBOutlet UIImageView *image_Topup;
@property (strong, nonatomic) IBOutlet UIImageView *image_Withdraw;

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

- (void)updateCellWithInfo:(NSDictionary *)info context:(id)context {
    NSLog(@"info:%@",info);
    NSArray *rowsinfo = info[@"rowsInfo"];
    self.image_Withdraw.image = ImageWithName(rowsinfo[0][@"image"]);
    self.image_Topup.image = ImageWithName(rowsinfo[1][@"image"]);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
