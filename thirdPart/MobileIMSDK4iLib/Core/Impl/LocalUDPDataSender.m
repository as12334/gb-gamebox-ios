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
//  LocalUDPDataSender.m
//  MibileIMSDK4i_X (MobileIMSDK v3.0 at Summer 2017)
//
//  Created by JackJiang on 14/10/27.
//  Copyright (c) 2017年 52im.net. All rights reserved.
//

#import "LocalUDPDataSender.h"
#import "ProtocalFactory.h"
#import "ClientCoreSDK.h"
#import "KeepAliveDaemon.h"
#import "CharsetHelper.h"
#import "QoS4SendDaemon.h"
#import "ErrorCode.h"
#import "GCDAsyncUdpSocket.h"
#import "LocalUDPSocketProvider.h"
#import "ConfigEntity.h"
#import "UDPUtils.h"
#import "CompletionDefine.h"

@implementation LocalUDPDataSender

// 本类的单例对象
static LocalUDPDataSender *instance = nil;

//-----------------------------------------------------------------------------------
#pragma mark - 仅内部可调用的方法

/*
 * 发送数据到服务端.
 * <p>
 * 注意：直接调用此方法将无法支持QoS质量保证哦！
 *
 * @param fullProtocalBytes Protocal对象转成JSON后再编码成byte数组后的结果
 * @param dataLen Protocal对象转成JSON后再编码成byte数组长度
 * @return error code
 * @see ErrorCode
 * @see ErrorCode.ForC
 */
- (int) sendImpl_:(NSData *)fullProtocalBytes
{
    if(![[ClientCoreSDK sharedInstance] isInitialed])
        return ForC_CLIENT_SDK_NO_INITIALED;

    if(![ClientCoreSDK sharedInstance].localDeviceNetworkOk)
    {
        NSLog(@"【IMCORE】本地网络不能工作，send数据没有继续!");
        return ForC_LOCAL_NETWORK_NOT_WORKING;
    }

    // 获得UDPSocket实例
    GCDAsyncUdpSocket *ds = [[LocalUDPSocketProvider sharedInstance] getLocalUDPSocket];
    // 确保发送数据开始前，已经进行connect的操作：如果Socket没有连接上服务端
    if(ds != nil && ![ds isConnected])
    {
        ConnectionCompletion observerBlock = ^(BOOL connectResult) {
            // 成功建立了UDP连接后就把包发出去
            if(connectResult)
                [UDPUtils send:ds withData:fullProtocalBytes];
            // 否则依QoS标识位，决定是否需要重传（已经在COMMON_CODE_OK结果返回时由上层方法中入到QoS队列了，以下代码无需再次加入）
            else
            {
//                Protocal *p = [Protocal fromBytes_JSON:fullProtocalBytes];
//                // 尝试加入到QoS保证队列
//                [self putToQoS:p];
            }
        };
        // 调置连接回调
        [[LocalUDPSocketProvider sharedInstance] setConnectionObserver:observerBlock];

        // 因为connect是异步的，为了在尽可能保证在send前就已connect，所以在socketProvider里Bind后就
        // connect是最佳的，但最终能不能真正连接上，还得看delegate的反馈，但这并不重要，即使真连不上，后
        // 面的QoS机制也会让告之上层哪些包因为些几率极小的因素而没有发送成功!
        NSError *connectError = nil;
        int connectCode = [[LocalUDPSocketProvider sharedInstance] tryConnectToHost:&connectError withSocket:ds completion:observerBlock];
        // 如果连接意图没有成功发出则返回错误码
        if(connectCode != COMMON_CODE_OK)
            return connectCode;
        // 注意：此种情况下的发送成功并不是真正的成功，只是作为上层判断的依据而已，此处似设包会被发
        // 出去（即使延迟把UDP包发出去（在上面的回调里））。此情形最终得等UDP Socket的连接回调才能知道到底有没发成功
        // ，不过从应用体验上来讲，这就是UDP包的体验（发出去就不管了），所以不太会有什么影响。但此情况下上层一定不能
        // 假设是立即成功地发送出去了！
        else
            return COMMON_CODE_OK;
    }
    else
    {
        return [UDPUtils send:ds withData:fullProtocalBytes] ? COMMON_CODE_OK : COMMON_DATA_SEND_FAILD;
    }
}

