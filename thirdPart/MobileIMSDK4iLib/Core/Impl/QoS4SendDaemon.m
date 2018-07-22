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
//  ProtocalQoS4SendProvider.m
//  MibileIMSDK4i_X (MobileIMSDK v3.0 at Summer 2017)
//
//  Created by JackJiang on 14/10/24.
//  Copyright (c) 2017年 52im.net. All rights reserved.
//

#import "QoS4SendDaemon.h"
#import "ClientCoreSDK.h"
#import "Protocal.h"
#import "NSMutableDictionary+Ext.h"
#import "LocalUDPDataSender.h"
#import "ErrorCode.h"
#import "CompletionDefine.h"
#import "ToolKits.h"


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 静态全局类变量
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
 * QoS质量保证线程心跳间隔（单位：毫秒），默认5000ms.
 * <p>
 * 间隔越短则为用户重发越即时，但将使得重复发送的可能性增大（因为可能在应答
 * 包尚在途中时就判定丢包了的错误情况），当然，即使真存在重复发送的可能也是无害的
 * ，因为MobileIMSDK的QoS机制本身就有防重能力。请根据您的应用所处的网络延迟情况进行
 * 权衡，本参数为非关键参数，如无特殊情况则建议无需调整本参数。
 */
static int CHECK_INTERVAL = 5000;

/*
 * “刚刚”发出的消息阀值定义（单位：毫秒），默认3000毫秒。
 * <b>注意：此值通常无需由开发者自行设定，保持默认即可。</b>
 * <p>
 * 此阀值的作用在于：在QoS=true的情况下，一条刚刚发出的消息会同时保存到本类中的QoS保证队列，
 * 在接收方的应答包还未被发出方收到时（已经发出但因为存在数十毫秒的网络延迟，应答包正在路上）
 * ，恰好遇到本次QoS质量保证心跳间隔的到来，因为之前的QoS队列罗辑是只要存在本队列中还未被去掉
 * 的包，就意味着是要重传的——那么此逻辑在我们本次讨论的情况下就存在漏洞而导致没有必要的重传了。
 * 如果有本阀值存在，则即使刚刚发出的消息刚放到QoS队列就遇到QoS心跳到来，则只要当前放入队列的时间
 * 小于或等于本值，就可以被认为是刚刚放入，那么也就避免被误重传了。
 * <p>
 * 基于以上考虑，本值的定义，只要设定这大于一条消息的发出起到收到它应答包为止这样一个时间间隔即可
 * （其实就相于一个客户端到服务端的网络延迟时间4倍多一点点即可）。
 * 此处定为3秒其实是为了保守望起见哦。
 * <p>
 * 本参数将决定真正因为UDP丢包而重传的即时性问题，即当MobileIMSDK的UDP丢包时，QoS首次重传的
 * 响应时间为大于 {@link #MESSAGES_JUST$NOW_TIME} 而 小于等于 {@link #CHECH_INTERVAL}。
 *
 * @author Jack Jiang, 2015-11-04 17:27
 * @since 2.1.1
 */
static int MESSAGES_JUST$NOW_TIME = 3 * 1000;

/*
 * 一个包允许的最大重发次数，默认2次。
 * <p>
 * 次数越多，则整个UDP的可靠性越好，但在网络确实很烂的情况下可能会导致重传的泛滥而失去
 * “即时”的意义。请根据网络状况和应用体验来权衡设定，本参数为0表示不重传，建议使用1到5
 * 之间的数字。
 */
static int QOS_TRY_COUNT = 2;// since 3.0 (20160918): 为了降低服务端负载，本参数由原3调整为2


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 私有API
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface ProtocalQoS4SendProvider ()

// Hash表，因为本类中可能存在不同的线程同时remove或遍历之，注意同步问题
/*
 * 本对象中的key=指纹码，value=Protocal对象。
 */
@property (nonatomic, retain) NSMutableDictionary *sentMessages;

