//
//  RH_SlideHeaderView.m
//  gameBoxEx
//
//  Created by luis on 2017/12/20.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_SlideHeaderView.h"
#import "coreLib.h"

@interface RH_SlideHeaderView()
@property (nonatomic,strong) IBOutlet UIView *userBackground ;
@property (nonatomic,strong) IBOutlet UIImageView *userIcon ;
@property (nonatomic,strong) IBOutlet UILabel *labUserName ;
@property (nonatomic,strong) IBOutlet CLButton *btnUserCenter;
@end

@implementation RH_SlideHeaderView

-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.userBackground.backgroundColor = [UIColor clearColor] ;
    [self.btnUserCenter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [self.btnUserCenter.titleLabel setFont:[UIFont systemFontOfSize:15.0f]] ;
    self.btnUserCenter.backgroundColor = colorWithRGB(49, 149, 94) ;
    self.btnUserCenter.layer.cornerRadius = 15.0f ;
    self.btnUserCenter.layer.masksToBounds = YES ;
    
    self.labUserName.textColor = [UIColor whiteColor] ;
    self.labUserName.font = [UIFont lightSystemFontWithSize:20.0f] ;
}

#pragma mark-
-(IBAction)btn_userCenter:(id)sender
{
    ifRespondsSelector(self.delegate, @selector(slideHeaderViewTouchUserCenter:)){
        [self.delegate slideHeaderViewTouchUserCenter:self] ;
    }
}
@end
