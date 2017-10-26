//
//  URLSessionManager.m
//  CoreLib
//
//  Created by jinguihua on 2016/12/5.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "URLSessionManager.h"
#import "MacroDef.h"
#import "CLWeakDelegate.h"

#pragma mark- _URLSessionDelegateForBlock
@interface _URLSessionDelegateForBlock : NSObject <URLSessionManagerDelegate>

+ (NSMutableSet *)delegateSet;

+ (instancetype)createDelegateWithCompletionHander:(CLURLSessionCompletionBlcok)completionHander;
- (id)initWithCompletionHander:(CLURLSessionCompletionBlcok)completionHander;

@property(nonatomic,copy,readonly) CLURLSessionCompletionBlcok completionHander;

@end

//----------------------------------------------------------

@implementation _URLSessionDelegateForBlock

+ (NSMutableSet *)delegateSet
{
    static NSMutableSet * delegateSet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        delegateSet = [NSMutableSet set];
    });

    return delegateSet;
}

+ (instancetype)createDelegateWithCompletionHander:(CLURLSessionCompletionBlcok)completionHander
{
    _URLSessionDelegateForBlock * delegate = [[self alloc] initWithCompletionHander:completionHander];
    [[self delegateSet] addObject:delegate];

    return delegate;
}

- (id)initWithCompletionHander:(CLURLSessionCompletionBlcok)completionHander
{
    self = [super init];
    if (self) {
        _completionHander = completionHander;
    }

    return self;
}

- (void)urlSessionManager:(URLSessionManager *)manager
                  connection:(NSURLSession *)urlSession
                    response:(NSURLResponse *)response
            didFailWithError:(NSError *)error
{
    [[[self class] delegateSet] removeObject:self];

    if (self.completionHander) {
        self.completionHander(response, nil, error);
    }
}

- (void)urlSessionManager:(URLSessionManager *)manager
                  connection:(NSURLSession *)urlSession
                    response:(NSURLResponse *)response
        didFinishLoadingData:(NSData *)data
{
    [[[self class] delegateSet] removeObject:self];

    if (self.completionHander) {
        self.completionHander(response,data,nil);
    }
}

@end

#pragma mark- _URLSessionData
@interface _URLSessionData : NSObject

- (id)initWithDelegate:(id<URLSessionManagerDelegate>)delegate URLConnection:(NSURLSessionTask *)urlSessionTask ;

@property(nonatomic,strong,readonly) CLWeakDelegate<id<URLSessionManagerDelegate>> * delegate;
@property(nonatomic,strong,readonly) NSURLSessionTask      * urlSessionTask ;
@property(nonatomic,strong,readonly) NSMutableData         * resultData ;
@property(nonatomic,strong)          NSDate                * lastSendDataDate;
@property(nonatomic,strong,readonly) NSDate                * lastReceiveDataDate;
@property(nonatomic,readonly) long long expectedDataLength;
@property(nonatomic,readonly) NSURLResponse * response;


//收到响应
- (void)receiveResponse:(NSURLResponse *)response;

//返回接收数据的速度byte/s
- (NSUInteger)receiveData:(NSData *)data;

//返回发送速度byte/s
- (NSInteger)speedForSendData:(NSUInteger)bytesWritten;
@end

//----------------------------------------------------------

@implementation _URLSessionData

- (id)initWithDelegate:(id<URLSessionManagerDelegate>)delegate URLConnection:(NSURLSessionTask *)urlSessionTask
{
    if (self = [super init]) {

        _delegate = [[CLWeakDelegate alloc] initWithDelegate:delegate];
        _urlSessionTask  = urlSessionTask ;
        _resultData = [NSMutableData data];
    }

    return self;
}

- (void)receiveResponse:(NSURLResponse *)response {
    _response = response;
}

- (long long)expectedDataLength {
    return _response ? _response.expectedContentLength : NSURLResponseUnknownLength;
}

- (NSInteger)speedForSendData:(NSUInteger)bytesWritten
{
    NSUInteger sendDataSpeed = 0;
    NSDate * now =  [NSDate date];

    //计算速度
    if (_lastSendDataDate) {

        //        NSLog(@"bytesWritten = %i , time = %f",(int)bytesWritten ,[now timeIntervalSinceDate:_lastSendDataDate]);

        sendDataSpeed = bytesWritten / [now timeIntervalSinceDate:_lastSendDataDate];

        //        NSLog(@" bytesWritten = %i speed = %i byte/s ",(int)bytesWritten,(int)sendDataSpeed);
    }

    //记录时间
    _lastSendDataDate = now;

    return sendDataSpeed;
}

- (NSUInteger)receiveData:(NSData *)data
{
    NSUInteger receiveDataSpeed = 0;
    NSDate * now =  [NSDate date];

    //计算速度
    if (_lastReceiveDataDate) {
        receiveDataSpeed = data.length / [now timeIntervalSinceDate:_lastReceiveDataDate];
    }

    //记录时间
    _lastReceiveDataDate = now;

    //扩充数据
    [_resultData appendData:data];

    return receiveDataSpeed;
}


@end