// Hash表，因为本类中可能存在不同的线程同时remove或遍历之，注意同步问题
/*
 * 本Hash表目前仅用于QoS重传判断是否是“刚刚”发出的消息之用，别无它用。
 * <p>
 * 本对象中的key=指纹码，value=该包发送出去时的时间戳（时间戳用于判定该包是否是“刚刚”发出的
 * （形如java泛型<String, Long>），依据此戳可在算法中避免“刚刚”发出的消息不被错误地重传）。
 *
 * @author Jack Jiang, 2015-11-04 17:25
 * @see MESSAGES_JUST$NOW_TIME
 * @since 2.1.1
 */
@property (nonatomic, retain) NSMutableDictionary *sendMessagesTimestamp;

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

@implementation ProtocalQoS4SendProvider

// 本类的单例对象
static ProtocalQoS4SendProvider *instance = nil;

+ (ProtocalQoS4SendProvider *)sharedInstance
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

    NSLog(@"ProtocalQoS4SendProvider已经init了！");

    // 内部变量初始化
    self.running = NO;
    self._excuting = NO;
    self.sentMessages = [[NSMutableDictionary alloc] init];
    self.sendMessagesTimestamp = [[NSMutableDictionary alloc] init];

    return self;
}

- (void) run
{
    // 极端情况下本次循环内可能执行时间超过了时间间隔，此处是防止在前一
    // 次还没有运行完的情况下又重复执行，从而出现无法预知的错误
    if(!self._excuting)
    {
        // 丢包列表
        NSMutableArray *lostMessages = [[NSMutableArray alloc] init];
        self._excuting = true;

        if([ClientCoreSDK isENABLED_DEBUG])
            NSLog(@"【IMCORE】【QoS】=========== 消息发送质量保证线程运行中, 当前需要处理的列表长度为 %li ...", (unsigned long)[self.sentMessages count]);

        // 开始处理中 ************************************************
//        NSEnumerator * enumerator = [self.sentMessages keyEnumerator];
//        NSString *key = nil;
//        while(key = [enumerator nextObject])
        // ** 【重要说明】直接对NSMutableDistionary进行删除时可能会出现并发删除而崩溃的问题："*** Terminating app due to uncaught exception 'NSGenericException', reason: '*** Collection <__NSDictionaryM: 0x1001098a0> was mutated while being enumerated.'"，以下代码用NSArray替代NSEnumerator来遍历key就是为了解决这个问题
        // 先得到里面所有的键值   objectEnumerator得到里面的对象  keyEnumerator得到里面的键值
        NSArray *keyArr = [self.sentMessages allKeys];//只要增加这一个就可以解决问题了，相对比较方便
        for (NSString *key in keyArr)//修改dic为keyArr，这样枚举的时候使用的是keyArr，修改的是另一个
        {
            Protocal *p = [self.sentMessages objectForKey:key];
            if(p != nil && p.QoS == YES)
            {
                // 达到或超过了最大重试次数（判定丢包）
                if([p getRetryCount] >= QOS_TRY_COUNT)
                {
                    if([ClientCoreSDK isENABLED_DEBUG])
                        NSLog(@"【IMCORE】【QoS】指纹为 %@ 的消息包重传次数已达 %d (最多 %d 次)上限，将判定为丢包！", p.fp, [p getRetryCount], QOS_TRY_COUNT);

                    // 将这个包加入到丢包列表（该Protocal对象将是一个clone的全新对象而非原来的引用哦！）
                    [lostMessages addObject:[p clone]];

                    // 从列表中称除之
                    [self remove:p.fp];
                }
                // 没有达到重传上限则开始进行重传
                else
                {
                    //### 2015104 Bug Fix: 解决了无线网络延较大时，刚刚发出的消息在其应答包还在途中时被错误地进行重传
                    NSNumber *objectValue = [self.sendMessagesTimestamp objectForKey:key];
                    long delta = [ToolKits getTimeStampWithMillisecond_l] - objectValue.longValue;
                    // 该消息包是“刚刚”发出的，本次不需要重传它哦
                    if(delta <= MESSAGES_JUST$NOW_TIME)
                    {
                        if([ClientCoreSDK isENABLED_DEBUG])
                            NSLog(@"【IMCORE】【QoS】指纹为%@的包距\"刚刚\"发出才%li ms(<=%d ms将被认定是\"刚刚\"), 本次不需要重传哦.", key, delta, MESSAGES_JUST$NOW_TIME);
                    }
                    //### 2015104 Bug Fix END
                    else
                    {
                        int sendCode = [[LocalUDPDataSender sharedInstance] sendCommonData:p];
                        // 已成功重传
                        if(sendCode == COMMON_CODE_OK)
                        {
                            // 重传次数+1
                            [p increaseRetryCount];

                            if([ClientCoreSDK isENABLED_DEBUG])
                                NSLog(@"【IMCORE】【QoS】指纹为%@的消息包已成功进行重传，此次之后重传次数已达%d(最多%d次).", p.fp, [p getRetryCount], QOS_TRY_COUNT);
                        }
                        else
                        {
                            NSLog(@"【IMCORE】【QoS】指纹为%@的消息包重传失败，它的重传次数之前已累计为%d(最多%d次).", p.fp, [p getRetryCount], QOS_TRY_COUNT);
                        }
                    }
                }
            }
            // value值为null，从列表中去掉吧
            else
            {
//                [self.sentMessages removeObjectForKey:key];
                [self remove:key];
            }
        }

        if(lostMessages != nil && [lostMessages count] > 0)
            // 通知观察者这些包丢包了（目标接收者没有收到）
            [self notifyMessageLost:lostMessages];

        //
        self._excuting = NO;

        // form DEBUG
        if(self.debugObserver_ != nil)
            self.debugObserver_(nil, [NSNumber numberWithInt:2]);
    }
}

