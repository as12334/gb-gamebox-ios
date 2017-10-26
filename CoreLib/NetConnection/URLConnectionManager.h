//
//  URLConnectionManager.h
//  CoreLib
//
//  Created by apple pro on 2016/11/18.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class URLConnectionManager;

@protocol URLConnectionManagerDelegate <NSObject>

@optional

/**
 * 发送过程委托方法
 * @param manager manager是当前连接的管理对象
 * @param connection connection是当前连接
 * @param sendDataLenght sendDataLenght是已经发送的数据长度，单位是byte
 * @param expectedDataLength expectedDataLength是预期发送的数据总长度，单位是byte
 * @param speed speed是当前发送数据的速度，单位是byte/s
 */
- (void)urlConnectionManager:(URLConnectionManager *)manager
                  connection:(NSURLConnection *)connection
   didSendHTTPBodyDataLength:(long long)sendDataLenght
          expectedDataLength:(long long)expectedDataLength
               sendDataSpeed:(NSUInteger)speed;

/**
 * 收到响应的委托方法
 * @param manager manager是当前连接的管理对象
 * @param connection connection是当前连接
 * @param response response是收到的响应
 */
- (void)urlConnectionManager:(URLConnectionManager *)manager
                  connection:(NSURLConnection *)connection
          didReceiveResponse:(NSURLResponse *)response;

/**
 * 接收过程的委托方法
 * @param manager manager是当前连接的管理对象
 * @param connection connection是当前连接
 * @param receiveDataLength receiveDataLength是已经接收到数据的长度，单位是byte
 * @param expectedDataLength 是预期接收的数据总长度，单位是byte
 * @param speed speed是当前接收数据的速度，单位是byte/s
 */
- (void)urlConnectionManager:(URLConnectionManager *)manager
                  connection:(NSURLConnection *)connection
        didReceiveDataLength:(long long)receiveDataLength
          expectedDataLength:(long long)expectedDataLength
            receiveDataSpeed:(NSUInteger)speed;


/**
 * 请求完成的委托方法
 * @param manager manager是当前连接的管理对象
 * @param connection connection是当前连接
 * @param response response是收到的响应
 * @param data data是接收到的数据
 */
- (void)urlConnectionManager:(URLConnectionManager *)manager
                  connection:(NSURLConnection *)connection
                    response:(NSURLResponse *)response
        didFinishLoadingData:(NSData *)data;

/**
 * 请求失败的委托方法
 * @param manager manager是当前连接的管理对象
 * @param connection connection是当前连接
 * @param response response是收到的响应,可能为nil
 * @param error error是请求失败的原因
 */
- (void)urlConnectionManager:(URLConnectionManager *)manager
                  connection:(NSURLConnection *)connection
                    response:(NSURLResponse *)response
            didFailWithError:(NSError *)error;

@end


/**
 * 请求回调的block
 * @param response response是收到的响应
 * @param data data是获取的数据
 * @param error error是请求失败的原因，用来判定请求是否成功
 */
typedef void(^CLURLConnectionCompletionBlcok)(NSURLResponse * response, NSData * data, NSError * error);


@interface URLConnectionManager : NSObject
/**
 * 默认管理器，单例模式
 */
+ (URLConnectionManager *)defaultManager;

/**
 * 开始URL请求
 * @param delegate delegate为回调的代理，弱引用
 * @param request request为需要进行请求，不能为nil，否则会抛出异常
 */
- (void)startConnection:(id<URLConnectionManagerDelegate>)delegate request:(NSURLRequest *)request;

/**
 * 开始URL请求，block回调版
 * @param request request为需要进行请求，不能为nil，否则会抛出异常
 * @param completionHander completionHander为回调的block
 * @return 返回自动生成的代理，可通过其取消请求
 */
- (id<URLConnectionManagerDelegate>)startConnectionWithRequest:(NSURLRequest *)request
                                              completionHander:(CLURLConnectionCompletionBlcok)completionHander;


/**
 * 开始同步请求
 * @param request request为需要进行请求，不能为nil，否则会抛出异常
 * @param response response为请求的响应
 * @param error error为错误
 * @return 返回获取到的数据
 */
- (NSData *)startSynchronousRequest:(NSURLRequest *)request
                  returningResponse:(NSURLResponse **)response
                              error:(NSError **)error;

/**
 * 取消delegate的所有请求
 */
- (void)cancleConnection:(id<URLConnectionManagerDelegate>)delegate;

/**
 * 取消delegate的特定请求，removeAll为YES，代表移除所有等于request的请求
 */
- (void)cancleConnection:(id<URLConnectionManagerDelegate>)delegate
                 request:(NSURLRequest *)request
               removeAll:(BOOL)removeAll;

/**
 * 取消所有请求
 */
- (void)cancleAllConnection;

/**
 * 获取delegate的所有请求
 */
- (NSArray *)connectionsForDelegate:(id<URLConnectionManagerDelegate>)delegate;

@end