#pragma mark- URLSessionManager
@interface URLSessionManager()<NSURLSessionDelegate,NSURLSessionDataDelegate>
@property(nonatomic,strong,readonly) NSURLSession *urlSessionForDataTasks ; //管理一般数据请求session
@end


@implementation URLSessionManager
{
    //代理到数据的映射表
    NSMutableDictionary    *_delegateToDataDicMap;
    //URL连接到数据的映射表
    NSMutableDictionary    *_urlConnectionToDataMap;
}
@synthesize urlSessionForDataTasks  = _urlSessionForDataTasks ;

#pragma mark -

+ (URLSessionManager *)defaultManager
{
    static URLSessionManager * defaultManager = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [URLSessionManager new];
    });


    return defaultManager;
}

- (id)init
{
    if (self = [super init]) {
        _delegateToDataDicMap = [NSMutableDictionary dictionary];
        _urlConnectionToDataMap = [NSMutableDictionary dictionary];
    }

    return self;
}

-(NSURLSession*)urlSessionForDataTasks
{
    if (!_urlSessionForDataTasks){
        _urlSessionForDataTasks = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                                delegate:self
                                                           delegateQueue:[NSOperationQueue mainQueue]] ;
    }

    return _urlSessionForDataTasks ;
}

#pragma mark -

//移除连接数据
#define AddSessionTaskData(sessionData)                                                         \
{                                                                                                  \
[_urlConnectionToDataMap setObject:sessionData forKey:NSNumberWithPointer(urlSessionDataTask)];    \
id<NSCopying> delegateKey = sessionData.delegate.delegateKey;                                      \
NSMutableDictionary *dataDic = [_delegateToDataDicMap objectForKey:delegateKey];                   \
if (dataDic == nil) {                                                                              \
    dataDic = [NSMutableDictionary dictionary];                                                    \
    [_delegateToDataDicMap setObject:dataDic forKey:delegateKey];                                  \
}                                                                                                  \
[dataDic setObject:sessionData forKey:NSNumberWithPointer(sessionData)];                           \
}

//移除连接数据
#define RemoveSessionTaskData(sessionData)                                                        \
{                                                                                                   \
[_urlConnectionToDataMap removeObjectForKey:NSNumberWithPointer(sessionData.urlSessionTask)]; \
id<NSCopying> delegateKey = sessionData.delegate.delegateKey;                                \
NSMutableDictionary *dataDic = [_delegateToDataDicMap objectForKey:delegateKey];                \
[dataDic removeObjectForKey:NSNumberWithPointer(sessionData)];                               \
if (dataDic.count == 0) {                                                                       \
[_delegateToDataDicMap removeObjectForKey:delegateKey];                                     \
}                                                                                               \
}


- (id<URLSessionManagerDelegate>)startConnectionWithRequest:(NSURLRequest *)request
                                              completionHander:(CLURLSessionCompletionBlcok)completionHander
{
    _URLSessionDelegateForBlock * delegate = [_URLSessionDelegateForBlock createDelegateWithCompletionHander:completionHander];
    [self startConnection:delegate request:request];

    return delegate;
}

- (void)startConnection:(id<URLSessionManagerDelegate>)delegate request:(NSURLRequest *)request
{
    if (request == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"请求不能为nil"
                                     userInfo:nil];
    }

    NSURLSessionDataTask *urlSessionDataTask = [self.urlSessionForDataTasks dataTaskWithRequest:request] ;


    if (urlSessionDataTask) {

        _URLSessionData *sessionData  = [[_URLSessionData alloc] initWithDelegate:delegate URLConnection:urlSessionDataTask];

        //记录数据
        AddSessionTaskData(sessionData);

        //开始连接,主线程回调
        [urlSessionDataTask resume] ;
    }
}

- (NSData *)startSynchronousRequest:(NSURLRequest *)request
                  returningResponse:(NSURLResponse **)pResponse
                              error:(NSError **)pError
{
    if (request == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"请求不能为nil"
                                     userInfo:nil];
    }


//    return [NSURLConnection sendSynchronousRequest:request returningResponse:pResponse error:pError] ;

    //创建一个信号
    dispatch_semaphore_t  semaphore = dispatch_semaphore_create(0) ;//创量信号量
    NSMutableData *receData = [NSMutableData data] ;
    NSURLSession *shareURLSession = [NSURLSession sharedSession] ;
    NSURLSessionDataTask *task = [shareURLSession dataTaskWithRequest:request
                                                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                        (*pResponse) = response ;
                                                        (*pError) = error ;
                                                        if (data.length){
                                                            [receData appendData:data] ;
                                                        }

                                                        dispatch_semaphore_signal(semaphore) ;
                                                    }] ;

    [task resume] ;
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) ;

    if (receData.length){
        return [NSData dataWithData:receData] ;
    }

    return nil ;

}

#pragma mark -

- (void)cancleConnection:(id<URLSessionManagerDelegate>)delegate {
    [self cancleConnection:delegate request:nil removeAll:YES];
}

