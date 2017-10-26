//
//  RH_HTTPRequest.m
//  CoreLib
//
//  Created by jinguihua on 2016/11/30.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "RH_HTTPRequest.h"
#import "NSError+RH_HTTPRequest.h"
#import "RH_API.h"
#import "coreLib.h"

@interface RH_HTTPRequest()<CLHTTPRequestDelegate>

@end

@implementation RH_HTTPRequest
{
    CLHTTPRequest * _httpRequest;

    //处理数据的上下文
    NSString * _handleDataContext;
}


@synthesize completedCallbackBlock = _completedCallbackBlock;
@synthesize context = _context;
@synthesize requesting = _requesting;

- (id)init
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException
                                   reason:@"该类不支持默认初始化方法"
                                 userInfo:nil];
}

- (id)initWithAPIName:(NSString *)apiName
           pathFormat:(NSString *)pathFormat
        pathArguments:(NSArray *)pathArguments
       queryArguments:(NSDictionary *)queryArguments
      headerArguments:(NSDictionary *)headerArguments
        bodyArguments:(NSDictionary *)bodyArguments
                 type:(HTTPRequestType)type
{
//    MyAssert(apiName.length);

    self = [super init];

    if (self) {

        //查询参数
        NSMutableDictionary * tmpQueryArguments = [NSMutableDictionary dictionaryWithDictionary:queryArguments];

        _httpRequest = [[CLHTTPRequest alloc] initWithURL:apiName
                                               pathFormat:pathFormat
                                            pathArguments:pathArguments
                                           queryArguments:tmpQueryArguments
                                          headerArguments:headerArguments
                                            bodyArguments:bodyArguments
                                                     type:type];

    }

    return self;
}

- (void)dealloc {
    [self cancleRequest];
}

#pragma mark -

- (NSURLRequest *)urlRequest {
    return _httpRequest.urlRequest;
}

- (void)startRequest {
    [self startRequestWithContext:nil];
}

- (void)startRequestWithContext:(id)context
{
    [self cancleRequest];

    _context = context;
    _requesting = YES;
    _httpRequest.delegate = self;
    [_httpRequest startRequest];
}

- (NSData *)startSynchronousRequestWithReturningResponse:(NSHTTPURLResponse *__autoreleasing *)response
                                                   error:(NSError *__autoreleasing *)error
{
    [self cancleRequest];
    return [_httpRequest startSynchronousRequestWithReturningResponse:response error:error];
}


- (void)cancleRequest
{
    if (_requesting) {
        _requesting = NO;

        _context = nil;
        _handleDataContext = nil;

        _httpRequest.delegate = nil;
        [_httpRequest cancleRequest];
    }
}

#pragma mark -

- (void)        httpRequest:(id<CLHTTPRequestProtocol>)request
  didSendHTTPBodyDataLength:(long long)sendDataLenght
         expectedDataLength:(long long)expectedDataLength
              sendDataSpeed:(NSUInteger)speed
{
    id<CLHTTPRequestDelegate> delegate = self.delegate;
    ifRespondsSelector(delegate, @selector(httpRequest:didSendHTTPBodyDataLength:expectedDataLength:sendDataSpeed:)){

        [delegate       httpRequest:self
          didSendHTTPBodyDataLength:sendDataLenght
                 expectedDataLength:expectedDataLength
                      sendDataSpeed:speed];
    }

}

- (void)httpRequest:(id<CLHTTPRequestProtocol>)request didReceiveResponse:(NSHTTPURLResponse *)response
{
    id<CLHTTPRequestDelegate> delegate = self.delegate;
    ifRespondsSelector(delegate, @selector(httpRequest:didReceiveResponse:)){
        [delegate httpRequest:self didReceiveResponse:response];
    }
}

-  (void)       httpRequest:(id<CLHTTPRequestProtocol>)request
       didReceiveDataLength:(long long)receiveDataLength
         expectedDataLength:(long long)expectedDataLength
           receiveDataSpeed:(NSUInteger)speed
{
    id<CLHTTPRequestDelegate> delegate = self.delegate;
    ifRespondsSelector(delegate, @selector(httpRequest:didReceiveDataLength:expectedDataLength:receiveDataSpeed:)){

        [delegate   httpRequest:self
           didReceiveDataLength:receiveDataLength
             expectedDataLength:expectedDataLength
               receiveDataSpeed:speed];
    }
}

- (void)        httpRequest:(id<CLHTTPRequestProtocol>)request
                   response:(NSHTTPURLResponse *)response
  didFailedRequestWithError:(NSError *)error
{
    _requesting = NO;

    [self _sendErrorMsgWithError:[NSError netErrorWithError:error] response:response];

    _context = nil;
}

