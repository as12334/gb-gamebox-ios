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
@property (weak, nonatomic) IBOutlet UIButton *loginAndRegiest;
@property (weak, nonatomic) IBOutlet UIView *headIconBgView;

@property (weak, nonatomic) IBOutlet UIImageView *headIconImageView;

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
    self.headIconBgView.userInteractionEnabled = YES;
    self.headIconImageView.userInteractionEnabled = YES;
    self.headIconBgView.whc_LeftSpace(10).whc_CenterY(0).whc_Width(68).whc_Height(68);
    self.headIconBgView.layer.cornerRadius = 34;
    self.headIconBgView.clipsToBounds = YES;
    self.headIconBgView.backgroundColor = ColorWithRGBA(255, 255, 255, 0.5);
    self.headIconImageView.image = ImageWithName(@"touxiang");
    self.headIconImageView.whc_Center(0, 0).whc_Width(54).whc_Height(54);
    self.headIconImageView.layer.cornerRadius = 25.0f ;
    self.headIconImageView.layer.masksToBounds = YES ;
    
    self.loginAndRegiest.whc_CenterY(0).whc_LeftSpaceToView(15, self.headIconBgView).whc_WidthAuto().whc_HeightAuto();
    
    UITapGestureRecognizer *panGuset = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageViewClick)];
    [self.headIconImageView addGestureRecognizer:panGuset];
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
