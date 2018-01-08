//
//  RH_ServiceRequest.m
//  CoreLib
//
//  Created by jinguihua on 2016/11/30.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "RH_ServiceRequest.h"
#import "RH_HTTPRequest.h"
#import "NSError+RH_HTTPRequest.h"
#import "RH_ErrorCode.h"
#import "RH_API.h"
#import "coreLib.h"
#import "RH_UpdatedVersionModel.h"
#import "RH_APPDelegate.h"
#import "RH_UserInfoManager.h"
///-------DATA MODULE--------------------//
#import "RH_HomePageModel.h"
#import "RH_UserBalanceGroupModel.h"
#import "RH_MineGroupInfoModel.h"
#import "RH_BettingInfoModel.h"

//----------------------------------------------------------
//访问权限
typedef NS_ENUM(NSInteger,ServiceScopeType) {
    //公开
    ServiceScopeTypePublic,
};

//----------------------------------------------------------

//请求上下文
@interface RH_ServiceRequestContext : NSObject

- (id)initWithSerivceType:(ServiceRequestType)serivceType
                scopeType:(ServiceScopeType)scopeType;

//访问权限
@property(nonatomic,readonly) ServiceScopeType scopeType;

//服务类型
@property(nonatomic,readonly) ServiceRequestType serivceType;

@end

//----------------------------------------------------------


@implementation RH_ServiceRequestContext

- (id)initWithSerivceType:(ServiceRequestType)serivceType scopeType:(ServiceScopeType)scopeType
{
    self = [super init];

    if (self) {
        _serivceType = serivceType;
        _scopeType = scopeType;
    }

    return self;
}

@end

//------------------------------------------------------------------
@interface RH_ServiceRequest ()<RH_HTTPRequestDelegate>
@property(nonatomic,strong,readonly) NSMutableDictionary * httpRequests;

@property(nonatomic,strong,readonly) NSMutableDictionary * requestingMarks;
@property(nonatomic,strong,readonly) NSString * uniqueID;

//上下文
@property(nonatomic,strong,readonly) NSMutableDictionary * contexts;
@property(nonatomic,strong,readonly) NSMutableDictionary * doSometiongMasks;
@end

//------------------------------------------------------------------

@implementation RH_ServiceRequest
@synthesize httpRequests = _httpRequests;
@synthesize requestingMarks = _requestingMarks;
@synthesize uniqueID = _uniqueID;
@synthesize contexts = _contexts;
@synthesize doSometiongMasks = _doSometiongMasks;

#pragma mark-用户接口定义

-(void)startReqDomainList
{
    [self _startServiceWithAPIName:RH_API_MAIN_URL
                        pathFormat:@"app/line.html"
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:@{RH_SP_COMMON_SITECODE:CODE,
                                     RH_SP_COMMON_SITESEC:S}
                     bodyArguments:nil
                          httpType:HTTPRequestTypeGet
                       serviceType:ServiceRequestTypeDomainList
                         scopeType:ServiceScopeTypePublic];
}

-(void)startCheckDomain:(NSString*)doMain
{
    [self _startServiceWithAPIName:nil
                        pathFormat:@"http://%@/__check"
                     pathArguments:@[doMain?:@""]
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypeGet
                       serviceType:ServiceRequestTypeDomainCheck
                         scopeType:ServiceScopeTypePublic];
}

-(void)startUpdateCheck
{
    [self _startServiceWithAPIName:RH_API_MAIN_URL
                        pathFormat:@"app/update.html"
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:@{RH_SP_COMMON_OSTYPE:@"ios",
                                     RH_SP_COMMON_CHECKVERSION:RH_APP_UPDATECHECK
                                     }
                     bodyArguments:nil
                          httpType:HTTPRequestTypeGet
                       serviceType:ServiceRequestTypeUpdateCheck
                         scopeType:ServiceScopeTypePublic];
}

-(void)startLoginWithUserName:(NSString*)userName Password:(NSString*)password VerifyCode:(NSString*)verCode
{
    RH_APPDelegate *appDelegate = (RH_APPDelegate*)[UIApplication sharedApplication].delegate ;
    
    [self _startServiceWithAPIName:appDelegate.domain
                        pathFormat:RH_API_NAME_LOGIN
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":@"app_ios, iPhone"
                                     }
                    queryArguments:verCode.length?@{@"username":userName?:@"",
                                                    @"password":password?:@"",
                                                    @"captcha":verCode
                                                    } :@{@"username":userName?:@"",
                                                         @"password":password?:@""
                                                         }
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeUserLogin
                         scopeType:ServiceScopeTypePublic];
}

