//
//  RH_LotteryGameListTopView.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/5.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_LotteryGameListTopView.h"
@class RH_LotteryGameListTopView;
@protocol LotteryGameListTopViewDelegate<NSObject>
@optional
-(void)lotteryGameListTopViewDidReturn:(RH_LotteryGameListTopView*)lotteryGameListTopView ;
@end
@interface RH_LotteryGameListTopView : UIView
@property(nonatomic,weak)id<LotteryGameListTopViewDelegate>delegate ;

@property(nonatomic,strong,readonly) NSString *searchInfo ;
-(BOOL)isEdit ;
@end
