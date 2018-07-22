//
//  RH_BannerViewCell.h
//  lotteryBox
//
//  Created by luis on 2017/12/10.
//  Copyright © 2017年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coreLib.h"
#import "RH_BannerModelProtocol.h"

@interface RH_BannerViewCell : CLTableViewCell
@property (nonatomic,weak) id<RH_ShowBannerDetailDelegate> delegate;
@end
