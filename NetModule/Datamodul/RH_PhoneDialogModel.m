//
//  RH_PhoneDialogModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/29.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PhoneDialogModel.h"
#import "coreLib.h"

@implementation RH_PhoneDialogModel

-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        /*
         "id" : 10356,
         "update_time" : 1522031170086,
         "content" : "<p><span style=\"color: rgb(255, 0, 0);\">原谅我一生放荡不羁爱自由<\/span><\/p><p><span style=\"color: rgb(112, 48, 160);\">那会怕有一天会跌倒......<\/span><\/p>",
         "link" : "www.baidu.com",
         "content_type" : "2",
         "start_time" : 1522031160000,
         "type" : "carousel_type_phone_dialog",
         "carousel_id" : 10649,
         "language" : "zh_CN",
         "end_time" : 1522598400000,
         "cover" : "",
         "name" : "骄傲的放纵（海阔天空）",
         "status" : true
         */
        _link = [info stringValueForKey:@"link"] ;
        _name = [info stringValueForKey:@"name"] ;
        _content_type = [info stringValueForKey:@"content_type"] ;
        _cover = [info stringValueForKey:@"cover"] ;
        _content = [info stringValueForKey:@"content"] ;
    }
    return self;
}
@end


