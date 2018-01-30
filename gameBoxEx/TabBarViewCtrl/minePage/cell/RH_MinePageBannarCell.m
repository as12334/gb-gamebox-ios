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
@property (strong, nonatomic,readonly)  UIImageView *imageUserAvator;

@property (strong, nonatomic) IBOutlet UILabel *label_UserNickName;
@property (strong, nonatomic) IBOutlet UILabel *label_TimeTitle;
@property (strong, nonatomic) IBOutlet UILabel *label_TimeLast;
@property (strong, nonatomic) IBOutlet UILabel *label_TotalMoney;
@property (strong, nonatomic) IBOutlet UILabel *label_leftMoney;
@property (strong, nonatomic) IBOutlet UILabel *label_TotalMoneyText;
@property (strong, nonatomic) IBOutlet UILabel *label_LeftMoneyText;


@end


@implementation RH_MinePageBannarCell
@synthesize imageUserAvator = _imageUserAvator ;

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
    
    UIView *view_imageB = [UIView new];
    [self.contentView insertSubview:view_imageB atIndex:1];
    view_imageB.whc_LeftSpace(10).whc_CenterY(0).whc_Width(68).whc_Height(68);
    view_imageB.layer.cornerRadius = 34;
    view_imageB.clipsToBounds = YES;
    view_imageB.backgroundColor = ColorWithRGBA(255, 255, 255, 0.5);
    self.imageUserAvator.backgroundColor = [UIColor redColor];
    self.imageUserAvator.image = ImageWithName(@"touxiang");
    [view_imageB addSubview:self.imageUserAvator];
//    self.imageUserAvator.whc_Center(0, 0).whc_Width(50).whc_Height(50);
    
    [self.label_UserNickName setTextColor:colorWithRGB(51, 51, 51)];
    [self.label_TimeTitle setTextColor:colorWithRGB(102, 102, 102)];
    [self.label_TimeLast setTextColor:colorWithRGB(102, 102, 102)];
    [self.label_TotalMoneyText setTextColor:colorWithRGB(51, 51, 51)];
    [self.label_TotalMoney setTextColor:colorWithRGB(27, 117, 217)];
    [self.label_leftMoney setTextColor:colorWithRGB(11, 186, 135)];
    [self.label_LeftMoneyText setTextColor:colorWithRGB(51, 51, 51)];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:RHNT_UserInfoManagerMineGroupChangedNotification
                                               object:nil] ;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    [self updateCell] ;
    
}


#pragma mark-
-(UIImageView *)imageUserAvator
{
    if (!_imageUserAvator){
        _imageUserAvator = [[UIImageView alloc] initWithImage:ImageWithName(@"touxiang")] ;
    }
    
    return _imageUserAvator ;
}

#pragma mark-
-(void)handleNotification:(NSNotification*)nf
{
    if ([nf.name isEqualToString:RHNT_UserInfoManagerMineGroupChangedNotification]){
        [self setNeedUpdateCell] ;
    }
}

-(void)updateCell
{
    self.label_UserNickName.text = MineSettingInfo.mUserName ;
    self.label_TotalMoney.text = [NSString stringWithFormat:@"¥ %.2f",MineSettingInfo.mTotalAssets];
    self.label_leftMoney.text = [NSString stringWithFormat:@"¥ %.2f",MineSettingInfo.mWalletBalance];
    self.label_TimeLast.text = MineSettingInfo.mLoginTime ;
    [self.imageUserAvator sd_setImageWithURL:[NSURL URLWithString:MineSettingInfo.showAvatalURL]
                            placeholderImage:ImageWithName(@"mine_page_useravator")] ;
}

@end
