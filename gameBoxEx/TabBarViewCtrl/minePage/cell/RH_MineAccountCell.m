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
#import "RH_UserInfoManager.h"
#import "RH_APPDelegate.h"
#import "RH_CustomViewController.h"

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
    
    UIView *centerLine = [UIView new];
    [self.contentView addSubview:centerLine];
    centerLine.whc_Center(0, 0).whc_Width(1).whc_Height(25);
    centerLine.backgroundColor = colorWithRGB(242, 242, 242);

    
}

- (void)updateCellWithInfo:(NSDictionary *)info context:(id)context {
    NSLog(@"info:%@",info);
    NSArray *rowsinfo = info[@"rowsInfo"];
    self.image_Withdraw.image = ImageWithName(rowsinfo[0][@"image"]);
    self.image_Topup.image = ImageWithName(rowsinfo[1][@"image"]);
}


-(IBAction)btn_recharge:(id)sender //充值
{
    ifRespondsSelector(self.delegate, @selector(mineAccountCellTouchRchargeButton:)){
        [self.delegate mineAccountCellTouchRchargeButton:self] ;
    }
}

-(IBAction)btn_withDraw:(id)sender ////提现
{
    ifRespondsSelector(self.delegate, @selector(mineAccountCellTouchWithDrawButton:)){
        [self.delegate mineAccountCellTouchWithDrawButton:self] ;
    }
}


@end
