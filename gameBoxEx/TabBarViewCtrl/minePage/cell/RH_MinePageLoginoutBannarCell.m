//
//  RH_MinePageLoginoutBannarCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/21.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MinePageLoginoutBannarCell.h"
#import "coreLib.h"

@interface RH_MinePageLoginoutBannarCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@end


@implementation RH_MinePageLoginoutBannarCell

+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return 124.0f ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *panGuset = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageViewClick)];
    [self.headImageView addGestureRecognizer:panGuset];
}
- (IBAction)loginClick:(id)sender {
    self.block();
}

-(void)headImageViewClick
{
    self.block();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
