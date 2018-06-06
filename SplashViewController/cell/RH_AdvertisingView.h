//
//  RH_AdvertisingView.h
//  gameBoxEx
//
//  Created by lewis on 2018/6/5.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RH_AdvertisingView;
typedef void (^AdvertisingViewBlock)();
@interface RH_AdvertisingView : UIView
@property(nonatomic,copy)AdvertisingViewBlock block;
+(RH_AdvertisingView*)ceareAdvertisingView:(NSString *)urlString;

@end
