//
//  RH_LocationManager.m
//  TaskTracking
//
//  Created by jinguihua on 2017/5/10.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_LocationManager.h"
#import "RH_ServiceRequest.h"
#import "coreLib.h"
//----------------------------------------------------------

//定位状态改变通知
NSString * const RH_LocationManagerStatusDidChangeNotification = @"RH_LocationManagerStatusDidChangeNotification";

//状态改变的上下文
NSString * const RH_LocationManagerStatusDidChangeContextUserInfoKey = @"RH_LocationManagerStatusDidChangeContextUserInfoKey";

//----------------------------------------------------------

@implementation RH_LocationMark

@synthesize cityName = _cityName;

+ (instancetype)defaultLocationMark {
    return [[self alloc] initWithCityName:@"武汉"];
}

- (id)initWithCityName:(NSString *)cityName
{
    self = [super init];
    if (self) {
        _cityName = cityName;
    }

    return self;
}

- (id)initWithPlacemark:(CLPlacemark *)placemark
{
    self = [super init];
    if (self) {
        _placemark = placemark;
    }

    return self;
}

- (NSString *)cityName
{
    if (!_cityName) {

        if (_placemark) {

            //获取城市信息
            NSString * cityName = _placemark.locality ?: _placemark.administrativeArea;

            //去掉市字
            NSRange range = [cityName rangeOfString:@"市" options:NSBackwardsSearch];
            if (range.location != NSNotFound &&
                range.location == cityName.length - 1) {
                cityName = [cityName substringToIndex:range.location];
            }

            _cityName = cityName;
        }
    }

    return _cityName;
}

@end

//----------------------------------------------------------

@interface RH_LocationManager () < CLLocationManagerDelegate,RH_ServiceRequestDelegate >

@property(nonatomic,strong,readonly) CLLocationManager * locationManager;
@property(nonatomic,strong,readonly) CLGeocoder * geocoder;
@property(nonatomic,strong,readonly) RH_ServiceRequest * serviceRequest;

@end

//----------------------------------------------------------

@implementation RH_LocationManager
{
    //反地理编码尝试次数
    NSUInteger _geocoderTryCount;
}

@synthesize locationManager = _locationManager;
@synthesize geocoder = _geocoder;
@synthesize serviceRequest = _serviceRequest;
//@synthesize locationCity = _locationCity;

#pragma mark -

+ (instancetype)shareLocationManager
{
    static RH_LocationManager * shareLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareLocationManager = [[self alloc] init];
    });
    return shareLocationManager;
}

#pragma mark-

- (id)init
{
    self = [super init];
    if (self) {
        _useIPLocationIfNeed = NO;
    }

    return self;
}

- (void)dealloc {
    [self clearLocation];
}

#pragma mark-

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }

    return _locationManager;
}

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }

    return _geocoder;
}

- (RH_ServiceRequest *)serviceRequest
{
    if (!_serviceRequest) {
        _serviceRequest = [[RH_ServiceRequest alloc] init];
        _serviceRequest.delegate = self;
    }

    return _serviceRequest;
}

#pragma mark-

- (BOOL)refreshLocation
{
    //清空定位数据
    [self _clearLocation:NO];

    //默认定位状态
    _locationStatus = RH_LocationStatusUnavailable;

    //首先核对定位服务是否可用
    NSString * startLocationFailMessage = nil;

    if (![[[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleLanguageCode] isEqualToString:@"zh"]) {
        startLocationFailMessage = @"我们无法使用您的手机定位服务。";
    }else {

        if ([CLLocationManager locationServicesEnabled]) {
            CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
            if (authorizationStatus == kCLAuthorizationStatusRestricted) {
                startLocationFailMessage = @"我们无法使用您的手机定位服务。";
            }else if(authorizationStatus == kCLAuthorizationStatusDenied) {
                startLocationFailMessage = @"我们无权使用您的手机定位服务，请在\"设置->隐私\"中设置";
            }
        }else {
            startLocationFailMessage = @"您的手机定位服务未开启,请在\"设置->隐私\"中设置";
        }
    }

    if (startLocationFailMessage == nil) {

        //请求定位许可
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }

        //开始定位
        _locationStatus = RH_LocationStatusLocating;
        [self.locationManager startUpdatingLocation];

    }else if (self.useIPLocationIfNeed) {

        if (NetworkAvailable()) {

            //网络可用则开始通过IP获取地点
            _locationStatus = RH_LocationStatusLocating;
//            [self.serviceRequest startGetLocationCityService];

        }else {

            showAlertView(@"提醒", @"网络似乎断开了连接，我们无法获取您的位置信息。");
        }

    }else {
        showAlertView(@"提醒", startLocationFailMessage);
    }

    //发送状态改变通知
    [self _sendLocationStatusChangeNotificationWithContext:nil];

    return NO;
}

