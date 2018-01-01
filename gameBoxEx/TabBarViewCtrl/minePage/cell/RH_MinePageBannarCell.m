//
//  RH_MinePageBannarCell.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_MinePageBannarCell.h"
#import "coreLib.h"

@interface RH_MinePageBannarCell()
@property (nonatomic,strong) IBOutlet UIImageView *imgICON ;
@property (nonatomic,strong) IBOutlet CLButton *btnLogin ;

//login status info
@property (nonatomic,strong) IBOutlet UIView  *loginAccoutBG ;
@property (nonatomic,strong) IBOutlet UIView  *loginAccoutLevelBG ;


@end


@implementation RH_MinePageBannarCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    
    return 130;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.btnLogin setTitle:@"注册/登录" forState:UIControlStateNormal] ;
    [self.btnLogin setTitleColor:colorWithRGB(51, 51, 51) forState:UIControlStateNormal] ;
    [self.btnLogin setTitleColor:RH_Label_DefaultTextGrayColor forState:UIControlStateHighlighted] ;
    [self.btnLogin addTarget:self action:@selector(testPickerClick:) forControlEvents:UIControlEventTouchUpInside];
    [self switchLoginStatus:NO] ;
}
-(void)testPickerClick:(id)sender
{
    [self.delegate testTimePickerClick:self];
}
-(void)switchLoginStatus:(BOOL)bLogin
{
    self.loginAccoutBG.hidden = !bLogin ;
    self.loginAccoutLevelBG.hidden = !bLogin ;
//    self.labAccoutInfo.hidden = !bLogin ;
    
    self.btnLogin.hidden = bLogin ;
}
@end
