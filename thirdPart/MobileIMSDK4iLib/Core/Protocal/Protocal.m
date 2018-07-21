//  ----------------------------------------------------------------------
//  Copyright (C) 2017  即时通讯网(52im.net) & Jack Jiang.
//  The MobileIMSDK_X (MobileIMSDK v3.x) Project.
//  All rights reserved.
//
//  > Github地址: https://github.com/JackJiang2011/MobileIMSDK
//  > 文档地址: http://www.52im.net/forum-89-1.html
//  > 即时通讯技术社区：http://www.52im.net/
//  > 即时通讯技术交流群：320837163 (http://www.52im.net/topic-qqgroup.html)
//
//  "即时通讯网(52im.net) - 即时通讯开发者社区!" 推荐开源工程。
//
//  如需联系作者，请发邮件至 jack.jiang@52im.net 或 jb2011@163.com.
//  ----------------------------------------------------------------------
//
//  Protocal.m
//  MibileIMSDK4i_X (MobileIMSDK v3.0 at Summer 2017)
//
//  Created by JackJiang on 14/10/22.
//  Copyright (c) 2017年 52im.net. All rights reserved.
//

#import "Protocal.h"
#import "ToolKits.h"
#import "RMMapper.h"
#import "CharsetHelper.h"
#import "ProtocalFactory.h"


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 私有API
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface Protocal ()

/* 【注意】本字段仅用于客户端QoS时：表示丢包重试次数。即本字段不应被传给消息接收者（应从转成的JSON中剔除） */
@property (nonatomic, assign) int retryCount;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 本类的代码实现
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Protocal

+ (Protocal *) initWithType:(int)type content:(NSString *)dataContent from:(NSString *)from to:(NSString *)to
{
    return [Protocal initWithType:type content:dataContent from:from to:to qos:YES fp:nil tu:-1];
}
+ (Protocal *) initWithType:(int)type content:(NSString *)dataContent from:(NSString *)from to:(NSString *)to tu:(int)typeu
{
    return [Protocal initWithType:type content:dataContent from:from to:to qos:YES fp:nil tu:typeu];
}
+ (Protocal *) initWithType:(int)type content:(NSString *)dataContent from:(NSString *)from to:(NSString *)to qos:(bool)QoS fp:(NSString *)fingerPrint tu:(int)typeu
{
    return [Protocal initWithType:type content:dataContent from:from to:to qos:QoS fp:fingerPrint bg:NO tu:typeu];
}
+ (Protocal *) initWithType:(int)type content:(NSString *)dataContent from:(NSString *)from to:(NSString *)to qos:(bool)QoS fp:(NSString *)fingerPrint bg:(bool)bridge tu:(int)typeu
{
    Protocal *p = [[Protocal alloc] init];

    p.type = type;
    p.dataContent = dataContent;
    p.from = from;
    p.to = to;
    p.QoS = QoS;
    p.bridge = bridge;
    p.typeu = typeu;

    // 只有在需要QoS支持时才生成指纹，否则浪费数据传输流量
    // 目前一个包的指纹只在对象建立时创建哦
    if(QoS && fingerPrint == nil)
        p.fp = [Protocal genFingerPrint];
    else
        p.fp = fingerPrint;

    return p;
}

- (id)init
{
    if(self = [super init])
    {
        // 属性初始化
        self.type = 0;
        self.from = @"-1";
        self.to = @"-1";
        self.QoS = NO;
        self.bridge = NO;
        self.typeu = -1;

        // 初始化重视次数
        self.retryCount = 0;
    }
    return self;
}

- (int) getRetryCount
{
    return self.retryCount;
}

- (void) increaseRetryCount
{
    self.retryCount += 1;
}

- (NSString *) toGsonString
{
    // 将2进制数据转JSON字符串
    return [ToolKits toJSONString:[self toBytes]];
}

- (NSData *) toBytes
{
    // 对象先转key-values
    NSMutableDictionary *dic = [self toMutableDictionary:YES];
    // 再将Dictionary转成JSON的2进制表示
    return [ToolKits toJSONBytesWithDictionary:dic];
}
// 此方法的目的是保证序列化后去掉retryCount字段
- (NSMutableDictionary *) toMutableDictionary:(BOOL)deleteRetryCountProperty
{
    // 对象先转key-values
    NSMutableDictionary *dic = [ToolKits toMutableDictionary:self];
    if(deleteRetryCountProperty)
        // 去掉retryCount属性，以便接收方收到后反序列化时retryCount=0（即默认值）。详细说明参见本类头上的“重要说明”
        [dic removeObjectForKey:@"retryCount"];
    return dic;
}

- (Protocal *) clone
{
    // 先将原对象先转成key-values
    NSMutableDictionary *dic = [self toMutableDictionary:YES];
    // 再用原对象生成一个新的对象（iOS没有更简单的方法clone对象，供用JSON的反序列化会简单多了）
    Protocal *pepFromJASON = [RMMapper objectWithClass:[Protocal class] fromDictionary:dic];
//    // 克隆一个Protocal对象（该对象已重置retryCount数值为0）
//    pepFromJASON.retryCount = 0;
    return pepFromJASON;
}

//+ (Protocal *) fromBytes_JSON:(NSData *) fullProtocalJASOnBytes
//{
//    return [ProtocalFactory parse:fullProtocalJASOnBytes withClass:[Protocal class]];
//}

+ (NSString *) genFingerPrint
{
    return [ToolKits generateUUID];
}

@end