- (void)clearLocation {
    [self _clearLocation:YES];
}

- (void)_clearLocation:(BOOL)notifly
{
    [_locationManager stopUpdatingLocation];
    [_geocoder cancelGeocode];
    [_serviceRequest cancleAllServices];
    _locationmark = nil;
    _geocoderTryCount = 0;

    //设置状态
    if (notifly &&  _locationStatus != RH_LocationStatusNone) {
        _locationStatus = RH_LocationStatusNone;
        [self _sendLocationStatusChangeNotificationWithContext:nil];
    }else {
        _locationStatus = RH_LocationStatusNone;
    }
}

#pragma mark -

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //停止定位
    [manager stopUpdatingLocation];

    //位置有效则开始反地理编码
    CLLocation * location = [locations lastObject];
    if (location.horizontalAccuracy != -1 && !self.geocoder.isGeocoding) {

        //反地理编码
        [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {

            //错误或无编码信息
            if (error || placemarks.count == 0) {

                if (error) {

                    DebugLog(@"RH_LocationManager", @"反地理编码失败.error = %@",error);

                    //网络错误则直接发送错误信息
                    if (error.code == kCLErrorNetwork) {

                        _locationStatus = RH_LocationStatusLocateFail;
                        [self _sendLocationStatusChangeNotificationWithContext:error];

                        return;
                    }
                }

                //反地理编码失败或者无结果超过五次则发送错误信息
                if ((++ _geocoderTryCount) > 5) {

                    error = error ?: ERROR_CREATE(@"RH_LocationManager", 1000, @"无法获取位置信息", nil);

                    _locationStatus = RH_LocationStatusLocateFail;
                    [self _sendLocationStatusChangeNotificationWithContext:error];

                }else { //否则重新开始定位
                    [self.locationManager startUpdatingLocation];
                }

            } else { //定位成功

                CLPlacemark * placemark = [placemarks firstObject];
                DebugLog(@"RH_LocationManager", @"获取位置信息成功.place = %@",placemark.name);
                _locationmark = placemark ? [[RH_LocationMark alloc] initWithPlacemark:placemark] : nil;
                _locationStatus = placemark ? RH_LocationStatusLocateSuccess : RH_LocationStatusLocateFail;

                [self _sendLocationStatusChangeNotificationWithContext:nil];
            }
        }];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    _locationStatus = RH_LocationStatusLocateFail;
    DebugLog(@"RH_LocationManager", @"获取位置信息失败.error = %@",error);

    [self _sendLocationStatusChangeNotificationWithContext:error];
}

#pragma mark -  
//
//- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestSerivceType)type didFailRequestWithError:(NSError *)error
//{
//    if (type == ServiceRequestSerivceTypeGetLocationCity) {
//        DebugLog(@"RH_LocationManager", @"获取位置信息失败.error = %@",error);
//
//        _locationStatus = RH_LocationStatusLocateFail;
//
//        [self _sendLocationStatusChangeNotificationWithContext:error];
//    }
//}
//
//- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestSerivceType)type didSuccessRequestWithData:(id)data
//{
//    if (type == ServiceRequestSerivceTypeGetLocationCity) {
//
//        DebugLog(@"RH_LocationManager", @"获取位置信息成功.place = %@",data);
//
//        NSString * locationCity = data;
//        _locationmark = locationCity.length ? [[RH_LocationMark alloc] initWithCityName:locationCity] : nil;
//        _locationStatus = locationCity.length ? RH_LocationStatusLocateSuccess : RH_LocationStatusLocateFail;
//
//        [self _sendLocationStatusChangeNotificationWithContext:nil];
//    }
//}

#pragma mark -

- (void)_sendLocationStatusChangeNotificationWithContext:(id)context
{
    //代理
    id<RH_LocationManagerDelegate> delegate = self.delegate;
    ifRespondsSelector(delegate, @selector(locationManagerStatusDidChange:withContext:)) {
        [delegate locationManagerStatusDidChange:self withContext:context];
    }

    //通知
    [[NSNotificationCenter defaultCenter] postNotificationName:RH_LocationManagerStatusDidChangeNotification object:self userInfo:context ? @{RH_LocationManagerStatusDidChangeContextUserInfoKey : context} : nil];
}

@end

