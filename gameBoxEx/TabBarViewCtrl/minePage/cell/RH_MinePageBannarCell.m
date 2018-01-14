//
//  RH_MinePageBannarCell.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_MinePageBannarCell.h"
#import "coreLib.h"
#import "RH_UserInfoManager.h"

@interface RH_MinePageBannarCell()
@property (nonatomic,strong) IBOutlet UIImageView *imgICON ;

//login status info
@property (strong, nonatomic) IBOutlet UIImageView *imageUserAvator;

@property (strong, nonatomic) IBOutlet UILabel *label_UserNickName;
@property (strong, nonatomic) IBOutlet UILabel *label_TimeTitle;
@property (strong, nonatomic) IBOutlet UILabel *label_TimeLast;
@property (strong, nonatomic) IBOutlet UILabel *label_TotalMoney;
@property (strong, nonatomic) IBOutlet UILabel *label_leftMoney;
@property (strong, nonatomic) IBOutlet UILabel *label_TotalMoneyText;
@property (strong, nonatomic) IBOutlet UILabel *label_LeftMoneyText;


@end


@implementation RH_MinePageBannarCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    
    return 124;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIImageView *imageBackView = [[UIImageView alloc] init];
    imageBackView.frame = CGRectMake(0, 0, screenSize().width, [RH_MinePageBannarCell heightForCellWithInfo:nil tableView:nil context:nil]);
    [self.contentView insertSubview:imageBackView atIndex:0];
    imageBackView.image = ImageWithName(@"mine_page_accountback");
    
    [self.imageUserAvator setImage:ImageWithName(@"mine_page_useravator")];
    [self.label_UserNickName setTextColor:colorWithRGB(51, 51, 51)];
    [self.label_TimeTitle setTextColor:colorWithRGB(102, 102, 102)];
    [self.label_TimeLast setTextColor:colorWithRGB(102, 102, 102)];
    [self.label_TotalMoneyText setTextColor:colorWithRGB(51, 51, 51)];
    [self.label_TotalMoney setTextColor:colorWithRGB(27, 117, 217)];
    [self.label_leftMoney setTextColor:colorWithRGB(11, 186, 135)];
    [self.label_LeftMoneyText setTextColor:colorWithRGB(51, 51, 51)];
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.label_UserNickName.text = MineSettingInfo.mUserName ;
    self.label_TotalMoney.text = [NSString stringWithFormat:@"¥ %.2f",MineSettingInfo.mTotalAssets];
    self.label_leftMoney.text = [NSString stringWithFormat:@"¥ %.2f",MineSettingInfo.mWithdrawAmount];
    self.label_TimeLast.text = MineSettingInfo.mLoginTime ;

}

@end
