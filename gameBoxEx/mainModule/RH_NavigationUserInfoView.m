//
//  RH_NavigationUserInfoView.m
//  gameBoxEx
//
//  Created by luis on 2017/12/24.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_NavigationUserInfoView.h"

@interface RH_NavigationUserInfoView ()
@property (nonatomic,strong) IBOutlet UILabel *labUserName ;
@property (nonatomic,strong) IBOutlet UILabel *labBalance  ;
@property (weak, nonatomic) IBOutlet UIView *vv;
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
    
    //test
    self.labUserName.text = @"EVDKFJDLFDDFD" ;
    self.labBalance.text = @"¥300.00" ;
}

@end
