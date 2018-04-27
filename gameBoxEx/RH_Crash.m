//
//  RH_Crash.m
//  gameBoxEx
//
//  Created by lewis on 2018/4/24.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_Crash.h"
#import "RH_APPDelegate.h"
#import "RH_API.h"
#import "RH_UserInfoManager.h"
#import "AFHTTPSessionManager.h"
#import "RH_ServiceRequest.h"
@implementation RH_Crash
static RH_Crash*crashSelf = nil;
-(instancetype)init
{
    if (self = [super init]) {
        [self selfAction];
    }
    return self;
}
-(void)selfAction{
    crashSelf = self;
}
void uncaughtExceptionHandler(NSException *exception){
    
    
    NSArray *stackArry= [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSDictionary *dic = [exception userInfo];
    
    NSString *exceptionInfo = [NSString stringWithFormat:@"sitId:%@\n userName:%@\n  lastLoginTime:%@\n  domin:%@\n ip:%@\n errorMessage:%@\n code:%@\n mark:%@\n type:%@\n versionName:%@\n iphoneInfo:%@\n",crashSelf.siteId,[RH_UserInfoManager shareUserManager].loginUserName,[RH_UserInfoManager shareUserManager].loginTime,[RH_APPDelegate appDelegate].domain,crashSelf.ipStr,reason,CODE,@"",@"",RH_APP_VERCODE,[RH_APPDelegate appDelegate].dictUserAgent];
    //保存到本地沙盒中
//    NSLog(@"%@",exceptionInfo);
//    [exceptionInfo writeToFile:[NSString stringWithFormat:@"%@/Documents/eror.log",NSHomeDirectory()] atomically:YES encoding:NSUTF8StringEncoding error:nil];
#pragma mark -- 崩溃日志
    RH_Crash *crash = [[RH_Crash alloc]init];
    crash.siteId = SID;
    
   
    // 发送崩溃日志
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *dataPath = [path stringByAppendingPathComponent:@"Exception.txt"];
    
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    
    if (data != nil) {
        
        [crashSelf sendExceptionLogWithData:data path:dataPath];
        
    }
}
#pragma mark -- 发送崩溃日志

- (void)sendExceptionLogWithData:(NSData *)data path:(NSString *)path {
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer.timeoutInterval = 5.0f;
//    //告诉AFN，支持接受 text/xml 的数据
//    [AFJSONResponseSerializer serializer].acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",[RH_APPDelegate appDelegate].domain,RH_API_NAME_HOMEINFO];
//    [manager POST:urlString parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
//    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//
//        [formData appendPartWithFileData:data name:@"file" fileName:@"Exception.txt" mimeType:@"txt"];
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//
//        // 删除文件
//
//        NSFileManager *fileManger = [NSFileManager defaultManager];
//
//        [fileManger removeItemAtPath:path error:nil];
//
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//
//
//    }];
//        RH_ServiceRequest *serviceRequest = [[RH_ServiceRequest alloc]init];
//        [serviceRequest startUploadAPPErrorMessge: @{@"haha":@"qweqwe"}];
//        [serviceRequest startV3HomeInfo];
//    RH_API_NAME_HOMEINFO
}
@end
