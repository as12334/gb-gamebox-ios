//
//  CLHTTPRequest.m
//  CoreLib
//
//  Created by apple pro on 2016/11/18.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "CLHTTPRequest.h"
#import "MacroDef.h"
#import "URLConnectionManager.h"
#import "NSDictionary+CLCategory.h"
#import "help.h"
#import "RH_APPDelegate.h"

#define HttpRequestDebugLog(_format,...)  DebugLog(MyHTTPRequestDomain,_format, ##__VA_ARGS__)

@interface CLHTTPRequest ()<URLConnectionManagerDelegate>

@end

@implementation CLHTTPRequest
{
    NSString        * _requestURL;
    NSDictionary    * _headerArguments;
    NSData          * _bodyData;

    HTTPRequestType   _type;
}

@synthesize completedCallbackBlock = _completedCallbackBlock;
@synthesize delegate     = _delegate;
@synthesize requesting   = _requesting;
@synthesize urlRequest   = _urlRequest;
@synthesize context      = _context;
@synthesize timeOutInterval = _timeOutInterval ;

+ (NSString *)_pathWithFormat:(NSString *)pathFormat arguments:(NSArray *)pathArguments
{
    if (pathFormat.length == 0 || pathArguments.count == 0) {
        return pathFormat;
    }

    //查找%@字符并把其替换成数组内的内容
    NSScanner * scanner = [NSScanner scannerWithString:pathFormat];

    NSUInteger index = 0;
    NSMutableString * path = [NSMutableString string];

    NSString * scanString = nil;
    while ([scanner scanUpToString:@"%@" intoString:&scanString]) {

        [path appendString:scanString];

        if (scanner.isAtEnd) {
            break;
        }else if ([scanString hasSuffix:@"%"]) { //如果是“%%@“,则代表转义符
            [path appendString:@"@"];
        }else if(index < pathArguments.count){
            [path appendString:[pathArguments[index ++] description]];
        }else {
            [path appendString:@"%@"];
        }

        scanner.scanLocation += 2;
    }

    return path;
}

#pragma mark -

- (id)init
{
    @throw [[NSException alloc] initWithName:NSGenericException
                                      reason:@"CLHTTPRequest不支持无参数初始化"
                                    userInfo:nil];
}

- (id)initWithURL:(NSString *)url
{
    return [self initWithURL:url
                  pathFormat:nil
               pathArguments:nil
              queryArguments:nil
             headerArguments:nil
                    bodyData:nil
                        type:HTTPRequestTypeGet];
}

- (id)initWithURL:(NSString *)url                       //url
       pathFormat:(NSString *)pathFormat                //路径格式(%@)
    pathArguments:(NSArray *)pathArguments              //路径参数
   queryArguments:(NSDictionary *)queryArguments        //查询参数
  headerArguments:(NSDictionary *)headerArguments
{
    return [self initWithURL:url
                  pathFormat:pathFormat
               pathArguments:pathArguments
              queryArguments:queryArguments
             headerArguments:headerArguments
                    bodyData:nil
                        type:HTTPRequestTypeGet];
}

- (id)initWithURL:(NSString *)url                       //url
       pathFormat:(NSString *)pathFormat                //路径格式(%@)
    pathArguments:(NSArray *)pathArguments              //路径参数
  headerArguments:(NSDictionary *)headerArguments
    bodyArguments:(NSDictionary *)bodyArguments
{
    return [self initWithURL:url
                  pathFormat:pathFormat
               pathArguments:pathArguments
              queryArguments:nil
             headerArguments:headerArguments
               bodyArguments:bodyArguments
                        type:HTTPRequestTypePost];
}

- (id)initWithURL:(NSString *)url                       //url
       pathFormat:(NSString *)pathFormat                //路径格式(%@)
    pathArguments:(NSArray *)pathArguments              //路径参数
  headerArguments:(NSDictionary *)headerArguments
         bodyData:(NSData *)bodyData
{
    return [self initWithURL:url
                  pathFormat:pathFormat
               pathArguments:pathArguments
              queryArguments:nil
             headerArguments:headerArguments
                    bodyData:bodyData
                        type:HTTPRequestTypePost];
}