-(void)startAutoLoginWithUserName:(NSString*)userName Password:(NSString*)password
{
    RH_APPDelegate *appDelegate = (RH_APPDelegate*)[UIApplication sharedApplication].delegate ;
    
    [self _startServiceWithAPIName:appDelegate.domain
                        pathFormat:RH_API_NAME_AUTOLOGIN
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":@"app_ios, iPhone"
                                     }
                    queryArguments:@{@"username":userName?:@"",
                                     @"password":password?:@""
                                     }
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeUserAutoLogin
                         scopeType:ServiceScopeTypePublic];
}

-(void)startGetVerifyCode
{
    RH_APPDelegate *appDelegate = (RH_APPDelegate*)[UIApplication sharedApplication].delegate ;
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] ;
    NSString *timeStr = [NSString stringWithFormat:@"%.0f",timeInterval*1000] ;
    [self _startServiceWithAPIName:appDelegate.domain
                        pathFormat:RH_API_NAME_VERIFYCODE
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":@"app_ios, iPhone"
                                     }
                    queryArguments:@{@"_t":timeStr}
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeObtainVerifyCode
                         scopeType:ServiceScopeTypePublic];
}

-(void)startDemoLogin
{
    RH_APPDelegate *appDelegate = (RH_APPDelegate*)[UIApplication sharedApplication].delegate ;
    [self _startServiceWithAPIName:appDelegate.domain
                        pathFormat:RH_API_NAME_DEMOLOGIN
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":@"app_ios, iPhone"
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeDemoLogin
                         scopeType:ServiceScopeTypePublic];
}

-(void)startGetCustomService
{
    RH_APPDelegate *appDelegate = (RH_APPDelegate*)[UIApplication sharedApplication].delegate ;
    [self _startServiceWithAPIName:appDelegate.domain
                        pathFormat:RH_API_NAME_GETCUSTOMPATH
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypeGet
                       serviceType:ServiceRequestTypeGetCustomService
                         scopeType:ServiceScopeTypePublic];
}

-(void)startAPIRetrive:(NSInteger)apiID
{
    RH_APPDelegate *appDelegate = (RH_APPDelegate*)[UIApplication sharedApplication].delegate ;
    [self _startServiceWithAPIName:appDelegate.domain
                        pathFormat:RH_API_NAME_APIRETRIVE
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:@{RH_SP_APIRETRIVE_APIID:@(apiID)}
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeAPIRetrive
                         scopeType:ServiceScopeTypePublic];
}

