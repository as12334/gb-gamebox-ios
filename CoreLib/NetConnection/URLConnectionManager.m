//
//  URLConnectionManager.m
//  CoreLib
//
//  Created by apple pro on 2016/11/18.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "URLConnectionManager.h"
#import "MacroDef.h"
#import "CLWeakDelegate.h"

#pragma mark- _URLConnectionDelegateForBlock
@interface _URLConnectionDelegateForBlock : NSObject <URLConnectionManagerDelegate>

+ (NSMutableSet *)delegateSet;

+ (instancetype)createDelegateWithCompletionHander:(CLURLConnectionCompletionBlcok)completionHander;
- (id)initWithCompletionHander:(CLURLConnectionCompletionBlcok)completionHander;

@property(nonatomic,copy,readonly) CLURLConnectionCompletionBlcok completionHander;

@end

//----------------------------------------------------------

@implementation _URLConnectionDelegateForBlock

+ (NSMutableSet *)delegateSet
{
    static NSMutableSet * delegateSet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        delegateSet = [NSMutableSet set];
    });

    return delegateSet;
}

+ (instancetype)createDelegateWithCompletionHander:(CLURLConnectionCompletionBlcok)completionHander
{
    _URLConnectionDelegateForBlock * delegate = [[self alloc] initWithCompletionHander:completionHander];
    [[self delegateSet] addObject:delegate];

    return delegate;
}

- (id)initWithCompletionHander:(CLURLConnectionCompletionBlcok)completionHander
{
    self = [super init];
    if (self) {
        _completionHander = completionHander;
    }

    return self;
}

- (void)urlConnectionManager:(URLConnectionManager *)manager
                  connection:(NSURLConnection *)connection
                    response:(NSURLResponse *)response
            didFailWithError:(NSError *)error
{
    [[[self class] delegateSet] removeObject:self];

    if (self.completionHander) {
        self.completionHander(response, nil, error);
    }
}

- (void)urlConnectionManager:(URLConnectionManager *)manager
                  connection:(NSURLConnection *)connection
                    response:(NSURLResponse *)response
        didFinishLoadingData:(NSData *)data
{
    [[[self class] delegateSet] removeObject:self];

    if (self.completionHander) {
        self.completionHander(response,data,nil);
    }
}

@end

#pragma mark- _URLConnectionData
@interface _URLConnectionData : NSObject

- (id)initWithDelegate:(id<URLConnectionManagerDelegate>)delegate URLConnection:(NSURLConnection *)urlConnection;

@property(nonatomic,strong,readonly) CLWeakDelegate<id<URLConnectionManagerDelegate>> * delegate;

@property(nonatomic,strong,readonly) NSURLConnection  * urlConnection;
@property(nonatomic,strong,readonly) NSMutableData    * resultData;
@property(nonatomic,strong)          NSDate           * lastSendDataDate;
@property(nonatomic,strong,readonly) NSDate           * lastReceiveDataDate;
@property(nonatomic,readonly) long long expectedDataLength;
@property(nonatomic,readonly) NSURLResponse * response;


//收到响应
- (void)receiveResponse:(NSURLResponse *)response;

//返回接收数据的速度byte/s
- (NSUInteger)receiveData:(NSData *)data;

//返回发送速度byte/s
- (NSUInteger)speedForSendData:(NSUInteger)bytesWritten;

@end

//----------------------------------------------------------

@implementation _URLConnectionData

