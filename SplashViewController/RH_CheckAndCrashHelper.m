//
//  RH_CheckAndCrashHelper.m
//  gameBoxEx
//
//  Created by jun on 2018/9/17.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_CheckAndCrashHelper.h"
#import "RH_UserInfoManager.h"
#import <sys/utsname.h>
#import "RH_ServiceRequest.h"
static RH_CheckAndCrashHelper *_helper;
@interface RH_CheckAndCrashHelper()
@property(nonatomic,strong)RH_ServiceRequest *serviceRequest;
@end
@implementation RH_CheckAndCrashHelper
+(instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_helper) {
            _helper = [[self alloc]init];
        }
    });
    return _helper;
}
-(RH_ServiceRequest *)serviceRequest
{
    if (!_serviceRequest) {
        _serviceRequest = [[RH_ServiceRequest alloc] init];
    }
    return _serviceRequest ;
}
-(void)uploadJournalWithMessages:(NSArray *)messages{
    NSMutableDictionary *dictError = [[NSMutableDictionary alloc] init] ;
    [dictError setValue:SID forKey:@"siteId"] ;
    [dictError setValue:[self randomMark] forKey:@"mark"] ;
    [dictError setValue:[self localIPAddress]?[self localIPAddress]:@"" forKey:@"ip"] ;
    if ([RH_UserInfoManager shareUserManager].loginUserName.length){
        [dictError setValue:[RH_UserInfoManager shareUserManager].loginUserName
                     forKey:@"username"] ;
        [dictError setValue:[RH_UserInfoManager shareUserManager].loginTime
                     forKey:@"lastLoginTime"] ;
    }
    NSMutableString *domainList = [[NSMutableString alloc] init] ;
    NSMutableString *errorCodeList = [[NSMutableString alloc] init] ;
    NSMutableString *errorMessageList = [[NSMutableString alloc] init] ;
    NSString *type;
    for (NSDictionary *dictTmp in messages) {
        if (domainList.length){
            [domainList appendString:@";"] ;
        }
        
        if (errorCodeList.length){
            [errorCodeList appendString:@";"] ;
        }
        
        if (errorMessageList.length){
            [errorMessageList appendString:@";"] ;
        }
        
        [domainList appendString:[dictTmp stringValueForKey:@"domain"]] ;
        [errorCodeList appendString:[dictTmp stringValueForKey:@"code"]] ;
        [errorMessageList appendString:[dictTmp stringValueForKey:@"errorMessage"]] ;
         type = [dictTmp stringValueForKey:@"type"];
    }
    
    [dictError setValue:domainList forKey:@"domain"] ;
    [dictError setValue:errorCodeList forKey:@"code"] ;
    [dictError setValue:errorMessageList forKey:@"errorMessage"] ;
    [dictError setValue:type forKey: @"type"];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    [dictError setValue:[appVersion stringByAppendingString:[NSString stringWithFormat:@".%@",RH_APP_VERCODE]] forKey:@"versionName"];
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
    [dictError setValue:sysVersion forKey:@"sysCode"];
    [dictError setValue:@"iOS" forKey:@"channel"];
    NSString *deviceBrands = [[UIDevice currentDevice] model];
    [dictError setValue:deviceBrands forKey:@"brands"];
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    [dictError setValue:deviceModel forKey:@"model"];
    
    [self.serviceRequest startUploadAPPErrorMessge:dictError] ;
    self.serviceRequest.successBlock = ^(RH_ServiceRequest *serviceRequest, ServiceRequestType type, id data) {
        //
        if (type == ServiceRequestTypeCollectAPPError) {
             NSLog(@"错误日志成功%@",data);
        }
       
    };
    self.serviceRequest.failBlock = ^(RH_ServiceRequest *serviceRequest, ServiceRequestType type, NSError *error) {
        if (type == ServiceRequestTypeCollectAPPError) {
            NSLog(@"错误日志失败%@",error);
    }
    
    };
}
- (NSString *)randomMark
{
    static int kNumber = 6;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
//获取设备IP地址
- (NSString *)localIPAddress
{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    //判断返回字符串是否为所需数据
    if ([ip hasPrefix:@"var returnCitySN = "]) {
        //对字符串进行处理，然后进行json解析
        //删除字符串多余字符串
        NSRange range = NSMakeRange(0, 19);
        [ip deleteCharactersInRange:range];
        NSString * nowIp =[ip substringToIndex:ip.length-1];
        //将字符串转换成二进制进行Json解析
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return dict[@"cip"] ? dict[@"cip"] : @"";
    }
    return @"";
}
@end
