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
//  ConfigEntity.m
//  MibileIMSDK4i_X (MobileIMSDK v3.0 at Summer 2017)
//
//  Created by JackJiang on 14/10/22.
//  Copyright (c) 2017年 52im.net. All rights reserved.
//

#import "ConfigEntity.h"
#import "KeepAliveDaemon.h"

static NSString *serverIp = @"openmob.net";
static int serverPort = 7901;
static int localUdpSendAndListeningPort = 7801;
static NSString *appKey = nil;

@implementation ConfigEntity

+ (void)registerWithAppKey:(NSString *)key
{
    appKey = key;
}

+ (void) setServerIp:(NSString*)sIp
{
    serverIp = sIp;
}
+ (NSString *)getServerIp
{
    return serverIp;
}

+ (void) setServerPort:(int)sPort
{
    serverPort = sPort;
}
+ (int) getServerPort
{
    return serverPort;
}

+ (void) setLocalUdpSendAndListeningPort:(int)lPort
{
    localUdpSendAndListeningPort = lPort;
}
+ (int) getLocalUdpSendAndListeningPort
{
    return localUdpSendAndListeningPort;
}

+ (void) setSenseMode:(SenseMode)mode
{
    int keepAliveInterval = 0;
    int networkConnectionTimeout = 0;

    switch(mode)
    {
        case SenseMode3S:
            // 心跳间隔3秒
            keepAliveInterval = 3000;// 3s
            // 10秒后未收到服务端心跳反馈即认为连接已断开（相当于连续3 个心跳间隔后仍未收到服务端反馈）
            networkConnectionTimeout = 3000 * 3 + 1000;// 10s
            break;
        case SenseMode10S:
            // 心跳间隔10秒
            keepAliveInterval = 10000;// 10s
            // 10秒后未收到服务端心跳反馈即认为连接已断开（相当于连续2 个心跳间隔后仍未收到服务端反馈）
            networkConnectionTimeout = 10000 * 2 + 1000;// 21s
            break;
        case SenseMode30S:
            // 心跳间隔30秒
            keepAliveInterval = 30000;// 30s
            // 10秒后未收到服务端心跳反馈即认为连接已断开（相当于连续2 个心跳间隔后仍未收到服务端反馈）
            networkConnectionTimeout = 30000 * 2 + 1000;// 61s
            break;
        case SenseMode60S:
            // 心跳间隔60秒
            keepAliveInterval = 60000;// 60s
            // 10秒后未收到服务端心跳反馈即认为连接已断开（相当于连续2 个心跳间隔后仍未收到服务端反馈）
            networkConnectionTimeout = 60000 * 2 + 1000;// 121s
            break;
        case SenseMode120S:
            // 心跳间隔120秒
            keepAliveInterval = 120000;// 120s
            // 10秒后未收到服务端心跳反馈即认为连接已断开（相当于连续2 个心跳间隔后仍未收到服务端反馈）
            networkConnectionTimeout = 120000 * 2 + 1000;// 241s
            break;
    }

    if(keepAliveInterval > 0)
    {
        // 设置Kepp alive心跳间隔
        [KeepAliveDaemon setKEEP_ALIVE_INTERVAL:keepAliveInterval];
    }

    if(networkConnectionTimeout > 0)
    {
        // 设置与服务端掉线的超时时长
        [KeepAliveDaemon setNETWORK_CONNECTION_TIME_OUT:networkConnectionTimeout];
    }

    // 与服务端掉线后的重连尝试间隔
    // [AutoReLoginDaemon setAUTO_RE$LOGIN_INTERVAL:2 * 1000];// 5s
}


@end
