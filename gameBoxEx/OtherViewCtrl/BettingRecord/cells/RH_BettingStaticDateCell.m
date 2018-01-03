//
//  RH_BettingStaticDateCell.m
//  cpLottery
//
//  Created by Lewis on 2017/11/8.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BettingStaticDateCell.h"
#import "coreLib.h"
@interface RH_BettingStaticDateCell()
@property (weak, nonatomic) IBOutlet UIView *borderView   ;
@property (weak, nonatomic) IBOutlet UILabel *labDate           ;

@end


@implementation RH_BettingStaticDateCell
-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.backgroundColor = [UIColor clearColor] ;
    self.borderView.backgroundColor = [UIColor clearColor] ;
    self.borderView.layer.cornerRadius = 3.0f ;
    self.borderView.layer.borderColor = RH_Line_DefaultColor.CGColor ;
    self.borderView.layer.borderWidth = 1.0f  ;
    self.borderView.layer.masksToBounds = YES ;
    
    self.labDate.textColor = colorWithRGB(51, 51, 51) ;
    self.labDate.font = [UIFont systemFontOfSize:14.0f] ;
    
    
    self.selectionOption = CLSelectionOptionHighlighted ;
    self.selectionColor = RH_Cell_DefaultHolderColor ;
    self.selectionColorAlpha = 0.7f ;
    
    self.labDate.text = dateStringWithFormatter([NSDate date], @"yyyy-MM-dd") ;
}

-(UIView *)showSelectionView{
    return self.borderView ;
}

#pragma mark-

@end
