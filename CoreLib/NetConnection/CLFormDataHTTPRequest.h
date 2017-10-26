//
//  CLFormDataHTTPRequest.h
//  CoreLib
//
//  Created by apple pro on 2016/11/18.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "CLHTTPRequest.h"
#import <UIKit/UIKit.h>


@interface CLFormDataHTTPRequest : CLHTTPRequest
- (id)initWithURL:(NSString *)url                       //url
       uploadData:(NSData *)data                        //上载的数据
         fileName:(NSString *)fileName                  //文件名称，如“data.txt”
      contentType:(NSString *)contentType               //文件类型，如“image/jpeg”
           forKey:(NSString *)key;                      //key

- (id)initWithURL:(NSString *)url                       //url
       pathFormat:(NSString *)pathFormat
    pathArguments:(NSArray *)pathArguments
   queryArguments:(NSDictionary *)queryArguments        //查询参数
  headerArguments:(NSDictionary *)headerArguments       //头参数
       uploadData:(NSData *)data                        //上载的数据
         fileName:(NSString *)fileName                  //文件名称，如“data.txt”
      contentType:(NSString *)contentType               //文件类型，如“image/jpeg”
           forKey:(NSString *)key;                      //key

//添加上传的数据
- (void)addData:(NSData *)data                          //上载的数据
       fileName:(NSString *)fileName                    //文件名称，如“data.txt”
    contentType:(NSString *)contentType                 //文件类型，如“image/jpeg”
         forKey:(NSString *)key;                        //key

@end


@interface CLFormDataHTTPRequest (image)

//初始化，并上传图片

- (id)initWithURL:(NSString *)url                       //url
      uploadImage:(UIImage *)image                      //上载的图片，编码为jpeg格式数据流上传，不压缩质量编码
        imageName:(NSString *)imageName                 //图片名称，如“image1.jpg”
           forKey:(NSString *)key;                      //key


- (id)initWithURL:(NSString *)url                       //url
       pathFormat:(NSString *)pathFormat
    pathArguments:(NSArray *)pathArguments
   queryArguments:(NSDictionary *)queryArguments        //查询参数
  headerArguments:(NSDictionary *)headerArguments
      uploadImage:(UIImage *)image                      //上载的图片，编码为jpeg格式数据流上传
          quality:(CGFloat)compressionQuality           //编码压缩质量（0~1之间）
        imageName:(NSString *)imageName                 //图片名称，如“image1.jpg”
           forKey:(NSString *)key;                      //key

//添加图片
- (void)addImage:(UIImage *)image                       //上载的图片，编码为jpeg格式数据流上传
         quality:(CGFloat)compressionQuality            //编码压缩质量（0~1之间）
       imageName:(NSString *)imageName                  //图片名称，如“image1.jpg”
          forKey:(NSString *)key;                       //key

@end