- (id)initWithURL:(NSString *)url
       pathFormat:(NSString *)pathFormat
    pathArguments:(NSArray *)pathArguments
   queryArguments:(NSDictionary *)queryArguments
  headerArguments:(NSDictionary *)headerArguments
    bodyArguments:(NSDictionary *)bodyArguments
             type:(HTTPRequestType)type
{
//    NSLog(@"body1参数为=%@",[[NSString alloc] initWithData:[CLHTTPRequest _dataWithBodyArguments:bodyArguments]  encoding:NSUTF8StringEncoding]);
    return [self initWithURL:url
                  pathFormat:pathFormat
               pathArguments:pathArguments
              queryArguments:queryArguments
             headerArguments:headerArguments
                    bodyData:type != HTTPRequestTypeGet ? [CLHTTPRequest _dataWithBodyArguments:bodyArguments] : nil
                        type:type];

}


- (id)initWithURL:(NSString *)url
       pathFormat:(NSString *)pathFormat
    pathArguments:(NSArray *)pathArguments
   queryArguments:(NSDictionary *)queryArguments
  headerArguments:(NSDictionary *)headerArguments
         bodyData:(NSData *)bodyData
             type:(HTTPRequestType)type
{
    return [self initWithURL:url
                        path:[CLHTTPRequest _pathWithFormat:pathFormat arguments:pathArguments]
              queryArguments:queryArguments
             headerArguments:headerArguments
                    bodyData:bodyData
                        type:type];
}


- (id)initWithURL:(NSString *)url
             path:(NSString *)path
   queryArguments:(NSDictionary *)queryArguments
  headerArguments:(NSDictionary *)headerArguments
         bodyData:(NSData *)bodyData
             type:(HTTPRequestType)type
{
    if (self = [super init]) {
        _type = type ;
        
        //扩展路径
        if (path.length) { //移除头尾的/符
            if (url.length){
                url = [url stringByAppendingFormat:@"/%@",[path stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]]];
            }else{
               url = [@"" stringByAppendingFormat:@"%@",[path stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]]];
            }
        }
//        //测试环境拼接路径才可以进入
//        if (![url containsString:@"http"]) {
//            url = [NSString stringWithFormat:@"http://%@/%@",TEST_DOMAIN,url];
//        }
//        NSLog(@"url===%@",url);
        if (!IS_HTTP_URL(url)) {
            @throw [[NSException alloc] initWithName:NSInvalidArgumentException
                                              reason:@"请求的URL必须为HTTP请求"
                                            userInfo:nil];
        }
        
        
        //生成查询参数
        NSString * queryArgumentStr = nil;

        if (queryArguments.count) {

            //记录各参数
            NSMutableArray * queryArgumentStrArrary = [[NSMutableArray alloc] initWithCapacity:queryArguments.count];
            for (NSString * key in queryArguments.allKeys) {

                id value = queryArguments[key];

                if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSValue class]]) {
                    [queryArgumentStrArrary addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
                }
            }

            if (queryArgumentStrArrary.count) {
                queryArgumentStr = [queryArgumentStrArrary componentsJoinedByString:@"&"];
            }
        }
        
        //生成body data
        NSMutableData *mutBodyData = [[NSMutableData alloc] init] ;
        if (bodyData.length){
            [mutBodyData appendData:bodyData] ;
        }
        
        switch (_type) {
            case HTTPRequestTypeGet:
            {
                //设置查询路径
                if (queryArgumentStr) {
                    url = [NSString stringWithFormat:@"%@?%@",url,queryArgumentStr];
                }
            }
                break;
                
            case HTTPRequestTypePost:
            case HTTPRequestTypePut:
            case HTTPRequestTypeDelete:
            {
                if (queryArguments.count) {
                    [mutBodyData appendData:[CLHTTPRequest _dataWithBodyArguments:queryArguments]] ;
                }
            }
                
            default:
                break;
        }
        
        
//        //设置查询路径
//        if (queryArgumentStr) {
//            url = [NSString stringWithFormat:@"%@?%@",url,queryArgumentStr];
//        }
        _requestURL      = url;
        _headerArguments = headerArguments;
        _bodyData        = mutBodyData ;//type != HTTPRequestTypeGet ? bodyData : nil;
        _type            = type;

    }

    return self;
}


