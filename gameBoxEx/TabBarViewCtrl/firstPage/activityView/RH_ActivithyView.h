//
//  RH_ActivithyView.h
//  lotteryBox
//
//  Created by Lewis on 2017/12/25.
//  Copyright © 2017年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coreLib.h"
#import "RH_ActivityModel.h"

#define activithyViewWidth                                               120.0f
#define activithyViewHeigh                                               120.0f

@class RH_ActivithyView ;
@protocol ActivithyViewDelegate
@optional
-(void)activithyViewDidTouchActivityView:(RH_ActivithyView*)activityView ;
-(void)activityViewDidTouchCloseActivityView:(RH_ActivithyView *)activityView;
@end

@interface RH_ActivithyView : CLSelectionControl
@property (nonatomic,weak) id<ActivithyViewDelegate> delegate ;
@property (nonatomic,strong) RH_ActivityModel *activityModel ;
@property(nonatomic,strong) IBOutlet UIImageView *imgView ;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
