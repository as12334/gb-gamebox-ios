//
//  RH_MineRecordStaticCell.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_MineRecordStaticCell.h"
#import "coreLib.h"
@interface RH_MineRecordStaticCell()
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *explainLab;

@end
@implementation RH_MineRecordStaticCell
-(void)awakeFromNib
{
    [super awakeFromNib] ;
    
    self.selectionOption = CLSelectionOptionHighlighted ;
    self.selectionColor = [UIColor lightGrayColor] ;
    self.selectionColorAlpha = 0.3f ;
    self.titleLab.textColor = colorWithRGB(51, 51, 51);
    self.explainLab.textColor = colorWithRGB(153, 153, 153);
    self.titleLab.font = [UIFont systemFontOfSize:14];
    self.explainLab.font = [UIFont systemFontOfSize:11];
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.cellImageView.image = info.myImage ;
    self.titleLab.text = info.myTitle ;
    self.explainLab.text = info.myDetailTitle;
}
@end