+ (NSData *)_dataWithBodyArguments:(NSDictionary *)bodyArguments
{
    NSMutableData * bodyData = nil;

    if (bodyArguments && bodyArguments.count) {

        bodyData = [NSMutableData data];

        BOOL isStart = YES;
        
        for (NSString * key in bodyArguments.allKeys) {


//#define   addConnectChar()                              \
//{                                                       \
//if (!isStart) {                                     \
//[bodyData appendData:DataWithUTF8Code(@"&")];   \
//}else{                                              \
//isStart = NO;                                   \
//}                                                   \
//}
#define   addConnectChar()                              \
{                                                       \
if (!isStart) {                                     \
isStart = YES;\
}else{                                              \
isStart = NO;                                   \
}                                                   \
[bodyData appendData:DataWithUTF8Code(@"&")];    \
}
            id value = bodyArguments[key];

            if ([value isKindOfClass:[NSData class]]) {

                //添加连接符
                addConnectChar();

                NSString * tmpStr = [NSString stringWithFormat:@"%@=",[key description]];
                [bodyData appendData:DataWithUTF8Code(tmpStr)];
                [bodyData appendData:(NSData *)value];

            }else if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSValue class]]){

                //添加连接符
                addConnectChar();

                NSString * tmpStr = [NSString stringWithFormat:@"%@=%@",[key description],value];
                [bodyData appendData:DataWithUTF8Code(tmpStr)];
            }
        }
        NSLog(@"body参数为=%@",[[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding]) ;
//        HttpRequestDebugLog("body参数为=%@",[[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding]);
    }
    return bodyData;
}

#pragma mark-timeout interval
-(void)setTimeOutInterval:(NSTimeInterval)timeOutInterval
{
    _timeOutInterval = MAX(0.0, timeOutInterval) ;
}

-(NSTimeInterval)timeOutInterval
{
    if (_urlRequest) return _urlRequest.timeoutInterval ;
    
    return MAX(0, _timeOutInterval) ;
}