/*
 * 将未送达信息反馈给消息监听者。
 *
 * @param lostMessages 已被判定为“消息未送达”的消息列表
 * @see {@link ClientCoreSDK.getInstance().getMessageQoSEvent()}
 */
- (void) notifyMessageLost:(NSMutableArray *)lostMsgs
{
    if([ClientCoreSDK sharedInstance].messageQoSEvent != nil)
    {
        [[ClientCoreSDK sharedInstance].messageQoSEvent messagesLost:lostMsgs];
    }
}


//-----------------------------------------------------------------------------------
#pragma mark - 外部可调用的方法

- (void) startup:(BOOL)immediately
{
    //
    [self stop];

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

- (BOOL) exist:(NSString *)fingerPrint
{
    return [self.sentMessages containsKey:fingerPrint];
}

- (void) put:(Protocal *)p
{
    if(p == nil)
    {
        NSLog(@"Invalid arg p==null.");
        return;
    }
    if(p.fp == nil)
    {
        NSLog(@"Invalid arg p.getFp() == null.");
        return;
    }

    if(!p.QoS)
    {
        NSLog(@"This protocal is not QoS pkg, ignore it!");
        return;
    }

    // 如果列表中已经存则仅提示（用于debug）
    if([self.sentMessages containsKey:p.fp])
        NSLog(@"【IMCORE】【QoS】指纹为 %@ 的消息已经放入了发送质量保证队列，该消息为何会重复？（生成的指纹码重复？还是重复put？）", p.fp);

    // save it
    [self.sentMessages setObject:p forKey:p.fp];
    // 同时保存时间戳
    [self.sendMessagesTimestamp setObject:[NSNumber numberWithLong:[ToolKits getTimeStampWithMillisecond_l]] forKey:p.fp];
}

- (void) remove:(NSString *) fingerPrint
{
    // remove it
    if([self.sentMessages containsKey:fingerPrint])
    {
        Protocal *p = [self.sentMessages objectForKey:fingerPrint];
        [self.sendMessagesTimestamp removeObjectForKey:fingerPrint];
        [self.sentMessages removeObjectForKey:fingerPrint];
        NSLog(@"【IMCORE】【QoS】指纹为%@的消息已成功从发送质量保证队列中移除(可能是收到接收方的应答也可能是达到了重传的次数上限)，重试次数=%d", fingerPrint, [p getRetryCount]);
    }
    else
    {
        NSLog(@"【IMCORE】【QoS】指纹为%@的消息已成功从发送质量保证队列中移除(可能是收到接收方的应答也可能是达到了重传的次数上限)，重试次数=none呵呵.", fingerPrint);
    }
}

- (unsigned long) size
{
    return [self.sentMessages count];
}

- (void) setDebugObserver:(ObserverCompletion)debugObserver
{
    self.debugObserver_ = debugObserver;
}


@end
