//
//  RH_DiscountActivityModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
#import <CoreGraphics/CoreGraphics.h>

#define RHNT_DiscountActivityImageSizeChanged               @"DiscountActivityImageSizeChanged"

@interface RH_DiscountActivityModel :RH_BasicModel
@property(nonatomic,strong,readonly)NSString *mPhoto;
@property(nonatomic,strong,readonly)NSString *mUrl;

//----
@property(nonatomic,strong,readonly) NSString *showPhoto ;
@property(nonatomic,strong,readonly) NSString *showLink ;
@property(nonatomic,assign,readonly) CGSize showImageSize ;
-(void)updateImageSize:(CGSize)size ;
@end


