//
//  RH_BettingStaticHeaderCell.m
//  cpLottery
//
//  Created by Lewis on 2017/11/8.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BettingStaticHeaderCell.h"
#import "coreLib.h"
@interface RH_BettingStaticHeaderCell()
@property (weak, nonatomic) IBOutlet UILabel *labTitle     ;
@property (weak, nonatomic) IBOutlet UILabel *labDesc      ;

@end


@implementation RH_BettingStaticHeaderCell
-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.backgroundColor = colorWithRGB(225, 226, 227)  ;
    self.labTitle.textColor = colorWithRGB(49, 50, 51)  ;
    self.labDesc.textColor = colorWithRGB(79, 124, 184) ;
    self.labTitle.font = [UIFont systemFontOfSize:17.0f] ;
    self.labDesc.font = [UIFont systemFontOfSize:13.0f] ;
}

#pragma mark-
-(void)updateCellWithTitle:(NSString*)title Description:(NSString*)desc
{
    self.labTitle.text = title  ;
    self.labDesc.text = desc ;
}
@end