-(void)startTestUrl:(NSString*)testURL
{
    [self _startServiceWithAPIName:testURL
                        pathFormat:nil
                     pathArguments:nil
                   headerArguments:nil
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypeGet
                       serviceType:ServiceRequestTypeTestUrl
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - v3 接口定义
-(void)startV3HomeInfo
{
    RH_APPDelegate *appDelegate = (RH_APPDelegate*)[UIApplication sharedApplication].delegate ;
    [self _startServiceWithAPIName:appDelegate.domain
                        pathFormat:RH_API_NAME_HOMEINFO
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3HomeInfo
                         scopeType:ServiceScopeTypePublic];
}

-(void)startV3UserInfo
{
    RH_APPDelegate *appDelegate = (RH_APPDelegate*)[UIApplication sharedApplication].delegate ;
    [self _startServiceWithAPIName:appDelegate.domain
                        pathFormat:RH_API_NAME_USERINFO
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3UserInfo
                         scopeType:ServiceScopeTypePublic];
}

-(void)startV3MineLinkInfo
{
    RH_APPDelegate *appDelegate = (RH_APPDelegate*)[UIApplication sharedApplication].delegate ;
    [self _startServiceWithAPIName:appDelegate.domain
                        pathFormat:RH_API_NAME_MINEGROUPINFO
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3MineGroupInfo
                         scopeType:ServiceScopeTypePublic];
}

-(void)startV3ActivityStaus:(NSString*)activityID
{
    RH_APPDelegate *appDelegate = (RH_APPDelegate*)[UIApplication sharedApplication].delegate ;
    [self _startServiceWithAPIName:appDelegate.domain
                        pathFormat:RH_API_NAME_ACTIVITYSTATUS
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:@{RH_SP_ACTIVITYSTATUS_MESSAGEID:activityID?:@""}
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3ActivityStatus
                         scopeType:ServiceScopeTypePublic];
}

-(void)startV3GameListWithApiID:(NSInteger)apiID
                      ApiTypeID:(NSInteger)apiTypeID
                     PageNumber:(NSInteger)pageNumber
                       PageSize:(NSInteger)pageSize
                     SearchName:(NSString*)searchName
{
    NSMutableDictionary *dictTmp = [[NSMutableDictionary alloc] init] ;
    [dictTmp setValue:@(apiID) forKey:RH_SP_APIGAMELIST_APIID] ;
    [dictTmp setValue:@(apiTypeID) forKey:RH_SP_APIGAMELIST_APITYPEID] ;
    [dictTmp setValue:@(pageNumber) forKey:RH_SP_APIGAMELIST_PAGENUMBER] ;
    [dictTmp setValue:@(pageSize) forKey:RH_SP_APIGAMELIST_PAGESIZE] ;
    if (searchName.length){
        [dictTmp setValue:searchName forKey:RH_SP_APIGAMELIST_NAME] ;
    }
    
    RH_APPDelegate *appDelegate = (RH_APPDelegate*)[UIApplication sharedApplication].delegate ;
    [self _startServiceWithAPIName:appDelegate.domain
                        pathFormat:RH_API_NAME_APIGAMELIST
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:dictTmp
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3APIGameList
                         scopeType:ServiceScopeTypePublic];
}

-(void)startV3BettingList:(NSString*)startDate EndDate:(NSString*)endDate
               PageNumber:(NSInteger)pageNumber
                 PageSize:(NSInteger)pageSize
{
    RH_APPDelegate *appDelegate = (RH_APPDelegate*)[UIApplication sharedApplication].delegate ;
    [self _startServiceWithAPIName:appDelegate.domain
                        pathFormat:RH_API_NAME_BETTINGLIST
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:@{RH_SP_BETTINGLIST_STARTDATE:startDate?:@"",
                                     RH_SP_BETTINGLIST_ENDDATE:endDate?:@""
                                     }
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3BettingList
                         scopeType:ServiceScopeTypePublic];
}

-(void)startV3DepositList:(NSString*)startDate EndDate:(NSString*)endDate
{
    RH_APPDelegate *appDelegate = (RH_APPDelegate*)[UIApplication sharedApplication].delegate ;
    [self _startServiceWithAPIName:appDelegate.domain
                        pathFormat:RH_API_NAME_DEPOSITLIST
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:@{RH_SP_DEPOSITLIST_STARTDATE:startDate?:@"",
                                     RH_SP_DEPOSITLIST_ENDDATE:endDate?:@""
                                     }
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3DepositList
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark -
- (NSMutableDictionary *)doSometiongMasks {
    return _doSometiongMasks ?: (_doSometiongMasks = [NSMutableDictionary dictionary]);
}

//开始请求前可能会做一些比较费时的事，比如图像压缩，数据转换,使用该方法在后台进行
//block为长时间处理事情的block,当处理完成并且没有取消服务，则会调用completedBlock
- (void)_doSometiongInBackgroud:(void(^)(void))block
             beforeStartService:(ServiceRequestType)type
                 completedBlock:(void(^)(void))completedBlock
{
    NSString * token = getUniqueID();
    [self.doSometiongMasks setObject:token forKey:@(type)];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        if (block) {
            block();
        }

        dispatch_async(dispatch_get_main_queue(), ^{

            //没有取消
            if ([self.doSometiongMasks[@(type)] isEqualToString:token]) {
                [self.doSometiongMasks removeObjectForKey:@(type)];

                if (completedBlock) {
                    completedBlock();
                }
            }
        });
    });
}

- (NSString *)uniqueID {
    return _uniqueID ?: (_uniqueID = getUniqueID());
}

- (NSString *)_keyForSerivceType:(ServiceRequestType)type {
    return [NSString stringWithFormat:@"%@_%d",self.uniqueID,(int)type];
}


- (void)_startServiceWithAPIName:(NSString *)apiName
                      pathFormat:(NSString *)pathFormat
                   pathArguments:(NSArray *)pathArguments
                 headerArguments:(NSDictionary *)headerArguments
                  queryArguments:(NSDictionary *)queryArguments
                   bodyArguments:(id)bodyArguments
                        httpType:(HTTPRequestType)httpType
                     serviceType:(ServiceRequestType)type
                       scopeType:(ServiceScopeType)scopeType
{
    NSMutableDictionary *queryArgs = [NSMutableDictionary dictionary] ;
    
    if (queryArguments.count){
        [queryArgs addEntriesFromDictionary:queryArguments] ;
    }

    if ([SITE_TYPE isEqualToString:@"integratedv3oc"]){
        [queryArgs setValue:@"app_ios" forKey:RH_SP_COMMON_V3_OSTYPE] ;
        if ([THEME isEqualToString:@"pink.skin"]){
            [queryArgs setValue:@"blue" forKey:RH_SP_COMMON_V3_THEME] ;
        }else if ([THEME isEqualToString:@"blue.skin"]){
            [queryArgs setValue:@"blue" forKey:RH_SP_COMMON_V3_THEME] ;
        }else{
            [queryArgs setValue:@"white" forKey:RH_SP_COMMON_V3_THEME] ;
        }
        
        [queryArgs setValue:RH_SP_COMMON_V3_VERSION_VALUE forKey:RH_SP_COMMON_V3_VERSION] ;
        CLScreenSizeType screenType = mainScreenType();
        switch (screenType) {
            case CLScreenSizeTypeBig:
                [queryArgs setValue:@"3x" forKey:RH_SP_COMMON_V3_RESOLUTION] ;
                break;
            default:
                [queryArgs setValue:@"2x" forKey:RH_SP_COMMON_V3_RESOLUTION] ;
                break;
        }
    }
    
    RH_HTTPRequest * httpRequest = [[RH_HTTPRequest alloc] initWithAPIName:apiName
                                                                pathFormat:pathFormat
                                                             pathArguments:pathArguments
                                                            queryArguments:queryArgs
                                                           headerArguments:headerArguments
                                                             bodyArguments:bodyArguments
                                                                      type:httpType];
    
    httpRequest.timeOutInterval = _timeOutInterval ;

    //开始请求
    [self _startHttpRequest:httpRequest forType:type scopeType:scopeType];
}


- (void)_startFormDataServiceWithDatas:(NSString *)apiName
                            pathFormat:(NSString *)pathFormat
                         pathArguments:(NSArray *)pathArguments
                       headerArguments:(NSDictionary *)headerArguments
                        queryArguments:(NSDictionary *)queryArguments
                           serviceType:(ServiceRequestType)type
                             scopeType:(ServiceScopeType)scopeType
                                 Datas:(NSArray *)datas
{
//    NSMutableDictionary *queryArgs = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",RH_SP_OSTYPE,RH_CURRENT_VERSION,RH_SP_VERSION,getDeviceID(),RH_SP_DEVICEID, nil] ;
    NSMutableDictionary *queryArgs = [NSMutableDictionary dictionary] ;

    if (queryArguments.count){
        [queryArgs addEntriesFromDictionary:queryArguments] ;
    }

    RH_HTTPRequest *httpRequest = [[RH_HTTPRequest alloc] initWithFromDataAPIName:apiName
                                                                       pathFormat:pathFormat
                                                                    pathArguments:pathArguments
                                                                   queryArguments:queryArgs
                                                                  headerArguments:headerArguments] ;
    
    httpRequest.timeOutInterval = _timeOutInterval ;

    for (id data in datas) {
        if ([data isKindOfClass:[NSData class]]) {
            [httpRequest addData:data fileName:@"image.jpg"  contentType:@"image/jpeg" forKey:@"myfile"];
        }else if ([data isKindOfClass:[UIImage class]]) {
            [httpRequest addImage:data imageName:@"image.jpg" forKey:@"myfile"];
        }
    }

    [self _startHttpRequest:httpRequest forType:type scopeType:scopeType] ;
}


- (void)_startHttpRequest:(RH_HTTPRequest *)httpRequest
                  forType:(ServiceRequestType)type
                scopeType:(ServiceScopeType)scopeType
{
    [self cancleServiceWithType:type];

    NSValue * key = @(type);
    [self.httpRequests setObject:httpRequest forKey:key];
    [self.requestingMarks setObject:@(YES) forKey:key];

    //开始请求
    httpRequest.delegate = self;
    [httpRequest startRequestWithContext:[[RH_ServiceRequestContext alloc] initWithSerivceType:type scopeType:scopeType]];
}

#pragma mark -
- (void)dealloc
{
    _delegate = nil;
    [self cancleAllServices];
}

#pragma mark -
- (NSMutableDictionary *)httpRequests {
    return _httpRequests ?: (_httpRequests = [NSMutableDictionary dictionary]);
}

- (NSMutableDictionary *)requestingMarks {
    return _requestingMarks ?: (_requestingMarks = [NSMutableDictionary dictionary]);
}

- (void)cancleAllServices
{
    for (RH_HTTPRequest * httpRequest in _httpRequests.allValues) {
        httpRequest.delegate = nil;
        [httpRequest cancleRequest];
    }

    [_httpRequests removeAllObjects];
    [_requestingMarks removeAllObjects];
    [_contexts removeAllObjects];
    [_doSometiongMasks removeAllObjects];
}

- (void)cancleServiceWithType:(ServiceRequestType)serivceType
{
    NSValue * key = @(serivceType);

    if (_requestingMarks[key]) {

        //取消请求
        RH_HTTPRequest * httpRequest = _httpRequests[key];
        if (httpRequest) {
            httpRequest.delegate = nil;
            [httpRequest cancleRequest];
            [_httpRequests removeObjectForKey:key];
        }

        //移除请求掩码
        [_requestingMarks removeObjectForKey:key];

        //移除上下文
        [self removeContextForType:serivceType];
    }

    [_doSometiongMasks removeObjectForKey:key];
}

- (BOOL)isRequesting {
    return  _requestingMarks.count != 0 || _doSometiongMasks.count != 0;
}

- (BOOL)isRequestingWithType:(ServiceRequestType)serivceType {
    return _requestingMarks[@(serivceType)] || _doSometiongMasks[@(serivceType)];
}

- (NSUInteger)requestsCount {
    return _requestingMarks.count + _doSometiongMasks.count;
}

#pragma mark- property
- (NSMutableDictionary *)contexts {
    return _contexts ?: (_contexts = [NSMutableDictionary dictionary]);
}

- (void)setContext:(id)context forType:(ServiceRequestType)serivceType
{
    if (context == nil) {
        [self removeContextForType:serivceType];
    }else{
        [self.contexts setObject:context forKey:@(serivceType)];
    }
}

- (id)contextForType:(ServiceRequestType)serivceType {
    return [_contexts objectForKey:@(serivceType)];
}

- (void)removeContextForType:(ServiceRequestType)serivceType {
    [_contexts removeObjectForKey:@(serivceType)];
}

#pragma mark - Handle request
- (BOOL)httpRequest:(id<CLHTTPRequestProtocol>)request
           response:(NSHTTPURLResponse *)response
         handleData:(id)data
         reslutData:(__autoreleasing id *)reslutData
              error:(NSError *__autoreleasing *)error
{
    RH_ServiceRequestContext * context = [request context];
    ServiceRequestType type = context.serivceType;

    if (type == ServiceRequestTypeDomainCheck)
    {//处理结果数据
        NSData *tmpData = ConvertToClassPointer(NSData, data) ;
        NSString *tmpResult = [tmpData mj_JSONString] ;
        
        if ([[tmpResult lowercaseString] containsString:@"ok"]){ //域名响应ok
            NSString* reqUrl = response.URL.absoluteString.lowercaseString;
            if ([reqUrl hasPrefix:@"https://"]) {
                *reslutData = @(YES) ;
            }else{
                *reslutData = @(NO) ;
            }
        }else{
            *error = [NSError resultDataNoJSONError] ;
        }
        return YES ;
    }else if (type == ServiceRequestTypeGetCustomService){
        NSData *tmpData = ConvertToClassPointer(NSData, data) ;
        NSString *tmpResult = [tmpData mj_JSONString] ;
        if ([tmpResult.lowercaseString hasPrefix:@"http://"] || [tmpResult.lowercaseString hasPrefix:@"https://"]){
            *reslutData = tmpResult ;
            RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
            [appDelegate updateServicePath:[tmpResult stringByReplacingOccurrencesOfString:@"\n" withString:@""]] ;
        }else{
            *error = [NSError resultDataNoJSONError] ;
        }
        
        return YES ;
    }else if (type == ServiceRequestTypeDemoLogin){//处理结果数据
        NSData *tmpData = ConvertToClassPointer(NSData, data) ;
        NSString *tmpResult = [tmpData mj_JSONString] ;
        
        if ([[tmpResult lowercaseString] containsString:@"true"]){ //域名响应ok
            *reslutData = @(YES) ;
            
            if ([SITE_TYPE isEqualToString:@"integratedv3oc"]){
                [self startV3UserInfo] ;
                [self startV3MineLinkInfo] ;
            }
            
        }else{
            *reslutData = @(NO) ;
        }
        return YES ;
    }else if (type == ServiceRequestTypeObtainVerifyCode){
        NSData *tmpData = ConvertToClassPointer(NSData, data) ;
        UIImage *image = [[UIImage alloc] initWithData:tmpData] ;
        *reslutData = image ;
        return YES ;
        
    }else if (type == ServiceRequestTypeTestUrl){
        NSData *tmpData = ConvertToClassPointer(NSData, data) ;
        NSString *tmpResult = [tmpData mj_JSONString] ;
        NSLog(@"%@",tmpResult) ;
    }else if (type == ServiceRequestTypeAPIRetrive){ //游戏 回收api
        NSError * tempError = nil;
        NSDictionary * dataObject = [data length] ? [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
                                                                                      error:&tempError] : @{};
        *reslutData = @([dataObject boolValueForKey:@"isSuccess"]) ;
        return YES ;
    }

    //json解析
    NSError * tempError = nil;
    NSDictionary * dataObject = [data length] ? [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
                                                                                  error:&tempError] : @{};
    if (tempError) { //json解析错误
        tempError = [NSError resultErrorWithURLResponse:response]?:[NSError resultDataNoJSONError];
    }else{
        if ([SITE_TYPE isEqualToString:@"integratedv3oc"]){
            if ([dataObject integerValueForKey:RH_GP_V3_ERROR defaultValue:0]!=0) { //结果错误
                tempError = [NSError resultErrorWithResultInfo:dataObject];
            }
        }
    }

    if (error) {
        *error = tempError;
    }

    //结果成功，开始处理数据
    if (tempError == nil) {

        id resultSendData = nil;
        switch (type) {
            case ServiceRequestTypeDomainList:
            {
                resultSendData = ConvertToClassPointer(NSArray, dataObject) ;
            }
                break ;
                
            case ServiceRequestTypeUpdateCheck:
            {
                resultSendData = [[RH_UpdatedVersionModel alloc] initWithInfoDic:ConvertToClassPointer(NSDictionary, dataObject)] ;
            }
                break ;
              
           case ServiceRequestTypeUserLogin:
           case ServiceRequestTypeUserAutoLogin:
            {
                resultSendData = ConvertToClassPointer(NSDictionary, dataObject) ;
                
                if ([SITE_TYPE isEqualToString:@"integratedv3oc"] &&
                    [ConvertToClassPointer(NSDictionary, resultSendData) boolValueForKey:@"success" defaultValue:FALSE]){
                    [self startV3UserInfo] ;
                    [self startV3MineLinkInfo] ;
                }
            }
                break ;
                
           case ServiceRequestTypeTestUrl:
            {
                resultSendData = ConvertToClassPointer(NSDictionary, dataObject) ;
            }
                break ;
              
           case ServiceRequestTypeV3HomeInfo:
            {
                resultSendData = [[RH_HomePageModel alloc] initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
            }
                break ;
           
           case ServiceRequestTypeV3UserInfo:
            {
                resultSendData = [[RH_UserBalanceGroupModel alloc] initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
                
                if (resultSendData){
                    RH_UserInfoManager *userInfoManager = [RH_UserInfoManager shareUserManager] ;
                    [userInfoManager setUserBalanceInfo:resultSendData] ;
                }
            }
                break ;
            
            case ServiceRequestTypeV3MineGroupInfo:
            {
                resultSendData = [[RH_MineGroupInfoModel alloc] initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
                
                if (resultSendData){
                    RH_UserInfoManager *userInfoManager = [RH_UserInfoManager shareUserManager] ;
                    [userInfoManager setMineGroupInfo:resultSendData] ;
                }
            }
                break ;
            
            case ServiceRequestTypeV3APIGameList:
            {
                NSArray *tmpArray = [RH_LotteryInfoModel dataArrayWithInfoArray:[[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA] arrayValueForKey:RH_GP_APIGAMELIST_LIST]] ;
                NSInteger total = [[[[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]
                                     dictionaryValueForKey:@"page"] dictionaryValueForKey:@"page"] integerValueForKey:RH_GP_APIGAMELIST_TOTALCOUNT]   ;
                
                resultSendData = @{RH_GP_APIGAMELIST_LIST:tmpArray?:@[],
                                   RH_GP_APIGAMELIST_TOTALCOUNT:@(total)
                                   } ;
            }
                break ;
            
            case ServiceRequestTypeV3BettingList:
            {
                NSArray *tmpArray = [RH_BettingInfoModel dataArrayWithInfoArray:[[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA] arrayValueForKey:RH_GP_BETTINGLIST_LIST]] ;
                NSInteger total = [[[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]
                                     dictionaryValueForKey:@"statisticsData"]  integerValueForKey:RH_GP_BETTINGLIST_TOTALCOUNT]   ;
                
                resultSendData = @{RH_GP_BETTINGLIST_LIST:tmpArray?:@[],
                                   RH_GP_BETTINGLIST_TOTALCOUNT:@(total)
                                   } ;
            }
                break ;
                
            default:
                resultSendData = dataObject ;

                break;
        }

        *reslutData = resultSendData;
    }

    return YES;
}

- (void)httpRequest:(id<CLHTTPRequestProtocol>)request response:(NSHTTPURLResponse *)response didFailedRequestWithError:(NSError *)error
{
    RH_ServiceRequestContext * context = [request context];

    //移除标记
    [self.httpRequests removeObjectForKey:@(context.serivceType)];
    [self.requestingMarks removeObjectForKey:@(context.serivceType)];

    //发送通知
    [self _sendFailMsgWithError:error
                    serviceType:context.serivceType
                      scopeType:context.scopeType];
}

- (void)_sendFailMsgWithError:(NSError *)error
                  serviceType:(ServiceRequestType)serviceType
                    scopeType:(ServiceScopeType)scopeType
{
    //发消息给代理
    id<RH_ServiceRequestDelegate> delegate = self.delegate;
    ifRespondsSelector(delegate, @selector(serviceRequest:serviceType:didFailRequestWithError:)){
        [delegate serviceRequest:self serviceType:serviceType didFailRequestWithError:error];
    }

    //block回调
    if (self.failBlock) {
        self.failBlock(self, serviceType, error);
    }

    //移除上下文
    [self removeContextForType:serviceType];
}

- (void)httpRequest:(id<CLHTTPRequestProtocol>)request didSuccessRequestWithResultData:(id)reslutData
{
    RH_ServiceRequestContext * context = [request context];

    //移除请求及标记
    [self.httpRequests removeObjectForKey:@(context.serivceType)];
    [self.requestingMarks removeObjectForKey:@(context.serivceType)];

    //发送成功通知
    [self _sendSuccessMsgWithData:reslutData type:context.serivceType];
}

- (void)_sendSuccessMsgWithData:(id)data type:(ServiceRequestType)type
{
    //发消息给代理
    id<RH_ServiceRequestDelegate> delegate = self.delegate;
    ifRespondsSelector(delegate, @selector(serviceRequest:serviceType:didSuccessRequestWithData:)) {
        [delegate serviceRequest:self serviceType:type didSuccessRequestWithData:data];
    }

    //block回调
    if (self.successBlock) {
        self.successBlock(self, type, data);
    }

    //移除上下文
    [self removeContextForType:type];
}

@end