- (void)cancleConnection:(id<URLSessionManagerDelegate>)delegate request:(NSURLRequest *)request removeAll:(BOOL)removeAll
{
    id<NSCopying> delegateKey = [CLWeakDelegate keyForDelegate:delegate];

    NSMutableDictionary *dataDic = [_delegateToDataDicMap objectForKey:delegateKey];
    if (dataDic) {

        for (_URLSessionData *connectionData  in dataDic.allValues) {

            if (request == nil || [[connectionData.urlSessionTask currentRequest] isEqual:request]) {

                [connectionData.urlSessionTask cancel];
                [_urlConnectionToDataMap removeObjectForKey:NSNumberWithPointer(connectionData.urlSessionTask)];

                [dataDic removeObjectForKey:NSNumberWithPointer(connectionData)];

                if (!removeAll){
                    break;
                }
            }
        }

        //无元素则移除
        if (dataDic.count == 0) {
            [_delegateToDataDicMap removeObjectForKey:delegateKey];
        }
    }

    if ([delegate isKindOfClass:[_URLSessionDelegateForBlock class]]) {
        [[_URLSessionDelegateForBlock delegateSet] removeObject:delegate];
    }
}

- (void)cancleAllConnection
{
    for (_URLSessionData *connectionData  in _urlConnectionToDataMap.allValues) {
        [connectionData.urlSessionTask cancel];
    }

    [_urlConnectionToDataMap removeAllObjects];
    [_delegateToDataDicMap removeAllObjects];
    [[_URLSessionDelegateForBlock delegateSet] removeAllObjects];

}

#pragma mark -
- (void)            URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
               didSendBodyData:(int64_t)bytesSent
                totalBytesSent:(int64_t)totalBytesSent
      totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    _URLSessionData *connectionData  = [_urlConnectionToDataMap objectForKey:NSNumberWithPointer(task)];

    if (connectionData) {

        id<URLSessionManagerDelegate> delegate = connectionData.delegate.delegate;
        ifRespondsSelector(delegate, @selector(urlSessionManager:connection:didSendHTTPBodyDataLength:expectedDataLength:sendDataSpeed:)){

            [delegate urlSessionManager:self
                             connection:task
              didSendHTTPBodyDataLength:totalBytesSent
                     expectedDataLength:totalBytesExpectedToSend
                          sendDataSpeed:[connectionData speedForSendData:(NSUInteger)bytesSent]] ;
        }
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
                didReceiveResponse:(NSURLResponse *)response
            completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    _URLSessionData *connectionData  = [_urlConnectionToDataMap objectForKey:NSNumberWithPointer(dataTask)];

    if (connectionData) {

        id<URLSessionManagerDelegate> delegate = connectionData.delegate.delegate;
        ifRespondsSelector(delegate, @selector(urlSessionManager:connection:didReceiveResponse:))  {
            [delegate urlSessionManager:self
                             connection:dataTask
                     didReceiveResponse:response] ;
        }

        [connectionData receiveResponse:response];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
                    didCompleteWithError:(nullable NSError *)error
{
    _URLSessionData *connectionData = [_urlConnectionToDataMap objectForKey:NSNumberWithPointer(task)];

    if (connectionData) {
        //移除请求数据
        RemoveSessionTaskData(connectionData);

        id<URLSessionManagerDelegate> delegate = connectionData.delegate.delegate;
        if (error){
            //发送错误消息
            ifRespondsSelector(delegate, @selector(urlSessionManager:connection:response:didFailWithError:)) {
                [delegate urlSessionManager:self
                                 connection:task
                                   response:task.response
                           didFailWithError:error] ;
            }
        }else{
            //发送成功请求
            id<URLSessionManagerDelegate> delegate = connectionData.delegate.delegate;
            ifRespondsSelector(delegate, @selector(urlSessionManager:connection:response:didFinishLoadingData:)) {
                [delegate urlSessionManager:self
                                 connection:task
                                   response:task.response
                       didFinishLoadingData:connectionData.resultData] ;

            }
        }
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
                    didReceiveData:(NSData *)data
{
    _URLSessionData *connectionData  = [_urlConnectionToDataMap objectForKey:NSNumberWithPointer(dataTask)];

    if (connectionData ) {

        NSUInteger speed = [connectionData receiveData:data];

        id<URLSessionManagerDelegate> delegate = connectionData.delegate.delegate;
        ifRespondsSelector(delegate, @selector(urlSessionManager:connection:didReceiveDataLength:expectedDataLength:receiveDataSpeed:)){

            [delegate urlSessionManager:self
                             connection:dataTask
                   didReceiveDataLength:dataTask.countOfBytesReceived
                     expectedDataLength:dataTask.countOfBytesExpectedToReceive
                       receiveDataSpeed:speed] ;


        }
    }
}



- (NSArray *)connectionsForDelegate:(id<URLSessionManagerDelegate>)delegate {
    return [NSArray arrayWithArray:[_delegateToDataDicMap objectForKey:[CLWeakDelegate keyForDelegate:delegate]]];
}

#pragma mark -

////#warning 证书验证
//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
//    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
//}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
            completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    if ([challenge previousFailureCount] == 0){
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    }else{
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

@end

