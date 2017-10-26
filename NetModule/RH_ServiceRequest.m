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
//- (void)startLogin:(NSString*)userName Password:(NSString*)password
//{
//    [self _startServiceWithAPIName:RH_API_MAIN_URL
//                        pathFormat:RH_API_NAME_USERLOGIN
//                     pathArguments:nil
//                   headerArguments:nil
//                    queryArguments:@{RH_SP_USERLOGIN_USERNAME:userName?:@"",
//                                     RH_SP_USERLOGIN_PASSWORD:password?:@""}
//                     bodyArguments:nil
//                          httpType:HTTPRequestTypePost
//                       serviceType:ServiceRequestTypeLogin
//                         scopeType:ServiceScopeTypePublic] ;
//}

-(void)startReqDomainList
{
    [self _startServiceWithAPIName:RH_API_MAIN_URL
                        pathFormat:@"app/line.html"
                     pathArguments:nil
                   headerArguments:nil
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
                        pathFormat:isIgnoreHTTPS(doMain)?@"http://%@/__check":@"https://%@/__check"
                     pathArguments:@[doMain?:@""]
                   headerArguments:nil
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
                   headerArguments:nil
                    queryArguments:@{RH_SP_COMMON_OSTYPE:@"ios",
                                     RH_SP_COMMON_MD5KEY:RH_APP_MD5VALUE,
                                     RH_SP_COMMON_VERSION:RH_APP_VERSION
                                     }
                     bodyArguments:nil
                          httpType:HTTPRequestTypeGet
                       serviceType:ServiceRequestTypeUpdateCheck
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

//    NSMutableDictionary *queryArgs = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",RH_SP_OSTYPE,RH_CURRENT_VERSION,RH_SP_VERSION,getDeviceID(),RH_SP_DEVICEID, nil] ;
    NSMutableDictionary *queryArgs = [NSMutableDictionary dictionary] ;

    if (queryArguments.count){
        [queryArgs addEntriesFromDictionary:queryArguments] ;
    }

    RH_HTTPRequest * httpRequest = [[RH_HTTPRequest alloc] initWithAPIName:apiName
                                                                pathFormat:pathFormat
                                                             pathArguments:pathArguments
                                                            queryArguments:queryArgs
                                                           headerArguments:headerArguments
                                                             bodyArguments:bodyArguments
                                                                      type:httpType];

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

    if (type == ServiceRequestTypeDomainCheck) {//处理结果数据
        NSData *tmpData = ConvertToClassPointer(NSData, data) ;
        *reslutData = [tmpData mj_JSONString] ;
        return YES ;
    }else if (type == ServiceRequestTypeUpdateCheck) {
        *reslutData = data ;
        return YES ;
    }

    //json解析
    NSError * tempError = nil;
    NSDictionary * dataObject = [data length] ? [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
                                                                                  error:&tempError] : @{};
    if (tempError) { //json解析错误
        tempError = [NSError resultDataNoJSONError];
    }
//    else if ([dataObject integerValueForKey:RH_GP_SUCCESS defaultValue:-1]!=0) { //结果错误
//        tempError = [NSError resultErrorWithResultInfo:dataObject];
//    }

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

//            case ServiceRequestTypeFirstPage:
//            {
//                RH_FirstPageModel *firstPageModel = [[RH_FirstPageModel alloc] initWithInfoDic:[dataObject dictionaryValueForKey:RH_GP_COMMON_DATA]] ;
//                NSArray *list = [RH_TaskModel dataArrayWithInfoArray:[[[dataObject dictionaryValueForKey:RH_GP_COMMON_DATA]
//                                                                       dictionaryValueForKey:RH_GP_HOMEPAGE_PAGELIST]
//                                                                      arrayValueForKey:RH_GP_COMMON_DATALIST]] ;
//
//                NSInteger totalCount = [[[dataObject dictionaryValueForKey:RH_GP_COMMON_DATA] dictionaryValueForKey:RH_GP_HOMEPAGE_PAGELIST] integerValueForKey:RH_GP_COMMON_TOTALCOUNT] ;
//                resultSendData = @{RH_GP_COMMON_DATALIST:list?:@[],
//                                   RH_GP_COMMON_TOTALCOUNT:@(totalCount),
//                                   RH_GP_COMMON_DATA:firstPageModel?:@""} ;
//
//            }
//                break;

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
