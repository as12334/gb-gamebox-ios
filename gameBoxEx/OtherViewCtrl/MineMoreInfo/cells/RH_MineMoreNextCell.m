//
//  RH_MineMoreNextCell.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_MineMoreNextCell.h"
#import "coreLib.h"
@interface RH_MineMoreNextCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
@implementation RH_MineMoreNextCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return 40;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLab.textColor = colorWithRGB(51, 51, 51) ;
    self.titleLab.font = [UIFont systemFontOfSize:13.0f] ;
    
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine ;
    self.separatorLineColor = RH_Line_DefaultColor ;
    self.selectionOption = CLSelectionOptionHighlighted ;
    self.selectionColor = RH_Cell_DefaultHolderColor ;
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.titleLab.text = info.myTitle ;
}

@end
