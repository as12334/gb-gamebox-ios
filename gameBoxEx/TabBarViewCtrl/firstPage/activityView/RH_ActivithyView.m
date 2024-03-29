//
//  RH_ActivithyView.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/25.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_ActivithyView.h"
#import "RH_UserInfoTotalCell.h"
#import "RH_UserInfoGengeralCell.h"

@interface RH_ActivithyView ()

@end

@implementation RH_ActivithyView
-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.backgroundColor = [UIColor clearColor] ;
    self.imgView.backgroundColor = [UIColor clearColor] ;
    if ([THEMEV3 isEqualToString:@"green"]||[THEMEV3 isEqualToString:@"red"]||[THEMEV3 isEqualToString:@"black"]||[THEMEV3 isEqualToString:@"orange"]||[THEMEV3 isEqualToString:@"blue"]||[THEMEV3 isEqualToString:@"coffee_black"]) {
        [self.deleteButton setImage:ImageWithName(@"home_cancel_white_icon") forState:UIControlStateNormal];
    }else{
        [self.deleteButton setImage:ImageWithName(@"home_cancel_icon") forState:UIControlStateNormal];
    }
    [self addTarget:self action:@selector(activityHandle) forControlEvents:UIControlEventTouchUpInside] ;
}

#pragma mark-
-(void)setActivityModel:(RH_ActivityModel *)activityModel
{
    if (![_activityModel isEqual:activityModel]){
        _activityModel = activityModel ;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:_activityModel.showEffectURL]] ;
    }
    else{
        [self.imgView setImage:nil];
    }
}

#pragma mark-
-(void)activityHandle
{
    ifRespondsSelector(self.delegate, @selector(activithyViewDidTouchActivityView:)){
        [self.delegate activithyViewDidTouchActivityView:self] ;
    }
}

- (IBAction)removeFromeSuperView:(id)sender {
    ifRespondsSelector(self.delegate, @selector(activityViewDidTouchCloseActivityView:)){
        [self.delegate activityViewDidTouchCloseActivityView:self] ;
    }
}
@end
