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
    self.backgroundColor = [UIColor clearColor] ;
    self.labTitle.textColor = colorWithRGB(51, 51, 51)  ;
    self.labDesc.textColor = colorWithRGB(23, 102, 187) ;
    self.labTitle.font = [UIFont systemFontOfSize:14.0f] ;
    self.labDesc.font = [UIFont systemFontOfSize:9.0f] ;
    self.labTitle.whc_CenterY(0);
}

#pragma mark-
-(void)updateCellWithTitle:(NSString*)title Description:(NSString*)desc
{
    self.labTitle.text = title  ;
    self.labDesc.text = desc ;
    
}
@end
