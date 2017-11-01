//
//  CLHTTPRequest.h
//  CoreLib
//
//  Created by apple pro on 2016/11/18.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MacroDef.h"

typedef NS_ENUM(NSUInteger,HTTPRequestType){
    HTTPRequestTypeGet     ,//GET
    HTTPRequestTypePost    ,//POST
    HTTPRequestTypePut     ,//PUT
    HTTPRequestTypeDelete
} ;

@protocol CLHTTPRequestProtocol;

@protocol CLHTTPRequestDelegate <NSObject>

@optional

/**
 * 发送过程委托方法
 * @param request request是当前的请求对象
 * @param sendDataLenght sendDataLenght是已经发送的数据长度，单位是byte
 * @param expectedDataLength expectedDataLength是预期发送的数据总长度，单位是byte
 * @param speed speed是当前发送数据的速度，单位是byte/s
 */
- (void)          httpRequest:(id<CLHTTPRequestProtocol>)request
    didSendHTTPBodyDataLength:(long long)sendDataLenght
           expectedDataLength:(long long)expectedDataLength
                sendDataSpeed:(NSUInteger)speed;

/**
 * 收到响应的委托方法
 * @param request request是当前的请求对象
 * @param response response是收到的响应
 */
- (void)httpRequest:(id<CLHTTPRequestProtocol>)request didReceiveResponse:(NSHTTPURLResponse *)response;

/**
 * 接收过程的委托方法
 * @param request request是当前的请求对象
 * @param receiveDataLength receiveDataLength是已经接收到数据的长度，单位是byte
 * @param expectedDataLength expectedDataLength是预期接收的数据总长度，单位是byte，如果总长度未知则此值为
 *                          NSURLResponseUnknownLength
 * @param speed speed是当前接收数据的速度，单位是byte/s
 */
-  (void)   httpRequest:(id<CLHTTPRequestProtocol>)request
   didReceiveDataLength:(long long)receiveDataLength
     expectedDataLength:(long long) expectedDataLength
       receiveDataSpeed:(NSUInteger)speed;

/**
 * 请求完成的委托方法
 * @param request request是当前的请求对象
 * @param response response是收到的响应
 * @param data data是接收到的数据
 */
- (void)        httpRequest:(id<CLHTTPRequestProtocol>)request
                   response:(NSHTTPURLResponse *)response
  didSuccessRequestWithData:(NSData *)data;

/**
 * 请求失败的委托方法
 * @param request request是当前的请求对象
 * @param response response是收到的响应,可能为nil
 * @param error error是请求失败的原因
 */
- (void)        httpRequest:(id<CLHTTPRequestProtocol>)request
                   response:(NSHTTPURLResponse *)response
  didFailedRequestWithError:(NSError *)error;

@end


#pragma mark-CLHTTPRequest Callback
/**
 * 完成请求的回调block
 * @param response response是收到的响应，可能为nil
 * @param data data是收到的数据，失败是为nil
 * @param error error是请求失败的原因，成功时为nil
 */
typedef void(^HTTPRequestCompletedCallbackBlock)(NSHTTPURLResponse * response, id data, NSError * error);


#pragma mark- CLHTTPRequestProtocol
@protocol CLHTTPRequestProtocol

//http请求
@property(nonatomic,strong,readonly) NSURLRequest * urlRequest;

//开始请求
- (void)startRequest;
- (void)startRequestWithContext:(id)context;

//开始同步请求
- (NSData *)startSynchronousRequestWithReturningResponse:(NSHTTPURLResponse **)response
                                                   error:(NSError **)error;

//取消请求
- (void)cancleRequest;

//是否正在请求
@property(nonatomic,readonly,getter = isRequesting) BOOL requesting;

//代理
@property(nonatomic,weak) id<CLHTTPRequestDelegate> delegate;

//完成请求回调block
@property(nonatomic,copy) HTTPRequestCompletedCallbackBlock completedCallbackBlock;

//上下文
@property(nonatomic,strong,readonly) id context;

//timeout 时间
@property(nonatomic,assign) NSTimeInterval  timeOutInterval ;
@end

#pragma mark- CLHTTPRequest


@interface CLHTTPRequest : NSObject<CLHTTPRequestProtocol>
//基本的GET请求初始化
-(id)initWithURL:(NSString*)url ;
-(id)initWithURL:(NSString *)url                        //url
      pathFormat:(NSString*)pathFormat                  //路径格式(%@)
   pathArguments:(NSArray*)pathArguments                //路径格式(%@)
  queryArguments:(NSDictionary*)queryArguments          //查询参数
 headerArguments:(NSDictionary*)headerArguments ;

//基本的POST请求初始化

-(id)initWithURL:(NSString *)url                        //url
      pathFormat:(NSString*)pathFormat                  //路径格式(%@)
   pathArguments:(NSArray*)pathArguments                //路径参数
 headerArguments:(NSDictionary*)headerArguments
   bodyArguments:(NSDictionary*)bodyArguments ;

-(id)initWithURL:(NSString *)url
      pathFormat:(NSString*)pathFormat
   pathArguments:(NSArray*)pathArguments
 headerArguments:(NSDictionary*)headerArguments
        bodyData:(NSData*)bodyData ;


//其他初始化方法
- (id)initWithURL:(NSString *)url                       //url
       pathFormat:(NSString *)pathFormat                //路径格式
    pathArguments:(NSArray *)pathArguments              //路径参数
   queryArguments:(NSDictionary *)queryArguments        //查询参数
  headerArguments:(NSDictionary *)headerArguments       //头参数
    bodyArguments:(NSDictionary *)bodyArguments         //body参数
             type:(HTTPRequestType)type;                //类型

- (id)initWithURL:(NSString *)url                       //url
       pathFormat:(NSString *)pathFormat                //路径格式
    pathArguments:(NSArray *)pathArguments              //路径参数
   queryArguments:(NSDictionary *)queryArguments        //查询参数
  headerArguments:(NSDictionary *)headerArguments       //头参数
         bodyData:(NSData *)bodyData                    //body数据
             type:(HTTPRequestType)type;                //类型


- (id)initWithURL:(NSString *)url                       //url
             path:(NSString *)path                      //路径(path1/path2/path3/...格式)
   queryArguments:(NSDictionary *)queryArguments        //查询参数
  headerArguments:(NSDictionary *)headerArguments       //头参数
         bodyData:(NSData *)bodyData                    //body数据
             type:(HTTPRequestType)type;                //类型


@end


@interface CLHTTPRequest (Mutable)

//设置类型
- (void)setRequestType:(HTTPRequestType)type;

//设置头参数
- (void)setHeaderArguments:(NSDictionary *)headerArguments;

//设置请求体数据
- (void)setBodyData:(NSData *)bodyData;

//通过body参数设置请求体数据
- (void)setBodyDataWithBodyArguments:(NSDictionary *)bodyArguments;

@end