- (void) putToQoS:(Protocal *)p
{
    // 【【C2C或C2S模式下的QoS机制1/4步：将包加入到发送QoS队列中】】
    // 如果需要进行QoS质量保证，则把它放入质量保证队列中供处理(已在存在于列
    // 表中就不用再加了，已经存在则意味当前发送的这个是重传包哦)
    if(p.QoS && ![[ProtocalQoS4SendProvider sharedInstance] exist:p.fp])
        [[ProtocalQoS4SendProvider sharedInstance] put:p];
}


//-----------------------------------------------------------------------------------
#pragma mark - 外部可调用的方法

// 获取本类的单例。使用单例访问本类的所有资源是唯一的合法途径。
+ (LocalUDPDataSender *)sharedInstance
{
    if (instance == nil)
    {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

- (int) sendLogin:(NSString *)loginUserId withToken:(NSString *)loginToken
{
    return [self sendLogin:loginUserId withToken:loginToken andExtra:nil];
}

- (int) sendLogin:(NSString *)loginUserId withToken:(NSString *)loginToken andExtra:(NSString *)extra
{
    // 确保首先进行核心库的初始化（此方法多次调用是无害的，但必须要保证在使用IM核心库的任何实质方法前调用（初始化）1次）
    [[ClientCoreSDK sharedInstance] initCore];

    NSData *b = [[ProtocalFactory createPLoginInfo:loginUserId withToken:loginToken andExtra:extra] toBytes];
    int code = [self sendImpl_:b];
    // 登陆信息成功发出时就把登陆名存下来
    if(code == 0)
    {
        [[ClientCoreSDK sharedInstance] setCurrentLoginUserId:loginUserId];
        [[ClientCoreSDK sharedInstance] setCurrentLoginToken:loginToken];
        [[ClientCoreSDK sharedInstance] setCurrentLoginExtra:extra];
    }

    return code;
}

- (int) sendLoginout
{
    int code = COMMON_CODE_OK;
    if([ClientCoreSDK sharedInstance].loginHasInit)
    {
        NSString *loginUserId = [ClientCoreSDK sharedInstance].currentLoginUserId;
        NSData *b = [[ProtocalFactory createPLoginoutInfo:loginUserId] toBytes];
        code = [self sendImpl_:b];
        // 登出信息成功发出时
        if(code == 0)
        {
            // 发出退出登陆的消息同时也关闭心跳线程
            [[KeepAliveDaemon sharedInstance] stop];
            // 重置登陆标识
            [[ClientCoreSDK sharedInstance] setLoginHasInit:NO];
        }
    }

    // 释放SDK资源
    [[ClientCoreSDK sharedInstance] releaseCore];

    return code;
}

- (int) sendKeepAlive
{
    NSString *currentLoginUserId = [[ClientCoreSDK sharedInstance] currentLoginUserId];
    NSData *b = [[ProtocalFactory createPKeepAlive: currentLoginUserId] toBytes];
    return [self sendImpl_:b];
}

- (int) sendCommonDataWithStr:(NSString *)dataContentWidthStr toUserId:(NSString *)to_user_id
{
    return [self sendCommonDataWithStr:dataContentWidthStr toUserId:to_user_id withTypeu:-1];
}

- (int) sendCommonDataWithStr:(NSString *)dataContentWidthStr toUserId:(NSString *)to_user_id withTypeu:(int)typeu
{
    NSString *currentLoginUserId = [[ClientCoreSDK sharedInstance] currentLoginUserId];
    Protocal *p = [ProtocalFactory createCommonData:dataContentWidthStr fromUserId:currentLoginUserId toUserId:to_user_id withTypeu:typeu];
    return [self sendCommonData:p];
}

- (int) sendCommonDataWithStr:(NSString *)dataContentWidthStr toUserId:(NSString *)to_user_id qos:(BOOL)QoS fp:(NSString *)fingerPrint withTypeu:(int)typeu
{
    NSString *currentLoginUserId = [[ClientCoreSDK sharedInstance] currentLoginUserId];
    Protocal *p = [ProtocalFactory createCommonData:dataContentWidthStr fromUserId:currentLoginUserId toUserId:to_user_id qos:QoS fp:fingerPrint withTypeu:typeu];
    return [self sendCommonData:p];
}

- (int) sendCommonData:(Protocal *)p
{
    // 数据发送代码需要同步约束，否则在IM框架中此方法的相关处理涉及全局变量的设置时会出现同步操作问题
    @synchronized(self)
    {
        if(p != nil)
        {
            NSData *b = [p toBytes];
            int code = [self sendImpl_:b];
            if(code == 0)
            {
                // 尝试加入到QoS保证队列
                [self putToQoS:p];
            }
            return code;
        }
        else
            return COMMON_INVALID_PROTOCAL;
    }
}

@end
