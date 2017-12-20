//
//  RH_MainMenuCell.m
//  lotteryBox
//
//  Created by luis on 2017/12/10.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_MainMenuCell.h"
#import "coreLib.h"

@interface RH_MainMenuCell ()
@property (nonatomic,strong) IBOutlet UIImageView *imageIcon ;
@property (nonatomic,strong) IBOutlet UILabel *labTitle ;
@end

@implementation RH_MainMenuCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return 44.0f ;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleNone ;
    self.contentView.backgroundColor = [UIColor clearColor] ;
    self.labTitle.textColor = [UIColor whiteColor] ;
    self.labTitle.font = [UIFont systemFontOfSize:14.0f] ;
    
    self.selectionOption = CLSelectionOptionHighlighted ;
    self.selectionColor = colorWithRGB(51, 51, 51) ;
}

#pragma mark -
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.imageIcon.image = info.myImage ;
    self.labTitle.text = info.myTitle ;
}

@end
