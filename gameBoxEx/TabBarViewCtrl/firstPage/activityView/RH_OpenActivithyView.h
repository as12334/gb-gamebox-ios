//
//  RH_OpenActivithyView.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/8.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_ActivityModel.h"
@interface RH_OpenActivithyView : UIView
@property(nonatomic,strong)RH_ActivityModel *activityModel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *chanceLabel;
@end
