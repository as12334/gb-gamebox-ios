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
//  ProtocalQoS4ReciveProvider.m
//  MibileIMSDK4i_X (MobileIMSDK v3.0 at Summer 2017)
//
//  Created by JackJiang on 14/10/23.
//  Copyright (c) 2017年 52im.net. All rights reserved.
//

#import "QoS4ReciveDaemon.h"
#import "ClientCoreSDK.h"
#import "ToolKits.h"
#import "Protocal.h"
#import "NSMutableDictionary+Ext.h"


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 静态全局类变量
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/* 检查线程执行间隔（单位：毫秒），默认5分钟 */
static int CHECK_INTERVAL = 5 * 60 * 1000; // 5分钟

/* 一个消息放到在列表中（用于判定重复时使用）的生存时长（单位：毫秒），默认10分钟 */
static int MESSAGES_VALID_TIME = 10 * 60 * 1000;// 10分钟


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 私有API
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface ProtocalQoS4ReciveProvider ()

/*
 * 时间间隔内接收到的需要QoS质量保证的消息指纹特征列表.
 * key=消息包指纹码，value=最近1次收到该包的时间戳（时间戳用于判定该包是否已失效时有
 * 用（形如java泛型<String, Long>），收到重复包时用最近一次收到时间更新时间戳从而最
 * 大限度保证不重复） */
@property (nonatomic, retain) NSMutableDictionary *recievedMessages;

/* 当前线程是否正在执行中 */
@property (nonatomic, assign) BOOL running;

@property (nonatomic, assign) BOOL _excuting;

@property (nonatomic, retain) NSTimer *timer;

/* !本属性仅作DEBUG之用：DEBUG事件观察者 */
@property (nonatomic, copy) ObserverCompletion debugObserver_;// block代码块一定要用copy属性，否则报错！

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 本类的代码实现
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation ProtocalQoS4ReciveProvider

// 本类的单例对象
static ProtocalQoS4ReciveProvider *instance = nil;

