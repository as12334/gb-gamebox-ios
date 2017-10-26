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
//  LocalUDPDataReciever.m
//  MibileIMSDK4i_X (MobileIMSDK v3.0 at Summer 2017)
//
//  Created by JackJiang on 14/10/27.
//  Copyright (c) 2017年 52im.net. All rights reserved.
//

#import "LocalUDPDataReciever.h"
#import "Protocal.h"
#import "LocalUDPDataSender.h"
#import "ProtocalFactory.h"
#import "ClientCoreSDK.h"
#import "ErrorCode.h"
#import "QoS4ReciveDaemon.h"
#import "ProtocalType.h"
#import "ChatTransDataEvent.h"
#import "KeepAliveDaemon.h"
#import "PLoginInfoResponse.h"
#import "AutoReLoginDaemon.h"
#import "QoS4SendDaemon.h"
#import "PErrorResponse.h"
#import "LocalUDPSocketProvider.h"

@implementation LocalUDPDataReciever

// 本类的单例对象
static LocalUDPDataReciever *instance = nil;

// 获取本类的单例。使用单例访问本类的所有资源是唯一的合法途径。
+ (LocalUDPDataReciever *)sharedInstance
{
    if (instance == nil)
    {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

- (void) handleProtocal:(NSData *)originalProtocalJSONData
{
    if(originalProtocalJSONData == nil)
        return;

    Protocal *pFromServer =
        //[Protocal fromBytes_JSON:originalProtocalJSONData];
        [ProtocalFactory parse:originalProtocalJSONData];
    // ## 如果该消息是需要QoS支持的包
    if(pFromServer.QoS)
    {
        // # Bug FIX B20170620_001 START 【1/2】
        // # [Bug描述]：当服务端认证接口返回非0的code时，客记端会进入自动登陆尝试死循环。
        // # [Bug原因]：原因在于客户端收到服务端的响应包时，因服务端发过来的包需要QoS，客
        //              户端会先发送一个ACK包，那么此ACK包到达服务端后会因客户端“未登陆”
        //              而再次发送一“未登陆”错误信息包给客户端，客户端在收到此包后会触发
        //              自动登陆重试，进而进入死循环。
        // # [解决方法]：客户端判定当收到的是服务端的登陆响应包且code不等于0就不需要回ACK
        //              包给服务端。
        // # [此解决方法带来的服务端表现]：服务端会因客户端网络关闭而将响应包进行重传直到
        //              超时丢弃，但并不影响什么。
        if(pFromServer.type == FROM_SERVER_TYPE_OF_RESPONSE_LOGIN
           && [ProtocalFactory parsePLoginInfoResponse:pFromServer.dataContent].code != 0)
        {
            if([ClientCoreSDK isENABLED_DEBUG])
                NSLog(@"【IMCORE】【BugFIX】这是服务端的登陆返回响应包，且服务端判定登陆失败(即code!=0)，本次无需发送ACK应答包！");
        }
        // # Bug FIX 20170620 END 【1/2】
        else
        {
            // 且已经存在于接收列表中（及意味着可能是之前发给对方的应
            // 答包因网络或其它情况丢了，对方又因QoS机制重新发过来了）
            if([[ProtocalQoS4ReciveProvider sharedInstance] hasRecieved:pFromServer.fp])
            {
                if([ClientCoreSDK isENABLED_DEBUG])
                    NSLog(@"【IMCORE】【QoS机制】%@已经存在于发送列表中，这是重复包，通知应用层收到该包罗！", pFromServer.fp);

                //------------------------------------------------------------------------------ [1]代码与[2]处相同的哦 S
                // 【【C2C、C2S、S2C模式下的QoS机制2/4步：将收到的包存入QoS接收方暂存队列中（用于防重复）】】
                [[ProtocalQoS4ReciveProvider sharedInstance] addRecieved:pFromServer];
                // 【【C2C、C2S、S2C模式下的QoS机制3/4步：回应答包】】
                // 给发送者回一个“收到”应答包
                [self sendRecievedBack:pFromServer];
                //------------------------------------------------------------------------------ [1]代码与[2]处相同的哦 E

                // 此包重复，不需要通知应用层收到该包了，直接返回
                return;
            }

            //------------------------------------------------------------------------------ [2]代码与[1]处相同的哦 S
            // 【【C2C、C2S、S2C模式下的QoS机制2/4步：将收到的包存入QoS接收方暂存队列中（用于防重复）】】
            [[ProtocalQoS4ReciveProvider sharedInstance] addRecieved:pFromServer];
            // 【【C2C、C2S、S2C模式下的QoS机制3/4步：回应答包】】
            // 给发送者回一个“收到”应答包
            [self sendRecievedBack:pFromServer];
            //------------------------------------------------------------------------------ [2]代码与[1]处相同的哦 E
        }
    }

    //
    switch(pFromServer.type)
    {
            // ** 收到通用数据
        case FROM_CLIENT_TYPE_OF_COMMON_DATA:
        {
            // 收到通用数据的回调
            if([ClientCoreSDK sharedInstance].chatTransDataEvent != nil)
            {
                [[ClientCoreSDK sharedInstance].chatTransDataEvent onTransBuffer:pFromServer.fp withUserId:pFromServer.from andContent:pFromServer.dataContent andTypeu:pFromServer.typeu];
            }
            break;
        }
            //** 收到服务反馈过来的心跳包
        case FROM_SERVER_TYPE_OF_RESPONSE_KEEP_ALIVE:
        {
            if([ClientCoreSDK isENABLED_DEBUG])
                NSLog(@"【IMCORE】收到服务端回过来的Keep Alive心跳响应包.");
            // 更新服务端的最新响应时间（该时间将作为计算网络是否断开的依据）
            [[KeepAliveDaemon sharedInstance] updateGetKeepAliveResponseFromServerTimstamp];
            break;
        }
            //** 收到好友发过来的QoS应答包
        case FROM_CLIENT_TYPE_OF_RECIVED:
        {
            // 应答包的消息内容即为之前收到包的指纹id
            NSString *theFingerPrint = pFromServer.dataContent;
            if([ClientCoreSDK isENABLED_DEBUG])
                NSLog(@"【IMCORE】【QoS】收到%@发过来的指纹为%@的应答包.", pFromServer.from, theFingerPrint);

            // 将收到的应答事件通知事件处理者
            if([ClientCoreSDK sharedInstance].messageQoSEvent != nil)
                [[ClientCoreSDK sharedInstance].messageQoSEvent messagesBeReceived:theFingerPrint];


            // 【【C2C或C2S模式下的QoS机制4/4步：收到应答包时将包从发送QoS队列中删除】】
            [[ProtocalQoS4SendProvider sharedInstance] remove:theFingerPrint];

            break;
        }
            // ** 收到服务端反馈过来的登陆完成信息
        case FROM_SERVER_TYPE_OF_RESPONSE_LOGIN:
        {
            // 解析服务端反馈过来的登陆消息
            PLoginInfoResponse *loginInfoRes = [ProtocalFactory parsePLoginInfoResponse:pFromServer.dataContent];
            // 登陆成功了！
            if(loginInfoRes.code == 0)
            {
                // 记录用户登陆信息（因为此处不太好记录用户登陆名和密
                // 码，所以登陆名和密码现在是在登陆消息发出时就记录了）
                [ClientCoreSDK sharedInstance].loginHasInit = YES;
//                [ClientCoreSDK sharedInstance].currentUserId = loginInfoRes.user_id;

                // 尝试关闭自动重新登陆线程（如果该线程正在运行的话）
                [[AutoReLoginDaemon sharedInstance] stop];

                ObserverCompletion observerBlock = ^(id observerble ,id data) {
                    //【掉线后关掉QoS机制，为手机省电】
//                    // 掉线时关闭QoS机制之发送列表重视机制（因为掉线了开启也没有意义）
//                    // ** 关闭但不清空可能存在重传列表是合理的，防止在网络状况不好的情况下，登
//                    // ** 陆能很快恢复时也能通过重传尝试重传，即使重传不成功至少也可以提示一下
                      // 20170408 by Jack Jiang：为了让掉线情况下的消息发送能尽快作为“未实时送达”包反馈到UI层从而提升体验，而不关闭发送质量保证线程
//                    [[ProtocalQoS4SendProvider sharedInstance] stop];

                    // 掉线时关闭QoS机制之接收列表防重复机制（因为掉线了开启也没有意义）
                    // ** 关闭但不清空可能存在缓存列表是合理的，防止在网络状况不好的情况下，登
                    // ** 陆能很快恢复时对方可能存在的重传，此时也能一定程序避免消息重复的可能
                    [[ProtocalQoS4ReciveProvider sharedInstance] stop];

                    // 设置中否正常连接（登陆）到服务器的标识（注意：在要event事件通知前设置哦，因为应用中是在event中处理状态的）
                    [ClientCoreSDK sharedInstance].connectedToServer = NO;
//                    [ClientCoreSDK sharedInstance].currentUserId = -1;
                    // 通知回调实现类
                    [[ClientCoreSDK sharedInstance].chatBaseEvent onLinkCloseMessage:-1];
                    // 网络断开后即刻开启自动重新登陆线程从而尝试重新登陆（以便网络恢复时能即时自动登陆）
                    [[AutoReLoginDaemon sharedInstance] start:YES];
                };
                // 立即开启Keepalive心跳线程
                [[KeepAliveDaemon sharedInstance] setNetworkConnectionLostObserver:observerBlock];
                // ** 2015-02-10 by Jack Jiang：收到登陆成功反馈后，无需立即就发起心跳，因为刚刚才与服务端
                // ** 成功通信了呢（刚收到服务器的登陆成功反馈），节省1次心跳，降低服务重启后的“雪崩”可能性
//                [[KeepAliveDaemon sharedInstance] start:YES];
                [[KeepAliveDaemon sharedInstance] start:NO];

                //【登陆成功后开启QoS机制】
                // 启动QoS机制之发送列表重视机制
                [[ProtocalQoS4SendProvider sharedInstance] startup:YES];
                // 启动QoS机制之接收列表防重复机制
                [[ProtocalQoS4ReciveProvider sharedInstance] startup:YES];
                // 设置中否正常连接（登陆）到服务器的标识（注意：在要event事件通知前设置哦，因为应用中是在event中处理状态的）
                [ClientCoreSDK sharedInstance].connectedToServer = YES;
            }
            else
            {
                // # Bug FIX B20170620_001 START 【2/2】
                // 登陆失败后关闭网络监听是合理的作法
                [[LocalUDPSocketProvider sharedInstance] closeLocalUDPSocket];
                // # Bug FIX B20170620_001 END 【2/2】

                // 设置中否正常连接（登陆）到服务器的标识（注意：在要event事件通知前设置哦，因为应用中是在event中处理状态的）
                [ClientCoreSDK sharedInstance].connectedToServer = NO;
//                [ClientCoreSDK sharedInstance].currentUserId = -1;
            }

            // 用户登陆认证情况通知回调
            if([ClientCoreSDK sharedInstance].chatBaseEvent != nil)
            {
                [[ClientCoreSDK sharedInstance].chatBaseEvent onLoginMessage:loginInfoRes.code];
            }

            break;
        }
            // ** 服务端返回来过的错误消息
        case FROM_SERVER_TYPE_OF_RESPONSE_FOR_ERROR:
        {
            // 解析服务端反馈过来的消息
            PErrorResponse *errorRes = [ProtocalFactory parsePErrorResponse:pFromServer.dataContent];

            // 收到的如果是“尚未登陆”的错误消息，则意味着该用户的会话可能已经超时了，
            // 此时当然要停止心跳线程了，否则心跳有何意义！
            // ** 【性能隐患】：因为与服务端是UDP无连接的，所以服务端回过来的此消息可能会网络状况
            // ** 差等情况而导致延迟收到该包（收到时很可能与服务端的会话已经正常了），但目前来
            // ** 没有办法保证完全的正确性，但起码保证用户与服务端的正常会话才是首位的，所以
            // ** 有时候错误地终止了正常会话而启动重新登陆从而损失的一些性能因是可以下载解和合理的
            if(errorRes.errorCode == ForS_RESPONSE_FOR_UNLOGIN)
            {
                //
                [ClientCoreSDK sharedInstance].loginHasInit = NO;

                NSLog(@"【IMCORE】收到服务端的“尚未登陆”的错误消息，心跳线程将停止，请应用层重新登陆.");
                // 停止心跳
                [[KeepAliveDaemon sharedInstance] stop];

                // 此时尝试延迟开启自动登陆线程哦（注意不需要立即开启）
                // ** 【说明】：为何此时要开启自动登陆呢？逻辑上讲，心跳时即是连接正常时，
                // ** 上面的停止心跳即是登陆身份丢失时，那么此时再开启自动登陆线程
                // ** 则也是合理的。
                // ** 其实此处开启自动登陆线程是更多是为了防止这种情况：当客户端并没有
                // ** 触发网络断开（也就不会触发自动登陆）时，而此时却可能因延迟等错误或
                // ** 时机不对的情况下却收到了“未登陆”回复时，就会关闭心跳，但自动重新登陆
                // ** 却再也没有机会启动起来，那么这个客户端将会因此而永远（直到登陆程序后再登陆）
                // ** 无法重新登陆而一直处于离线状态，这就不对了。以下的启动重新登陆时机在此正
                // ** 可解决此种情况，而使得重新登陆机制更强壮哦！
                [[AutoReLoginDaemon sharedInstance] start:NO];
            }

            // 收到错误响应消息的回调
            if([ClientCoreSDK sharedInstance].chatTransDataEvent != nil)
            {
                [[ClientCoreSDK sharedInstance].chatTransDataEvent onErrorResponse:errorRes.errorCode withErrorMsg:errorRes.errorMsg];
            }
            break;
        }

        default:
            NSLog(@"【IMCORE】收到的服务端消息类型：%d，但目前该类型客户端不支持解析和处理！", pFromServer.type);
            break;
    }
}

// 私有方法
- (void) sendRecievedBack:(Protocal *)pFromServer
{
    if(pFromServer.fp != nil)
    {
        Protocal *p = [ProtocalFactory createRecivedBack:pFromServer.to toUserId:pFromServer.from withFingerPrint:pFromServer.fp andBridge:pFromServer.bridge];
        int sendCode = [[LocalUDPDataSender sharedInstance] sendCommonData:p];

        if(sendCode == COMMON_CODE_OK)
        {
            if([ClientCoreSDK isENABLED_DEBUG])
                NSLog(@"【IMCORE】【QoS】向%@发送%@包的应答包成功,from=%@ 【bridge?%d】！", pFromServer.from,pFromServer.fp, pFromServer.to, pFromServer.bridge);
        }
        else
        {
            if([ClientCoreSDK isENABLED_DEBUG])
                NSLog(@"【IMCORE】【QoS】向%@发送%@包的应答包失败了,错误码=%d！", pFromServer.from,pFromServer.fp, sendCode);
        }
    }
    else
    {
        NSLog(@"【IMCORE】【QoS】收到%@发过来需要QoS的包，但它的指纹码却为null！无法发应答包！", pFromServer.from);
    }
}

@end
