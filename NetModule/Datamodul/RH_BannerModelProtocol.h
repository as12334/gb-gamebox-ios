//
//  RH_BannerModelProtocol.h
//  lotteryBox
//
//  Created by luis on 2017/12/10.
//  Copyright © 2017年 luis. All rights reserved.
//

#ifndef RH_BannerModelProtocol_h
#define RH_BannerModelProtocol_h

@protocol RH_BannerModelProtocol <NSObject>

@property(nonatomic,strong,readonly) NSString * id;

//封面URL
@property(nonatomic,strong,readonly) NSString * thumbURL;
//内容URL
@property(nonatomic,strong,readonly) NSString * contentURL;


@end

//----------------------------------------------------------

@protocol RH_ShowBannerDetailDelegate <NSObject>

@optional
- (void)object:(id)object wantToShowBannerDetail:(id<RH_BannerModelProtocol>)bannerModel;

@end

#endif /* RH_BannerModelProtocol_h */
