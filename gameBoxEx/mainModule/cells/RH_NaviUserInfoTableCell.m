//
//  RH_NaviUserInfoTableCell.m
//  gameBoxEx
//
//  Created by luis on 2017/12/24.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_NaviUserInfoTableCell.h"
#import "coreLib.h"

@interface RH_NaviUserInfoTableCell ()
@property (nonatomic,strong) IBOutlet UILabel *labTitle     ;
@property (nonatomic,strong) IBOutlet UILabel *labDesc      ;
@end

@implementation RH_NaviUserInfoTableCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return 40.0f ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor] ;
    self.labTitle.textColor = colorWithRGB(51, 51, 51) ;
    self.labTitle.font = [UIFont systemFontOfSize:12.0f] ;

    self.labDesc.textColor = colorWithRGB(51, 51, 51)  ;
    self.labDesc.font = [UIFont systemFontOfSize:12.0f] ;
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine ;
    self.separatorLineColor = RH_Line_DefaultColor ;
    self.separatorLineWidth = 1.0f ;
    
    //test
    self.labTitle.text = @"总资产" ;
    self.labDesc.text = @"30000.00" ;
}

@end
