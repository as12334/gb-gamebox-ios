//
//  RH_DepositeTransferPulldownView.h
//  gameBoxEx
//
//  Created by lewis on 2018/4/2.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_DepositeTransferChannelModel.h"
@protocol DepositeTransferPulldownViewDelegate<NSObject>
@optional
-(void)depositeTransferChooseCunterCelected:(RH_DepositeTansferCounterModel *)cunterModel;
@end
@interface RH_DepositeTransferPulldownView : UIView
@property(nonatomic,weak)id<DepositeTransferPulldownViewDelegate>delegate;
@end
