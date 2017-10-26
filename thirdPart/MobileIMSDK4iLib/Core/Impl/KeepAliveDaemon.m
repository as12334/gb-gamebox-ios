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
//  KeepAliveDaemon.m
//  MibileIMSDK4i_X (MobileIMSDK v3.0 at Summer 2017)
//
//  Created by JackJiang on 14/10/24.
//  Copyright (c) 2017年 52im.net. All rights reserved.
//

#import "KeepAliveDaemon.h"
#import "ToolKits.h"
#import "LocalUDPDataSender.h"
#import "ClientCoreSDK.h"


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 静态全局类变量
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
 * 收到服务端响应心跳包的超时间时间（单位：毫秒），默认（3000 * 3 + 1000）＝ 10000 毫秒.
 * <p>
 * 超过这个时间客户端将判定与服务端的网络连接已断开（此间隔建议为(KEEP_ALIVE_INTERVAL * 3) + 1 秒），
 * 没有上限，但不可太长，否则将不能即时反映出与服务器端的连接断开（比如掉掉线时），请从
 * 能忍受的反应时长和即时性上做出权衡。
 * <p>
 * 本参数除与{@link KeepAliveDaemon#KEEP_ALIVE_INTERVAL}有关联外，不受其它设置影响。
 */
static int NETWORK_CONNECTION_TIME_OUT = 10 * 1000;

/*
 * Keep Alive 心跳时间间隔（单位：毫秒），默认3000毫秒.
 * <p>
 * 心跳间隔越短则保持会话活性的健康度更佳，但将使得在大量客户端连接情况下服务端因此而增加负载，
 * 且手机将消耗更多电量和流量，所以此间隔需要权衡（建议为：>=1秒 且 < 300秒）！
 * <p>
 * 说明：此参数用于设定客户端发送到服务端的心跳间隔，心跳包的作用是用来保持与服务端的会话活性（
 * 更准确的说是为了避免客户端因路由器的NAT算法而导致UDP端口老化）.
 * <p>
 * 参定此参数的同时，也需要相应设置服务端的ServerLauncher.SESION_RECYCLER_EXPIRE参数。
 */
static int KEEP_ALIVE_INTERVAL = 3000;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 私有API
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface KeepAliveDaemon ()

/* 当前心跳线程是否正在执行中 */
@property (nonatomic, assign) BOOL keepAliveRunning;

// 记录最近一次服务端的心跳响应包时间
@property (nonatomic, assign) long lastGetKeepAliveResponseFromServerTimstamp;

/* 网络断开事件观察者 */
@property (nonatomic, copy) ObserverCompletion networkConnectionLostObserver_;// block代码块一定要用copy属性，否则报错！

/* !本属性仅作DEBUG之用：DEBUG事件观察者 */
@property (nonatomic, copy) ObserverCompletion debugObserver_;// block代码块一定要用copy属性，否则报错！

@property (nonatomic, assign) BOOL _excuting;

@property (nonatomic, retain) NSTimer *timer;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 本类的代码实现
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation KeepAliveDaemon

// 本类的单例对象
static KeepAliveDaemon *instance = nil;

+ (KeepAliveDaemon *)sharedInstance
{
    if (instance == nil)
    {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

+ (void) setKEEP_ALIVE_INTERVAL:(int)keepAliveTimeWithMils
{
    KEEP_ALIVE_INTERVAL = keepAliveTimeWithMils;
}
+ (int) getKEEP_ALIVE_INTERVAL
{
    return KEEP_ALIVE_INTERVAL;
}

+ (void) setNETWORK_CONNECTION_TIME_OUT:(int)networkConnectionTimeout
{
    NETWORK_CONNECTION_TIME_OUT = networkConnectionTimeout;
}
+ (int) getNETWORK_CONNECTION_TIME_OUT
{
    return NETWORK_CONNECTION_TIME_OUT;
}


//-----------------------------------------------------------------------------------
#pragma mark - 仅内部可调用的方法

- (id)init
{
    if (![super init])
        return nil;

    NSLog(@"KeepAliveDaemon已经init了！");

    // 内部变量初始化
    self.keepAliveRunning = NO;
    self.lastGetKeepAliveResponseFromServerTimstamp = 0;
    self._excuting = NO;

    return self;
}

- (void) run
{
    // 极端情况下本次循环内可能执行时间超过了时间间隔，此处是防止在前一
    // 次还没有运行完的情况下又重复过劲行，从而出现无法预知的错误
    if(!self._excuting)
    {
        BOOL willStop = NO;
        self._excuting = true;
        if([ClientCoreSDK isENABLED_DEBUG])
            NSLog(@"【IMCORE】心跳线程执行中...");
        int code = [[LocalUDPDataSender sharedInstance] sendKeepAlive];

        // form DEBUG
        if(self.debugObserver_ != nil)
            self.debugObserver_(nil, [NSNumber numberWithInt:2]);

        // 首先执行Keep Alive心跳包时，把此时的时间作为第1次收到服务响应的时间（初始化）
        BOOL isInitialedForKeepAlive = (self.lastGetKeepAliveResponseFromServerTimstamp == 0);
        if(code == 0 && self.lastGetKeepAliveResponseFromServerTimstamp == 0)
            self.lastGetKeepAliveResponseFromServerTimstamp = [ToolKits getTimeStampWithMillisecond_l];

        // 首先启动心跳时就不判断了，否则就是逻辑有问题
        if(!isInitialedForKeepAlive)
        {
            long now = [ToolKits getTimeStampWithMillisecond_l];
            // 当当前时间与最近一次服务端的心跳响应包时间间隔>= 10秒就判定当前与服务端的网络连接已断开
            if(now - self.lastGetKeepAliveResponseFromServerTimstamp >= NETWORK_CONNECTION_TIME_OUT)
            {
                // 先停止心跳线程
                [self stop];
                // 再通知“网络连接已断开”
                if(self.networkConnectionLostObserver_ != nil)
                    self.networkConnectionLostObserver_(nil, nil);

                willStop = YES;
            }
        }

        //
        self._excuting = NO;
        if(!willStop)
        {
            // 开始下一个心跳循环
            ; // do nothing
        }
        else
        {
            [self stop];
        }
    }
}

- (void) stop
{
    //
    if(self.timer != nil)
    {
        if([self.timer isValid])
            [self.timer invalidate];

        self.timer = nil;
    }
    //
    self.keepAliveRunning = NO;
    //
    self.lastGetKeepAliveResponseFromServerTimstamp = 0;

    // for DEBUG
    if(self.debugObserver_ != nil)
        self.debugObserver_(nil, [NSNumber numberWithInt:0]);
}

- (void) start:(BOOL)immediately
{
    //
    [self stop];

    // 注意：执行延迟的单位是秒哦
    self.timer = [NSTimer scheduledTimerWithTimeInterval:KEEP_ALIVE_INTERVAL / 1000 target:self selector:@selector(run) userInfo:nil repeats:YES];
    // 如果需要立即执行
    if(immediately)
       [self.timer fire];
    //
    self.keepAliveRunning = YES;

    // form DEBUG
    if(self.debugObserver_ != nil)
        self.debugObserver_(nil, [NSNumber numberWithInt:1]);
}

- (BOOL) isKeepAliveRunning
{
    return self.keepAliveRunning;
}

- (void) updateGetKeepAliveResponseFromServerTimstamp
{
    self.lastGetKeepAliveResponseFromServerTimstamp = [ToolKits getTimeStampWithMillisecond_l];//System.currentTimeMillis();
}

- (void) setNetworkConnectionLostObserver:(ObserverCompletion)networkConnLostObserver
{
    self.networkConnectionLostObserver_ = networkConnLostObserver;
}

- (void) setDebugObserver:(ObserverCompletion)debugObserver
{
    self.debugObserver_ = debugObserver;
}

@end
