//
//  RH_NavigationUserInfoView.m
//  gameBoxEx
//
//  Created by luis on 2017/12/24.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_NavigationUserInfoView.h"
#import "RH_UserInfoManager.h"
#import "coreLib.h"
#import "RH_MineInfoModel.h"

@interface RH_NavigationUserInfoView ()
@property (nonatomic,strong) IBOutlet UILabel *labUserName ;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

@property (nonatomic,strong) IBOutlet UIButton *btnCover ;
@end

@implementation RH_NavigationUserInfoView

-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.backgroundColor = [UIColor clearColor] ;
    self.moreImageView.whc_RightSpace(0).whc_CenterY(0).whc_Width(3).whc_Height(20);
    self.labUserName.whc_RightSpaceToView(0, self.moreImageView).whc_CenterY(-5).whc_Width(20).whc_Height(8);
    
    
    
    self.labUserName.textColor = RH_NavigationBar_ForegroundColor ;
    self.labUserName.font = [UIFont systemFontOfSize:10.0f] ;
    self.labBalance.textColor = RH_NavigationBar_ForegroundColor ;
    self.labBalance.font = [UIFont systemFontOfSize:10.0f] ;
    
    self.labUserName.text = @"";
    self.labBalance.text = @"" ;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotificatin:)
                                                 name:RHNT_UserInfoManagerMineGroupChangedNotification object:nil] ;
    [self updateUI] ;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

-(void)updateUI
{
    RH_MineInfoModel *userInfoModel = MineSettingInfo ;
    if (userInfoModel){
        self.labUserName.text = userInfoModel.mUserName ;
        self.labBalance.whc_RightSpaceToView(0, self.moreImageView).whc_TopSpaceToView(0, self.labUserName).whc_WidthAuto().whc_Height(15);
        self.leftImageView.whc_RightSpaceToView(2, self.labBalance).whc_TopSpaceToView(4, self.labUserName).whc_Width(6).whc_Height(6);
        self.labBalance.text =  [NSString stringWithFormat:@"%@%@",userInfoModel.mCurrency,userInfoModel.showTotalAssets] ;
    }
}

#pragma mark-
-(UIButton *)buttonCover
{
    return self.btnCover ;
}

#pragma mark-
-(void)handleNotificatin:(NSNotification*)nt
{
    if ([nt.name isEqualToString:RHNT_UserInfoManagerMineGroupChangedNotification]){
        [self performSelectorOnMainThread:@selector(updateUI) withObject:self waitUntilDone:NO] ;
    }
}
@end
