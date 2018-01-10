//
//  RH_NormalActivithyView.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_ActivityModel.h"
#import "RH_OpenActivityModel.h"
@class RH_NormalActivithyView;
@protocol RH_NormalActivithyViewDelegate<NSObject>
-(void)normalActivithyViewOpenActivityClick:(RH_NormalActivithyView *)view;
@end
@interface RH_NormalActivithyView : UIView
@property (nonatomic,copy)NSString *gainStr;
@property (nonatomic,weak)id<RH_NormalActivithyViewDelegate>delegate;
@property (nonatomic,strong)RH_ActivityModel *activityModel;
@property (nonatomic,strong)RH_OpenActivityModel *openModel;
@end
