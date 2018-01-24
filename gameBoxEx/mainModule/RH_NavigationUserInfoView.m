//
//  RH_NavigationUserInfoView.m
//  gameBoxEx
//
//  Created by luis on 2017/12/24.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_NavigationUserInfoView.h"
#import "RH_UserInfoManager.h"

@interface RH_NavigationUserInfoView ()
@property (nonatomic,strong) IBOutlet UILabel *labUserName ;
@property (nonatomic,strong) IBOutlet UILabel *labBalance  ;
@property (nonatomic,strong) IBOutlet UIButton *btnCover ;
@end

@implementation RH_NavigationUserInfoView

-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.backgroundColor = [UIColor clearColor] ;
    self.labUserName.textColor = RH_NavigationBar_ForegroundColor ;
    self.labUserName.font = [UIFont systemFontOfSize:10.0f] ;
    self.labBalance.textColor = RH_NavigationBar_ForegroundColor ;
    self.labBalance.font = [UIFont systemFontOfSize:10.0f] ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotificatin:)
                                                 name:RHNT_UserInfoManagerBalanceChangedNotification object:nil] ;
    [self updateUI] ;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

-(void)updateUI
{
    RH_UserBalanceGroupModel *userBalanceGroupModel = UserBalanceInfo ;
    self.labUserName.text = userBalanceGroupModel.mUserName ;
    self.labBalance.text = [NSString stringWithFormat:@"%@%@",userBalanceGroupModel.mCurrSign,userBalanceGroupModel.mAssets] ;
}

#pragma mark-
-(UIButton *)buttonCover
{
    return self.btnCover ;
}

#pragma mark-
-(void)handleNotificatin:(NSNotification*)nt
{
    if ([nt.name isEqualToString:RHNT_UserInfoManagerBalanceChangedNotification]){
        [self performSelectorOnMainThread:@selector(updateUI) withObject:self waitUntilDone:NO] ;
    }
}
@end