- (NSURLRequest *)urlRequest
{
    if (!_urlRequest) {

                HttpRequestDebugLog(@"URL = %@",_requestURL);

        NSMutableURLRequest * tmpURLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[_requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

        //设置方法
        switch (_type) {
            case HTTPRequestTypeGet:
                [tmpURLRequest setHTTPMethod:@"GET"];
                break;

            case HTTPRequestTypePost:
                [tmpURLRequest setHTTPMethod:@"POST"];
                break;

            case HTTPRequestTypePut:
                [tmpURLRequest setHTTPMethod:@"PUT"];
                break;

            case HTTPRequestTypeDelete:
                [tmpURLRequest setHTTPMethod:@"DELETE"];
                break;

            default:
                break;
        }


        //设置头参数
        for (id key in _headerArguments.allKeys) {
            [tmpURLRequest addValue:[_headerArguments stringValueForKey:key] forHTTPHeaderField:[key isKindOfClass:[NSString class]] ? key : [key description]];
        }
        //设置body
        if (_bodyData) {
            [tmpURLRequest setHTTPBody:_bodyData];
        }
        
        if (_timeOutInterval>0){
            tmpURLRequest.timeoutInterval = _timeOutInterval ;
        }
        
        _urlRequest = tmpURLRequest;
    }
    
    if (![_urlRequest.URL.absoluteString containsString:@"mineOrigin/alwaysRequest.html"]){
        NSLog(@"urlRequest:%@",_urlRequest.URL) ;
    }
    return _urlRequest;
}


- (void)_setRequesting:(BOOL)requesting
{
    if (_requesting != requesting) {
        _requesting = requesting;

        //设置网络活动指示的显示
        showNetworkActivityIndicator(requesting);
    }
}

- (void)startRequest {
    [self startRequestWithContext:nil];
}

- (void)startRequestWithContext:(id)context
{
    //取消可能的请求
    [self cancleRequest];

    _context = context;

    HttpRequestDebugLog(@"开始HTTP请求 URL = %@",self.urlRequest.URL);

    //开始请求
    [self _setRequesting:YES];
    [[URLConnectionManager defaultManager] startConnection:self request:self.urlRequest];


}

- (NSData *)startSynchronousRequestWithReturningResponse:(NSHTTPURLResponse **)response error:(NSError **)error
{
    //取消可能的请求
    [self cancleRequest];

    //开始同步请求
    return [[URLConnectionManager defaultManager] startSynchronousRequest:self.urlRequest
                                                        returningResponse:response
                                                                    error:error];
}

- (void)cancleRequest
{
    if (_requesting) {

        //取消连接
        [self _setRequesting:NO];
        [[URLConnectionManager defaultManager] cancleConnection:self];

        _context = nil;
    }
}

- (void)urlConnectionManager:(URLConnectionManager *)manager
                      connection:(NSURLConnection *)connection
       didSendHTTPBodyDataLength:(long long)sendDataLenght
              expectedDataLength:(long long)expectedDataLength
                   sendDataSpeed:(NSUInteger)speed
{
    id<CLHTTPRequestDelegate> delegate = _delegate;
    ifRespondsSelector(delegate, @selector(httpRequest:didSendHTTPBodyDataLength:expectedDataLength:sendDataSpeed:)) {

        [delegate       httpRequest:self
          didSendHTTPBodyDataLength:sendDataLenght
                 expectedDataLength:expectedDataLength
                      sendDataSpeed:speed];
    }

}

- (void)urlConnectionManager:(URLConnectionManager *)manager
                  connection:(NSURLConnection *)connection
          didReceiveResponse:(NSURLResponse *)response
{
    MyAssert([response isKindOfClass:[NSHTTPURLResponse class]]);
    HttpRequestDebugLog(@"response = %@",response);

    id<CLHTTPRequestDelegate> delegate = _delegate;
    ifRespondsSelector(delegate, @selector(httpRequest:didReceiveResponse:)){
        [delegate httpRequest:self didReceiveResponse:(id)response];
    }
}

- (void)urlConnectionManager:(URLConnectionManager *)manager
                  connection:(NSURLConnection *)connection
        didReceiveDataLength:(long long)receiveDataLength
          expectedDataLength:(long long)expectedDataLength
            receiveDataSpeed:(NSUInteger)speed
{
    id<CLHTTPRequestDelegate> delegate = _delegate;
    ifRespondsSelector(delegate, @selector(httpRequest:didReceiveDataLength:expectedDataLength:receiveDataSpeed:)) {

        [delegate   httpRequest:self
           didReceiveDataLength:receiveDataLength
             expectedDataLength:expectedDataLength
               receiveDataSpeed:speed];
    }
}


- (void)urlConnectionManager:(URLConnectionManager *)manager
                  connection:(NSURLConnection *)connection
                    response:(NSURLResponse *)response
        didFinishLoadingData:(NSData *)data
{
    HttpRequestDebugLog(@"receiveData = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

    [self _setRequesting:NO];

    //代理回调
    id<CLHTTPRequestDelegate> delegate = _delegate;
    ifRespondsSelector(delegate, @selector(httpRequest:response:didSuccessRequestWithData:)){
        [delegate httpRequest:self response:(id)response didSuccessRequestWithData:data];
    }

    //block回调
    if (self.completedCallbackBlock) {
        self.completedCallbackBlock((id)response,data,nil);
    }

    _context = nil;
}

- (void)urlConnectionManager:(URLConnectionManager *)manager
                  connection:(NSURLConnection *)connection
                    response:(NSURLResponse *)response
            didFailWithError:(NSError *)error
{

    HttpRequestDebugLog(@"error = %@",error);

    [self _setRequesting:NO];

    //代理回调
    id<CLHTTPRequestDelegate> delegate = _delegate;
    ifRespondsSelector(delegate, @selector(httpRequest:response:didFailedRequestWithError:)){
        [delegate httpRequest:self response:(id)response didFailedRequestWithError:error];
    }

    //block会带哦
    if (self.completedCallbackBlock) {
        self.completedCallbackBlock((id)response,nil,error);
    }

    _context = nil;
}

@end


@implementation CLHTTPRequest(Mutable)

- (void)_updateRequest
{
    if (_urlRequest) {
        [self cancleRequest];
        _urlRequest = nil;
    }
}

- (void)setRequestType:(HTTPRequestType)type
{
    if (_type != type) {
        _type = type;
        [self _updateRequest];
    }
}

- (void)setBodyData:(NSData *)bodyData
{
    _bodyData = bodyData;
    [self _updateRequest];
}

- (void)setBodyDataWithBodyArguments:(NSDictionary *)bodyArguments {
    [self setBodyData:[CLHTTPRequest _dataWithBodyArguments:bodyArguments]];
}

- (void)setHeaderArguments:(NSDictionary *)headerArguments
{
    _headerArguments = headerArguments;
    [self _updateRequest];
}


@end

