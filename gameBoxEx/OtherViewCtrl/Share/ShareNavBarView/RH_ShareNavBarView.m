//
//  RH_ShareNavBarView.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ShareNavBarView.h"
#import "coreLib.h"
#import "RH_userInfoView.h"
#import "RH_UserInfoManager.h"
#import "RH_APPDelegate.h"
#import "RH_NavigationUserInfoView.h"
@interface RH_ShareNavBarView ()
@property(nonatomic,weak) IBOutlet UIView *shareNaviBarView  ;
@property(nonatomic,weak) IBOutlet UILabel *labTitle    ;
@end

@implementation RH_ShareNavBarView
-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.backgroundColor = [UIColor clearColor] ;
    self.labTitle.font = RH_NavigationBar_TitleFontSize ;
    self.labTitle.textColor = RH_NavigationBar_ForegroundColor ;
    self.labTitle.text = @"分享好友" ;
}

-(IBAction)btn_back:(id)sender
{
    ifRespondsSelector(self.delegate, @selector(shareNaviBarViewDidTouchBackButton:)){
        [self.delegate shareNaviBarViewDidTouchBackButton:self] ;
    }
}
- (IBAction)setting_btn:(id)sender {
    ifRespondsSelector(self.delegate, @selector(shareNaviBarViewDidTouchSettingButton:)){
        [self.delegate shareNaviBarViewDidTouchSettingButton:self] ;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
