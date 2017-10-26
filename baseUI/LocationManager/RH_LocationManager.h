//
//  RH_LocationManager.h
//  TaskTracking
//
//  Created by jinguihua on 2017/5/10.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

//----------------------------------------------------------

//定位状态改变通知
UIKIT_EXTERN NSString * const RH_LocationManagerStatusDidChangeNotification;
//状态改变的上下文
UIKIT_EXTERN NSString * const RH_LocationManagerStatusDidChangeContextUserInfoKey;

//----------------------------------------------------------

//定位标记
@interface RH_LocationMark : NSObject

//默认定位地点
+ (instancetype)defaultLocationMark;

- (id)initWithCityName:(NSString *)cityName;
- (id)initWithPlacemark:(CLPlacemark *)placemark;

@property(nonatomic,strong,readonly) NSString * cityName;
@property(nonatomic,strong,readonly) CLPlacemark * placemark;

@end

//----------------------------------------------------------

@class RH_LocationManager;
@protocol RH_LocationManagerDelegate <NSObject>

@optional

//定位状态改变
- (void)locationManagerStatusDidChange:(RH_LocationManager *)locationManager withContext:(id)context;

@end


//----------------------------------------------------------

typedef NS_ENUM(NSInteger, RH_LocationStatus) {
    RH_LocationStatusNone,              //无状态
    RH_LocationStatusUnavailable,       //不可获取
    RH_LocationStatusLocating,          //正在定位
    RH_LocationStatusLocateFail,        //定位失败
    RH_LocationStatusLocateSuccess,     //定位成功
};

//----------------------------------------------------------

@interface RH_LocationManager : NSObject

//共享的定位管理器
+ (instancetype)shareLocationManager;

//使用ip定位如果需要的话，默认为YES
@property(nonatomic) BOOL useIPLocationIfNeed;

//定位状态
@property(nonatomic,readonly) RH_LocationStatus locationStatus;

//定位的结果地点
@property(nonatomic,strong,readonly) RH_LocationMark * locationmark;
//@property(nonatomic,strong,readonly) NSString * locationCity;

//更新定位,如果不可获取将返回
- (BOOL)refreshLocation;
//停止定位并清空定位状态
- (void)clearLocation;

//代理
@property(nonatomic,weak) id<RH_LocationManagerDelegate> delegate;

@end
