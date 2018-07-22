//
//  RH_AdvertisementView.h
//  gameBoxEx
//
//  Created by Richard on 2018/3/29.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_PhoneDialogModel.h"
@class RH_AdvertisementView ;
@protocol AdvertisementViewDelegate
@optional
-(void)advertisementViewDidTouchSureBtn:(RH_AdvertisementView *)advertisementView DataModel:(RH_PhoneDialogModel *)phoneModel ;
@end

@interface RH_AdvertisementView : UIView
@property(nonatomic,weak) id<AdvertisementViewDelegate> delegate ;
-(void)advertisementViewUpDataWithModel:(RH_PhoneDialogModel *)phoneModel ;
-(void)hideAdvertisementView ;
@end
