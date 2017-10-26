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
//  AutoReLoginDaemon.m
//  MibileIMSDK4i_X (MobileIMSDK v3.0 at Summer 2017)
//
//  Created by JackJiang on 14/10/24.
//  Copyright (c) 2017年 52im.net. All rights reserved.
//

#import "AutoReLoginDaemon.h"
#import "ClientCoreSDK.h"
#import "LocalUDPDataSender.h"
#import "LocalUDPDataReciever.h"


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 静态全局类变量
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
 * 自动重新登陆时间间隔（单位：毫秒），默认2000毫秒。
 * <p>
 * 此参数只会影响断线后与服务器连接的即时性，不受任何配置参数
 * 的影响。请基于重连（重登陆）即时性和手机能耗上作出权衡。
 * <p>
 * 除非对MobileIMSDK的整个即时通讯算法非常了解，否则请勿尝试单独设置本参数。如
 * 需调整心跳频率请见 @link ConfigEntity @/link
 * setSenseMode:ConfigEntity.SenseMode。
 */
static int AUTO_RE_LOGIN_INTERVAL = 2000;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 私有API
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface AutoReLoginDaemon ()

/* 当前心跳线程是否正在执行中 */
@property (nonatomic, assign) BOOL autoReLoginRunning;

@property (nonatomic, assign) BOOL _excuting;

@property (nonatomic, retain) NSTimer *timer;

/* !本属性仅作DEBUG之用：DEBUG事件观察者 */
@property (nonatomic, copy) ObserverCompletion debugObserver_;// block代码块一定要用copy属性，否则报错！

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 本类的代码实现
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation AutoReLoginDaemon

// 本类的单例对象
static AutoReLoginDaemon *instance = nil;

+ (AutoReLoginDaemon *)sharedInstance
{
    if (instance == nil)
    {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

+ (void) setAUTO_RE_LOGIN_INTERVAL:(int)autoReLoginInterval
{
    AUTO_RE_LOGIN_INTERVAL = autoReLoginInterval;
}
+ (int) getAUTO_RE_LOGIN_INTERVAL
{
    return AUTO_RE_LOGIN_INTERVAL;
}

//-----------------------------------------------------------------------------------
#pragma mark - 仅内部可调用的方法

- (id)init
{
    if (![super init])
        return nil;

    NSLog(@"AutoReLoginDaemon已经init了！");

    // 内部变量初始化
    self.autoReLoginRunning = NO;
    self._excuting = NO;

    return self;
}

- (void) run
{
    if(!self._excuting)
    {
        self._excuting = YES;
        if([ClientCoreSDK isENABLED_DEBUG])
            NSLog(@"【IMCORE】自动重新登陆线程执行中, autoReLogin? %d...", [ClientCoreSDK isAutoReLogin]);
        int code = -1;
        // 是否允许自动重新登陆哦
        if([ClientCoreSDK isAutoReLogin])
        {
            NSString *curLoginUserId = [ClientCoreSDK sharedInstance].currentLoginUserId;
            NSString *curLoginToken = [ClientCoreSDK sharedInstance].currentLoginToken;
            NSString *curLoginExtra = [ClientCoreSDK sharedInstance].currentLoginExtra;
            code = [[LocalUDPDataSender sharedInstance] sendLogin:curLoginUserId withToken:curLoginToken andExtra:curLoginExtra];

            // form DEBUG
            if(self.debugObserver_ != nil)
                self.debugObserver_(nil, [NSNumber numberWithInt:2]);
        }

        if(code == 0)
        {
            // * 不同于Andrid平台，iOS下的UDP接收数据无需自行管理线程，利用GCDAsycUDPSocket的异步机制即可
//          // *********************** 同样的代码也存在于LocalUDPDataSender.SendLoginDataAsync中的代码
//          // 登陆消息成功发出后就启动本地消息侦听线程：
//          // 第1）种情况：首次使用程序时，登陆信息发出时才启动本地监听线程是合理的；
//          // 第2）种情况：因网络原因（比如服务器关闭或重启）而导致本地监听线程中断的问题：
//          //      当首次登陆后，因服务端或其它网络原因导致本地监听出错，将导致中断本地监听线程，
//          //	          所以在此处在自动登陆重连或用户自已手机尝试再次登陆时重启监听线程就可以恢复本地
//          //	          监听线程的运行。
//          [[LocalUDPDataReciever sharedInstance] startup];

             if([ClientCoreSDK isENABLED_DEBUG])
                 NSLog(@"【IMCORE】自动重新登陆数据包已发出(iOS上无需自已启动UDP接收线程, GCDAsyncUDPTask自行解决了).");
        }

        //
        self._excuting = NO;
    }
}

//-----------------------------------------------------------------------------------
#pragma mark - 外部可调用的方法

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
    self.autoReLoginRunning = NO;

    // form DEBUG
    if(self.debugObserver_ != nil)
        self.debugObserver_(nil, [NSNumber numberWithInt:0]);
}

- (void) start:(BOOL)immediately
{
    //
    [self stop];

    // 注意：执行延迟的单位是秒哦
    self.timer = [NSTimer scheduledTimerWithTimeInterval:AUTO_RE_LOGIN_INTERVAL / 1000
                                                  target:self
                                                selector:@selector(run)
                                                userInfo:nil
                                                 repeats:YES];
    // 如果需要立即执行
    if(immediately)
        [self.timer fire];
    //
    self.autoReLoginRunning = YES;

    // form DEBUG
    if(self.debugObserver_ != nil)
        self.debugObserver_(nil, [NSNumber numberWithInt:1]);
}

- (BOOL) isAutoReLoginRunning
{
    return self.autoReLoginRunning;
}

- (void) setDebugObserver:(ObserverCompletion)debugObserver
{
    self.debugObserver_ = debugObserver;
}

@end
