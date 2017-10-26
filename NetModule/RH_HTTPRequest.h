//
//  RH_HTTPRequest.h
//  CoreLib
//
//  Created by jinguihua on 2016/11/30.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CLHTTPRequest.h"

@class RH_HTTPRequest ;

//---------------------------------------

@protocol RH_HTTPRequestDelegate <CLHTTPRequestDelegate>

@optional

/**
 * 此代理方法用来处理结果数据，会在后台进行回调
 * @param request request为请求实例
 * @param response response为请求的响应
 * @param data data为收到的待处理的数据
 * @param reslutData reslutData为处理后的数据回调
 * @param error error为处理后的错误回调
 * @return 返回值指定是否实现了相关处理，返回NO则会使用默认方式进行数据的处理
 */
- (BOOL)httpRequest:(id<CLHTTPRequestProtocol>)request
           response:(NSHTTPURLResponse *)response
         handleData:(id)data
         reslutData:(id *)reslutData
              error:(NSError **)error;

/**
 * 此代理方法用来回调请求成功并处理后的数据
 * @param request request为请求实例
 * @param reslutData reslutData为处理后的数据
 */
- (void)httpRequest:(id<CLHTTPRequestProtocol>)request didSuccessRequestWithResultData:(id)reslutData;

@end


@interface RH_HTTPRequest : NSObject<CLHTTPRequestProtocol>
- (id)initWithAPIName:(NSString *)apiName
           pathFormat:(NSString *)pathFormat
        pathArguments:(NSArray *)pathArguments
       queryArguments:(NSDictionary *)queryArguments
      headerArguments:(NSDictionary *)headerArguments
        bodyArguments:(NSDictionary *)bodyArguments
                 type:(HTTPRequestType)type;

//代理
@property(nonatomic,weak) id<RH_HTTPRequestDelegate> delegate;

@end

//---------------------------------------

@interface RH_HTTPRequest (FromData)

- (id)initWithFromDataAPIName:(NSString *)apiName
                   pathFormat:(NSString *)pathFormat
                pathArguments:(NSArray *)pathArguments
               queryArguments:(NSDictionary *)queryArguments
              headerArguments:(NSDictionary *)headerArguments;

//添加图片
- (BOOL)addImage:(UIImage *)image
       imageName:(NSString *)imageName
          forKey:(NSString *)key;

//添加文件
- (BOOL)addData:(NSData *)data                          //上载的数据
       fileName:(NSString *)fileName                    //文件名称，如“data.txt”
    contentType:(NSString *)contentType                 //文件类型，如“image/jpeg”
         forKey:(NSString *)key;                        //key


@end

