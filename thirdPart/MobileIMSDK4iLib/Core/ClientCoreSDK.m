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
//  ClientCoreSDK.m
//  MibileIMSDK4i_X (MobileIMSDK v3.0 at Summer 2017)
//
//  Created by JackJiang on 14/10/21.
//  Copyright (c) 2017年 52im.net. All rights reserved.
//

#import "ClientCoreSDK.h"
#import "ChatTransDataEvent.h"
#import "ChatBaseEvent.h"
#import "MessageQoSEvent.h"
#import "Reachability.h"
#import "QoS4SendDaemon.h"
#import "KeepAliveDaemon.h"
#import "LocalUDPDataReciever.h"
#import "LocalUDPSocketProvider.h"
#import "QoS4ReciveDaemon.h"
#import "AutoReLoginDaemon.h"


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 静态全局类变量
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/* true表示开启MobileIMSDK Debug信息在控制台下的输出，否则关闭。默认为NO. */
static BOOL ENABLED_DEBUG = NO;

/*
 * 是否在登陆成功后掉线时自动重新登陆线程中实质性发起登陆请求，true表示将在线程
 * 运行周期中正常发起，否则不发起（即关闭实质性的重新登陆请求）。
 * <p>
 * 什么样的场景下，需要设置本参数为false？比如：上层应用可以在自已的节电逻辑中控
 * 制当网络长时断开时就不需要实质性发起登陆请求了，因为 网络请求是非常耗电的。
 * <p>
 * <b>本参数的设置将实时生效。</b>
 */
static BOOL autoReLogin = YES;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 私有API
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ClientCoreSDK ()

/*
 * 当调用 @link initCore @/link 方法后本字段将被置为true，调用 @link releaseCore @/link
 * 时将被重新置为false.
 * <br>
 * <b>本参数由框架自动设置。</b>
 */
@property (nonatomic) BOOL _init;

// 网络状态检测类
@property (nonatomic) Reachability *internetReachability;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 本类的代码实现
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ClientCoreSDK

// 本类的单例对象
static ClientCoreSDK *instance = nil;

+ (ClientCoreSDK *)sharedInstance
{
    if (instance == nil)
    {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

// OC中访问全局static变量需通方法
+ (BOOL) isENABLED_DEBUG
{
    return ENABLED_DEBUG;
}
+ (void) setENABLED_DEBUG:(BOOL)enabledDebug
{
    ENABLED_DEBUG = enabledDebug;
}

// OC中访问全局static变量需通方法
+ (BOOL) isAutoReLogin
{
    return autoReLogin;
}
+ (void) setAutoReLogin:(BOOL)arl
{
    autoReLogin = arl;
}

/*
 *  @Author Jack Jiang, 14-10-30 11:10:48
 *
 *  iOS中的此方法不同于Android版的同名方法，与Android版init方法对应的是本类中的initCore方法
 *
 *  @return
 *  @see [NSObject init:]
 */
- (id)init
{
    if (![super init])
        return nil;

//    NSLog(@"ClientCoreSDK已经init了！");

//    // 内部变量初始化
//    [self initCore];

    return self;
}

- (void)initCore
{
    if(!self._init)
    {
        // 变量初始化
        self.localDeviceNetworkOk = NO;
        self.connectedToServer = NO;
        self.loginHasInit = NO;

        if(self.internetReachability == nil)
        {
            // 网络检测类初始化
            /*
             Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
             */
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
            self.internetReachability = [Reachability reachabilityForInternetConnection];
        }
        [self.internetReachability startNotifier];
        // 本地网络状态初始化
        self.localDeviceNetworkOk = [self internetReachable];

        //
        self._init = YES;

        NSLog(@"ClientCoreSDK已经完成initCore了！");
    }
}

- (void) releaseCore
{
    // 尝试停掉掉线重连线程（如果线程正在运行的话）
    [[AutoReLoginDaemon sharedInstance] stop]; // 2014-11-08 add by Jack Jiang
    // 尝试停掉QoS质量保证（发送）心跳线程
    [[ProtocalQoS4SendProvider sharedInstance] stop];
    // 尝试停掉Keep Alive心跳线程
    [[KeepAliveDaemon sharedInstance] stop];
//    // 尝试停掉消息接收者
//    [[LocalUDPDataReciever sharedInstance] stop];
    // 尝试停掉QoS质量保证（接收防重复机制）心跳线程
    [[ProtocalQoS4ReciveProvider sharedInstance] stop];
    // 尝试关闭本地Socket
    [[LocalUDPSocketProvider sharedInstance] closeLocalUDPSocket];

    // Unregister network broadcast listeners
    [self.internetReachability stopNotifier];

    //
    self._init = NO;
    //
    self.loginHasInit = NO;
    self.connectedToServer = NO;
}


#pragma mark -  公开的方法

- (BOOL) isInitialed
{
    return self._init;
}

// 网络是否正常
- (BOOL)internetReachable
{
    NetworkStatus netStatus = [self.internetReachability currentReachabilityStatus];
//    BOOL connectionRequired = [self.internetReachability connectionRequired];
    return netStatus == ReachableViaWWAN || netStatus == ReachableViaWiFi;
}

/*
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* reachability = [note object];
    NSParameterAssert([reachability isKindOfClass:[Reachability class]]);

    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    NSString* statusString = @"";

    switch (netStatus)
    {
        case NotReachable:
        {
            statusString = NSLocalizedString(@"【IMCORE】【本地网络通知】检测本地网络连接断开了!", @"Text field text for access is not available");
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            connectionRequired = NO;

            //
            self.localDeviceNetworkOk = false;
            // 尝试关闭本地Socket（以便等网络恢复时能重新建立Socket，也就间接达到了重置网络的能力）
            [[LocalUDPSocketProvider sharedInstance] closeLocalUDPSocket];

            break;
        }

        case ReachableViaWWAN: // 蜂窝网络、3G网络等
        case ReachableViaWiFi: // WIFI
        {
            int wifi = (netStatus == ReachableViaWiFi);
            statusString= [NSString stringWithFormat:NSLocalizedString(@"【IMCORE】【本地网络通知】检测本地网络已连接上了! WIFI? %d", @""), wifi?@"YES":@"NO"];

            //
            self.localDeviceNetworkOk = true;
            // ** 尝试关闭本地Socket（以便等网络恢复时能重新建立Socket，也就间接达到了重置网络的能力）
            // 【此处可以解决以下场景问题：】当用户成功登陆后，本地网络断开了，则此时自动重连机制已启动，
            // 而本地侦听的开启是在登陆信息成功发出时（本地网络连好后，信息是可以发出的）启动的，而
            // 收到网络连接好的消息可能要滞后于真正的网络连接好（那此时间间隔内登陆数据可以成功发出）
            // ，那么此时出果启动侦听则必须导致侦听不可能成功。以下代码保证在收到网络连接消息时，先无条件关闭
            // 网络连接，当下一个自动登陆循环到来时自然就重新建立Socket了，那么此时重新登陆消息发出后再
            // 启动UDP侦听就ok了。--> 说到底，关闭网络连接就是为了在下次使用网络时无条件重置Socket，从而保证
            // Socket被建立时是处于正常的网络状况下。
            [[LocalUDPSocketProvider sharedInstance] closeLocalUDPSocket];

            break;
        }
    }

    if (connectionRequired)
    {
        NSString *connectionRequiredFormatString = NSLocalizedString(@"【IMCORE】%@, Connection Required", @"Concatenation of status string with connection requirement");
        statusString = [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }

    if(ENABLED_DEBUG)
        NSLog(@"%@", statusString);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