+ (ProtocalQoS4ReciveProvider *)sharedInstance
{
    if (instance == nil)
    {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}


//-----------------------------------------------------------------------------------
#pragma mark - 仅内部可调用的方法

- (id)init
{
    if (![super init])
        return nil;

    NSLog(@"ProtocalQoS4ReciveProvider已经init了！");

    // 内部变量初始化
    self.running = NO;
    self._excuting = NO;
    self.recievedMessages = [[NSMutableDictionary alloc] init];

    return self;
}

- (void) run
{
    // 极端情况下本次循环内可能执行时间超过了时间间隔，此处是防止在前一
    // 次还没有运行完的情况下又重复过劲行，从而出现无法预知的错误
    if(!self._excuting)
    {
        self._excuting = YES;

        if([ClientCoreSDK isENABLED_DEBUG])
            NSLog(@"【IMCORE】【QoS接收方】++++++++++ START 暂存处理线程正在运行中，当前长度 %li", (unsigned long)[self.recievedMessages count]);

        // ** 【重要说明】直接对NSMutableDistionary进行删除时可能会出现并发删除而崩溃的问题："*** Terminating app due to uncaught exception 'NSGenericException', reason: '*** Collection <__NSDictionaryM: 0x1001098a0> was mutated while being enumerated.'"，以下代码用NSArray替代NSEnumerator来遍历key就是为了解决这个问题
        //先得到里面所有的键值   objectEnumerator得到里面的对象  keyEnumerator得到里面的键值
//        NSEnumerator * enumerator = [self.recievedMessages keyEnumerator];
//        while(key = [enumerator nextObject])
        NSArray *keyArr = [self.recievedMessages allKeys];//只要增加这一个就可以解决问题了，相对比较方便
        for (NSString *key in keyArr)//修改dic为keyArr，这样枚举的时候使用的是keyArr，修改的是另一个
        {
            NSNumber *objectValue = [self.recievedMessages objectForKey:key];
            long delta = [ToolKits getTimeStampWithMillisecond_l] - objectValue.longValue;
            // 该消息包超过了生命时长，去掉之
            if(delta >= MESSAGES_VALID_TIME)
            {
                if([ClientCoreSDK isENABLED_DEBUG])
                    NSLog(@"【IMCORE】【QoS接收方】指纹为%@的包已生存%li 毫秒(最大允许%d毫秒), 马上将删除之.", key, delta, MESSAGES_VALID_TIME);

                [self.recievedMessages removeObjectForKey:key];
            }
        }
    }

    if([ClientCoreSDK isENABLED_DEBUG])
        NSLog(@"【IMCORE】【QoS接收方】++++++++++ END 暂存处理线程正在运行中，当前长度 %li", (unsigned long)[self.recievedMessages count]);

    //
    self._excuting = NO;

    // form DEBUG
    if(self.debugObserver_ != nil)
        self.debugObserver_(nil, [NSNumber numberWithInt:2]);
}

- (void) putImpl:(NSString *)fingerPrintOfProtocal
{
    if(fingerPrintOfProtocal != nil)
        // key=指纹码，value=当前时间戳的长整性表示
        [self.recievedMessages setValue:[NSNumber numberWithLong:[ToolKits getTimeStampWithMillisecond_l]] forKey:fingerPrintOfProtocal];
}


//-----------------------------------------------------------------------------------
#pragma mark - 外部可调用的方法

- (void) startup:(BOOL)immediately
{
    //
    [self stop];

    // ** 如果列表不为空则尝试重置生成起始时间
    // 当重启时列表可能是不为空的（此场景目前出现在掉线后重新恢复时），
    // 那么为了防止在网络状况不好的情况下，登陆能很快恢复时对方可能存在
    // 的重传，此时也能一定程序避免消息重复的可能
    if(self.recievedMessages != nil && [self.recievedMessages count] > 0)
    {
        // ** 【重要说明】以下代码将枚举改成间接key读取的目的是避免问题：“*** Terminating app due to uncaught exception 'NSGenericException', reason: '*** Collection <__NSDictionaryM: 0x175a8040> was mutated while being enumerated.'”的出现。
//        //先得到里面所有的键值   objectEnumerator得到里面的对象  keyEnumerator得到里面的键值
//        NSEnumerator * enumerator = [self.recievedMessages keyEnumerator];
//        NSString *key = nil;
//        while(key = [enumerator nextObject])
        NSArray *keyArr = [self.recievedMessages allKeys];//只要增加这一个就可以解决问题了，相对比较方便
        for (NSString *key in keyArr)//修改dic为keyArr，这样枚举的时候使用的是keyArr，修改的是另一个
        {
            // 重置列表中的生存起始时间
            [self putImpl:key];
        }
    }

    // 注意：执行延迟的单位是秒哦
    self.timer = [NSTimer scheduledTimerWithTimeInterval:CHECK_INTERVAL / 1000 target:self selector:@selector(run) userInfo:nil repeats:YES];
    // 如果需要立即执行
    if(immediately)
        [self.timer fire];
    //
    self.running = YES;

    // form DEBUG
    if(self.debugObserver_ != nil)
        self.debugObserver_(nil, [NSNumber numberWithInt:1]);
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
    self.running = NO;

    // form DEBUG
    if(self.debugObserver_ != nil)
        self.debugObserver_(nil, [NSNumber numberWithInt:0]);
}

- (BOOL) isRunning
{
    return self.running;
}

- (void) addRecieved:(Protocal *)p
{
    if(p != nil && p.QoS)
        [self addRecievedWithFingerPrint:p.fp];
}

- (void) addRecievedWithFingerPrint:(NSString *) fingerPrintOfProtocal
{
    if(fingerPrintOfProtocal == nil)
    {
        NSLog(@"【IMCORE】无效的 fingerPrintOfProtocal==null!");
        return;
    }

    if([self.recievedMessages containsKey:fingerPrintOfProtocal])
        NSLog(@"【IMCORE】【QoS接收方】指纹为 %@ 的消息已经存在于接收列表中，该消息重复了（原理可能是对方因未收到应答包而错误重传导致），更新收到时间戳哦.", fingerPrintOfProtocal);

    // 无条件放入已收到列表（如果已存在则覆盖之，已在存则意味着消息重复被接收，那么就用最新的时间戳更新之）
    [self putImpl:fingerPrintOfProtocal];
}

- (BOOL) hasRecieved:(NSString *) fingerPrintOfProtocal
{
    return [self.recievedMessages containsKey:fingerPrintOfProtocal];
}

- (unsigned long) size
{
    return [self.recievedMessages count];
}

- (void) setDebugObserver:(ObserverCompletion)debugObserver
{
    self.debugObserver_ = debugObserver;
}


@end
