//
//  RH_OpenActivithyView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/8.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_OpenActivithyView.h"
#import "coreLib.h"
#import "RH_ActivityModel.h"

@interface RH_OpenActivithyView()


@end

@implementation RH_OpenActivithyView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}
//-(void)setActivityModel:(RH_ActivityModel *)activityModel
//{
//    if (![_activityModel isEqual:activityModel]){
//        _activityModel = activityModel ;
//        
//    }
//}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.timeLabel.text = self.activityModel.mNextLotteryTime;
    self.chanceLabel.text = self.activityModel.mDrawTimes;

}
@end
