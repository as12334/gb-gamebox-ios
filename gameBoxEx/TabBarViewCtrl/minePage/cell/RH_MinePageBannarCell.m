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
@property (nonatomic,strong) IBOutlet UIView *imgUserBG ;  // 头像的背景
@property (strong, nonatomic) IBOutlet  UIImageView *imageUserAvator;

@property (strong, nonatomic) IBOutlet UILabel *label_UserNickName; //昵称
@property (strong, nonatomic) IBOutlet UILabel *label_TimeTitle; // 上次登录时间标题
@property (strong, nonatomic) IBOutlet UILabel *label_TimeLast; //上次登录时间显示
@property (strong, nonatomic) IBOutlet UILabel *label_TotalMoney;  // 总资产显示的金额
@property (strong, nonatomic) IBOutlet UILabel *label_leftMoney;  // 钱包显示的金额
@property (strong, nonatomic) IBOutlet UILabel *label_TotalMoneyText; // 总资产
@property (strong, nonatomic) IBOutlet UILabel *label_LeftMoneyText;  // 钱包余额


@end


@implementation RH_MinePageBannarCell
@synthesize imageUserAvator = _imageUserAvator ;

+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    
    return 180;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgUserBG.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"mine_page_accountback"].CGImage);
    return;
    UIImageView *imageBackView = [[UIImageView alloc] init];
    imageBackView.frame = CGRectMake(0, 0, screenSize().width, [RH_MinePageBannarCell heightForCellWithInfo:nil tableView:nil context:nil]);
    [self.contentView insertSubview:imageBackView atIndex:0];
    imageBackView.image = ImageWithName(@"mine_page_accountback");
    
    
    self.imgUserBG.whc_LeftSpace(10).whc_CenterY(0).whc_Width(68).whc_Height(68);
    self.imgUserBG.layer.cornerRadius = 34;
    self.imgUserBG.clipsToBounds = YES;
    self.imgUserBG.backgroundColor = ColorWithRGBA(255, 255, 255, 0.5);
    self.imageUserAvator.image = ImageWithName(@"touxiang");
    self.imageUserAvator.whc_Center(0, 0).whc_Width(54).whc_Height(54);
    self.imageUserAvator.layer.cornerRadius = 25.0f ;
    self.imageUserAvator.layer.masksToBounds = YES ;
    
    self.label_UserNickName.whc_LeftSpaceToView(12, self.imgUserBG).whc_TopSpace(32).whc_HeightAuto().whc_WidthAuto();
    self.label_TimeTitle.whc_TopSpaceToView(10, self.label_UserNickName).whc_LeftSpaceToView(12, self.imgUserBG).whc_HeightAuto().whc_Width(100);
    self.label_TimeLast.whc_LeftSpaceToView(12, self.imgUserBG).whc_TopSpaceToView(5, self.label_TimeTitle).whc_HeightAuto().whc_WidthAuto();
    
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
-(void)handleNotification:(NSNotification*)nf
{
    if ([nf.name isEqualToString:RHNT_UserInfoManagerMineGroupChangedNotification]){
        [self setNeedUpdateCell] ;
    }
}

-(void)updateCell
{
    self.label_UserNickName.text = MineSettingInfo.mUserName ;
    CGFloat totalMoney = MineSettingInfo.mTotalAssets;
    NSString *totalMoneyStr = [NSString stringWithFormat:@" %.2f",totalMoney];
    self.label_TotalMoney.text = [self countNumAndChangeformat:totalMoneyStr];
    self.label_TotalMoney.text = [NSString stringWithFormat:@"¥ %@",self.label_TotalMoney.text];
    
    CGFloat walletBalance = MineSettingInfo.mWalletBalance;
    NSString *walletBalanceStr = [NSString stringWithFormat:@"%.2f",walletBalance];
    self.label_leftMoney.text = [self countNumAndChangeformat:walletBalanceStr];
    self.label_leftMoney.text = [NSString stringWithFormat:@"¥ %@",self.label_leftMoney.text];
    
//    self.label_TotalMoney.text = [NSString stringWithFormat:@"¥ %.2f",MineSettingInfo.mTotalAssets];
//    self.label_leftMoney.text = [NSString stringWithFormat:@"¥ %.2f",MineSettingInfo.mWalletBalance];
    self.label_TimeLast.text = MineSettingInfo.mLoginTime ;
    [self.imageUserAvator sd_setImageWithURL:[NSURL URLWithString:MineSettingInfo.showAvatalURL]
                            placeholderImage:ImageWithName(@"touxiang") options:SDWebImageAllowInvalidSSLCertificates] ;
}

-(NSString *)countNumAndChangeformat:(NSString *)num
{
    if([num rangeOfString:@"."].location !=NSNotFound) //这个判断是判断有没有小数点如果有小数点，需特别处理，经过处理再拼接起来
    {
        //        NSString *losttotal = [NSString stringWithFormat:@"%.2f",[num floatValue]];//小数点后只保留两位
        NSArray *array = [num componentsSeparatedByString:@"."];
        //小数点前:array[0]
        //小数点后:array[1]
        int count = 0;
        num = array[0];
        long long int a = num.longLongValue;
        while (a != 0)
        {
            count++;
            a /= 10;
        }
        NSMutableString *string = [NSMutableString stringWithString:num];
        NSMutableString *newstring = [NSMutableString string];
        while (count > 3) {
            count -= 3;
            NSRange rang = NSMakeRange(string.length - 3, 3);
            NSString *str = [string substringWithRange:rang];
            [newstring insertString:str atIndex:0];
            [newstring insertString:@"," atIndex:0];
            [string deleteCharactersInRange:rang];
        }
        [newstring insertString:string atIndex:0];
        NSMutableString *newString = [NSMutableString string];
        newString =[NSMutableString stringWithFormat:@"%@.%@",newstring,array[1]];
        return newString;
    }else {
        int count = 0;
        long long int a = num.longLongValue;
        while (a != 0)
        {
            count++;
            a /= 10;
        }
        NSMutableString *string = [NSMutableString stringWithString:num];
        NSMutableString *newstring = [NSMutableString string];
        while (count > 3) {
            count -= 3;
            NSRange rang = NSMakeRange(string.length - 3, 3);
            NSString *str = [string substringWithRange:rang];
            [newstring insertString:str atIndex:0];
            [newstring insertString:@"," atIndex:0];
            [string deleteCharactersInRange:rang];
        }
        [newstring insertString:string atIndex:0];
        newstring =[NSMutableString stringWithFormat:@"%@.00",newstring];
        return newstring;
    }
}

@end
