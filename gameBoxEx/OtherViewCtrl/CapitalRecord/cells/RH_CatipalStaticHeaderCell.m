//
//  RH_CatipalStaticHeaderCell.m
//  gameBoxEx
//
//  Created by Richard on 04/01/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_CatipalStaticHeaderCell.h"
#import "coreLib.h"

@interface RH_CatipalStaticHeaderCell()

/**
 取款处理中
 */
@property (weak, nonatomic) IBOutlet UILabel *withdrawalMoney;

/**
 转账处理中
 */


@property (weak, nonatomic) IBOutlet UILabel *transferMoney;

@end

@implementation RH_CatipalStaticHeaderCell


-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.backgroundColor = [UIColor clearColor] ;
    self.withdrawalMoney.textColor = colorWithRGB(51, 51, 51)  ;
    self.transferMoney.textColor = colorWithRGB(51, 51, 51) ;
    self.withdrawalMoney.font = [UIFont systemFontOfSize:12.0f] ;
    self.transferMoney.font = [UIFont systemFontOfSize:12.0f] ;
}

#pragma mark-
-(void)updateCellWithTitle:(NSString*)title Description:(NSString*)desc
{
    self.withdrawalMoney.text = title  ;
    self.transferMoney.text = desc ;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
