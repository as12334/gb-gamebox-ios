//
//  RH_MineUnLoginTableViewCell.m
//  gameBoxEx
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MineUnLoginTableViewCell.h"
#import "coreLib.h"
@implementation RH_MineUnLoginTableViewCell

+ (CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context {
    
    return MainScreenH - StatusBarHeight - NavigationBarHeight - TabBarHeight;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIImageView *imageBackView = [[UIImageView alloc] init];
    imageBackView.frame = CGRectMake(0, 0, screenSize().width, [RH_MineUnLoginTableViewCell heightForCellWithInfo:nil tableView:nil context:nil]);
    [self.contentView insertSubview:imageBackView atIndex:0];
    
}
- (IBAction)buttonDidTaped:(id)sender {
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