- (void)_sendErrorMsgWithError:(NSError *)error response:(NSHTTPURLResponse *)response
{
    id<CLHTTPRequestDelegate> delegate = self.delegate;
    ifRespondsSelector(delegate, @selector(httpRequest:response:didFailedRequestWithError:)){
        [delegate httpRequest:self response:response didFailedRequestWithError:error];
    }

    if(self.completedCallbackBlock){
        self.completedCallbackBlock(response,nil,error);
    }
}

- (void)        httpRequest:(id<CLHTTPRequestProtocol>)request
                   response:(NSHTTPURLResponse *)response
  didSuccessRequestWithData:(NSData *)data
{
    //请求成功后的结果回调结果回调
    id<RH_HTTPRequestDelegate> delegate = self.delegate;
    ifRespondsSelector(delegate, @selector(httpRequest:response:didSuccessRequestWithData:)){
        [delegate httpRequest:self response:response didSuccessRequestWithData:data];
    }

    //上下文，防止处理数据时请求被取消
    NSString * handleDataContext = getUniqueID();
    _handleDataContext = handleDataContext;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSError * error = nil;
        id reslutData = nil;

        //代理处理数据
        BOOL bRet = NO;
        ifRespondsSelector(delegate, @selector(httpRequest:response:handleData:reslutData:error:)) {
            bRet = [delegate httpRequest:self response:response handleData:data reslutData:&reslutData error:&error];
        }

        if (!bRet) { //代理没有实现数据的处理，则使用默认的处理方式
            reslutData = data.length ? [NSJSONSerialization JSONObjectWithData:data
                                                                       options:NSJSONReadingAllowFragments |
                                        NSJSONReadingMutableContainers
                                                                         error:&error] : @{};
            if (error) { //json解析错误
                error = [NSError resultDataNoJSONError];
            }else if(![reslutData boolValueForKey:RH_GP_SUCCESS]) { //结果错误
                error = [NSError resultErrorWithResultInfo:reslutData];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{

            //没有被取消，因为数据处理是一个异步过程，可能在处理过程中请求被取消
            if (!self.isRequesting && [handleDataContext isEqualToString:_handleDataContext]) {
                return;
            }
            _requesting = NO;

            //消息回调
            if (error) {
                [self _sendErrorMsgWithError:error response:response];
            }else{

                id<RH_HTTPRequestDelegate> delegate = self.delegate;
                ifRespondsSelector(delegate, @selector(httpRequest:didSuccessRequestWithResultData:)){
                    [delegate httpRequest:self didSuccessRequestWithResultData:reslutData];
                }

                if (self.completedCallbackBlock) {
                    self.completedCallbackBlock(response,reslutData,nil);
                }
            }

            _context = nil;
        });

    });
}

@end


@implementation RH_HTTPRequest (FromData)

- (id)initWithFromDataAPIName:(NSString *)apiName
                   pathFormat:(NSString *)pathFormat
                pathArguments:(NSArray *)pathArguments
               queryArguments:(NSDictionary *)queryArguments
              headerArguments:(NSDictionary *)headerArguments
{
    self = [super init];
    if (self) {

        NSMutableDictionary * tmpQueryArguments = [NSMutableDictionary dictionaryWithDictionary:queryArguments];

        _httpRequest = [[CLFormDataHTTPRequest alloc] initWithURL:apiName
                                                       pathFormat:pathFormat
                                                    pathArguments:pathArguments
                                                   queryArguments:tmpQueryArguments
                                                  headerArguments:headerArguments];
    }

    return self;
}


- (BOOL)addImage:(UIImage *)image imageName:(NSString *)imageName forKey:(NSString *)key
{
    if ([_httpRequest isKindOfClass:[CLFormDataHTTPRequest class]]) {

        [(CLFormDataHTTPRequest *)_httpRequest addImage:image
                                                quality:1.f
                                              imageName:imageName
                                                 forKey:key];
        return YES;
    }else{
        NSLog(@"非FromData分类里面的初始化方法初始化无法添加数据");
        return NO;
    }
}

- (BOOL)addData:(NSData *)data
       fileName:(NSString *)fileName
    contentType:(NSString *)contentType
         forKey:(NSString *)key
{
    if ([_httpRequest isKindOfClass:[CLFormDataHTTPRequest class]]) {

        [(CLFormDataHTTPRequest *)_httpRequest addData:data
                                              fileName:fileName
                                           contentType:contentType
                                                forKey:key];
        return YES;
    }else{
        NSLog(@"非FromData分类里面的初始化方法初始化无法添加数据");
        return NO;
    }
}

@end
