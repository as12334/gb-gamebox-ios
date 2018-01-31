//
//  RH_SubsafetyNaviBarView.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/20.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_SafetyNaviBarView.h"
#import "coreLib.h"
#import "RH_userInfoView.h"
#import "RH_UserInfoManager.h"
#import "RH_APPDelegate.h"
#import "RH_NavigationUserInfoView.h"

@interface RH_SafetyNaviBarView ()
@property(nonatomic,weak) IBOutlet UIView *safetyNaviBarView  ;
@property(nonatomic,weak) IBOutlet UILabel *labTitle    ;
@end


@implementation RH_SafetyNaviBarView

-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.backgroundColor = [UIColor clearColor] ;
    self.labTitle.font = RH_NavigationBar_TitleFontSize ;
    self.labTitle.textColor = RH_NavigationBar_ForegroundColor ;
    self.labTitle.text = @"安全中心" ;
}

-(IBAction)btn_back:(id)sender
{
    ifRespondsSelector(self.delegate, @selector(safetyNaviBarViewDidTouchBackButton:)){
        [self.delegate safetyNaviBarViewDidTouchBackButton:self] ;
    }
}

@end