- (id)initWithDelegate:(id<URLConnectionManagerDelegate>)delegate URLConnection:(NSURLConnection *)urlConnection
{
    if (self = [super init]) {

        _delegate = [[CLWeakDelegate alloc] initWithDelegate:delegate];
        _urlConnection  = urlConnection;
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

- (NSUInteger)speedForSendData:(NSUInteger)bytesWritten
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


#pragma mark- URLConnectionManager
@interface URLConnectionManager()<NSURLConnectionDataDelegate>
@end

@implementation URLConnectionManager
{
    //代理到数据的映射表
    NSMutableDictionary    *_delegateToDataDicMap;
    //URL连接到数据的映射表
    NSMutableDictionary    *_urlConnectionToDataMap;
}

#pragma mark -

+ (URLConnectionManager *)defaultManager
{
    static URLConnectionManager * defaultManager = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [URLConnectionManager new];
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

#pragma mark -

//移除连接数据
#define AddConnectionData(connectionData)                                                         \
{                                                                                                 \
[_urlConnectionToDataMap setObject:connectionData forKey:NSNumberWithPointer(urlConnection)]; \
id<NSCopying> delegateKey = connectionData.delegate.delegateKey;                              \
NSMutableDictionary *dataDic = [_delegateToDataDicMap objectForKey:delegateKey];              \
if (dataDic == nil) {                                                                         \
dataDic = [NSMutableDictionary dictionary];                                               \
[_delegateToDataDicMap setObject:dataDic forKey:delegateKey];                             \
}                                                                                             \
[dataDic setObject:connectionData forKey:NSNumberWithPointer(connectionData)];                \
}

//移除连接数据
#define RemoveConnectionData(connectionData)                                                        \
{                                                                                                   \
[_urlConnectionToDataMap removeObjectForKey:NSNumberWithPointer(connectionData.urlConnection)]; \
id<NSCopying> delegateKey = connectionData.delegate.delegateKey;                                \
NSMutableDictionary *dataDic = [_delegateToDataDicMap objectForKey:delegateKey];                \
[dataDic removeObjectForKey:NSNumberWithPointer(connectionData)];                               \
if (dataDic.count == 0) {                                                                       \
[_delegateToDataDicMap removeObjectForKey:delegateKey];                                     \
}                                                                                               \
}


- (id<URLConnectionManagerDelegate>)startConnectionWithRequest:(NSURLRequest *)request
                                              completionHander:(CLURLConnectionCompletionBlcok)completionHander
{
    _URLConnectionDelegateForBlock * delegate = [_URLConnectionDelegateForBlock createDelegateWithCompletionHander:completionHander];
    [self startConnection:delegate request:request];

    return delegate;
}

- (void)startConnection:(id<URLConnectionManagerDelegate>)delegate request:(NSURLRequest *)request
{
    if (request == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"请求不能为nil"
                                     userInfo:nil];
    }


    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];

//    NSURLSession *urlSession = [[NSURLSession alloc] init];

    if (urlConnection) {

        _URLConnectionData *connectionData  = [[_URLConnectionData alloc] initWithDelegate:delegate URLConnection:urlConnection];

        //记录数据
        AddConnectionData(connectionData);

        //开始连接,主线程回调
        [urlConnection setDelegateQueue:[NSOperationQueue mainQueue]];
        [urlConnection start];
    }
}

- (NSData *)startSynchronousRequest:(NSURLRequest *)request
                  returningResponse:(NSURLResponse **)response
                              error:(NSError **)error
{
    if (request == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"请求不能为nil"
                                     userInfo:nil];
    }

    return [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
}

#pragma mark -

- (void)cancleConnection:(id<URLConnectionManagerDelegate>)delegate {
    [self cancleConnection:delegate request:nil removeAll:YES];
}

- (void)cancleConnection:(id<URLConnectionManagerDelegate>)delegate request:(NSURLRequest *)request removeAll:(BOOL)removeAll
{
    id<NSCopying> delegateKey = [CLWeakDelegate keyForDelegate:delegate];

    NSMutableDictionary *dataDic = [_delegateToDataDicMap objectForKey:delegateKey];
    if (dataDic) {

        for (_URLConnectionData *connectionData  in dataDic.allValues) {

            if (request == nil || [[connectionData .urlConnection currentRequest] isEqual:request]) {

                [connectionData.urlConnection cancel];
                [_urlConnectionToDataMap removeObjectForKey:NSNumberWithPointer(connectionData.urlConnection)];

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

    if ([delegate isKindOfClass:[_URLConnectionDelegateForBlock class]]) {
        [[_URLConnectionDelegateForBlock delegateSet] removeObject:delegate];
    }
}

- (void)cancleAllConnection
{
    for (_URLConnectionData *connectionData  in _urlConnectionToDataMap.allValues) {
        [connectionData.urlConnection cancel];
    }

    [_urlConnectionToDataMap removeAllObjects];
    [_delegateToDataDicMap removeAllObjects];
    [[_URLConnectionDelegateForBlock delegateSet] removeAllObjects];
}

#pragma mark -

- (void)            connection:(NSURLConnection *)connection
               didSendBodyData:(NSInteger)bytesWritten
             totalBytesWritten:(NSInteger)totalBytesWritten
     totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    _URLConnectionData *connectionData  = [_urlConnectionToDataMap objectForKey:NSNumberWithPointer(connection)];

    if (connectionData) {

        id<URLConnectionManagerDelegate> delegate = connectionData.delegate.delegate;
        ifRespondsSelector(delegate, @selector(urlConnectionManager:connection:didSendHTTPBodyDataLength:expectedDataLength:sendDataSpeed:)){

            [delegate urlConnectionManager:self
                                connection:connection
                 didSendHTTPBodyDataLength:totalBytesWritten
                        expectedDataLength:totalBytesExpectedToWrite
                             sendDataSpeed:[connectionData speedForSendData:bytesWritten]];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _URLConnectionData *connectionData  = [_urlConnectionToDataMap objectForKey:NSNumberWithPointer(connection)];

    if (connectionData) {

        id<URLConnectionManagerDelegate> delegate = connectionData.delegate.delegate;
        ifRespondsSelector(delegate, @selector(urlConnectionManager:connection:didReceiveResponse:))  {
            [delegate urlConnectionManager:self connection:connection didReceiveResponse:response];
        }

        [connectionData receiveResponse:response];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _URLConnectionData *connectionData = [_urlConnectionToDataMap objectForKey:NSNumberWithPointer(connection)];

    if (connectionData) {

        //移除请求数据
        RemoveConnectionData(connectionData);

        //发送错误消息
        id<URLConnectionManagerDelegate> delegate = connectionData.delegate.delegate;
        ifRespondsSelector(delegate, @selector(urlConnectionManager:connection:response:didFailWithError:)) {

            [delegate urlConnectionManager:self
                                connection:connectionData.urlConnection
                                  response:connectionData.response
                          didFailWithError:error];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    _URLConnectionData *connectionData  = [_urlConnectionToDataMap objectForKey:NSNumberWithPointer(connection)];

    if (connectionData ) {

        NSUInteger speed = [connectionData receiveData:data];

        id<URLConnectionManagerDelegate> delegate = connectionData.delegate.delegate;
        ifRespondsSelector(delegate, @selector(urlConnectionManager:connection:didReceiveDataLength:expectedDataLength:receiveDataSpeed:)){

            [delegate urlConnectionManager:self
                                connection:connection
                      didReceiveDataLength:connectionData.resultData.length
                        expectedDataLength:connectionData.expectedDataLength
                          receiveDataSpeed:speed];
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _URLConnectionData *connectionData  = [_urlConnectionToDataMap objectForKey:NSNumberWithPointer(connection)];

    if (connectionData ) {

        //移除请求
        RemoveConnectionData(connectionData);

        //发送成功消息
        id<URLConnectionManagerDelegate> delegate = connectionData.delegate.delegate;
        ifRespondsSelector(delegate, @selector(urlConnectionManager:connection:response:didFinishLoadingData:)) {

            [delegate urlConnectionManager:self
                                connection:connection
                                  response:connectionData.response
                      didFinishLoadingData:connectionData.resultData];
        }
    }
}

- (NSArray *)connectionsForDelegate:(id<URLConnectionManagerDelegate>)delegate {
    return [NSArray arrayWithArray:[_delegateToDataDicMap objectForKey:[CLWeakDelegate keyForDelegate:delegate]]];
}

#pragma mark -

//#warning 证书验证
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0){
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    }else{
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

@end
