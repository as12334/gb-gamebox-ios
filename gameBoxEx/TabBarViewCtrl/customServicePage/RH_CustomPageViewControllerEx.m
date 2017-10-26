//
//  RH_CustomPageViewControllerEx.m
//  gameBoxEx
//
//  Created by luis on 2017/10/18.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_CustomPageViewControllerEx.h"
#import "RH_ChatInputBar.h"
#import "ConfigEntity.h"
#import "ClientCoreSDK.h"
#import "LocalUDPDataSender.h"
#import "RH_IMMessageModel.h"
#import "RH_IMMessageTableCell.h"

static CGFloat const kChatViewInputBarHeight = 50.0;

@interface RH_CustomPageViewControllerEx ()<RH_ChatInputBarDelegate>
@property(nonatomic,readonly,strong) RH_ChatInputBar *chatInputBarView  ;
@property(nonatomic,strong,readonly) NSMutableArray<RH_IMMessageModel*> *messageList ;
@end

@implementation RH_CustomPageViewControllerEx
{
    NSString *_customDomain ;
    NSString *_customPort  ;
    NSString *_userID ;
    NSString *_userPwd ;
}
@synthesize chatInputBarView = _chatInputBarView ;
@synthesize messageList = _messageList           ;
- (void)viewDidLoad {
    [super viewDidLoad];
    _customDomain = @"rbcore.52im.net" ;
    _customPort = @"7901" ;
    _userID = @"testUser" ;
    _userPwd = @"123456"  ;

    // Do any additional setup after loading the view from its nib.
    self.title = @"在线客服" ;
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO] ;
    [self.contentTableView registerCellWithClass:[RH_IMMessageTableCell class]] ;
    self.contentTableView.delegate = self ;
    self.contentTableView.dataSource = self ;

    [self.contentView addSubview:self.contentTableView] ;
    [self.view addSubview:self.chatInputBarView] ;

    self.needObserverKeyboard = YES ;
    self.adjustFrameBasicKeyboardView = self.contentTableView ;
    self.needObserverTapGesture = YES ;

    [self signCustomServer] ;
}

-(void)dealloc
{
     [[ClientCoreSDK sharedInstance] releaseCore];
}

#pragma mark-
-(NSMutableArray<RH_IMMessageModel*> *)messageList
{
    if (!_messageList){
        _messageList = [[NSMutableArray alloc] init] ;
    }

    return _messageList ;
}

-(void)updateView
{
    [self.contentTableView reloadData] ;
    [self.contentTableView setScrollsToTop:NO] ;
}

#pragma mark-
-(void)signCustomServer
{
    // 设置AppKey
    [ConfigEntity registerWithAppKey:@"5418023dfd98c579b6001741"];

    //** 设置服务器地址和端口号
    NSString *serverIP = [_customDomain stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *serverPort = _customPort;

    if(!([serverIP length] <= 0)
       && !([serverPort length] <= 0))
    {
        // 设置好服务端的连接地址
        [ConfigEntity setServerIp:serverIP];
        // 设置好服务端的UDP监听端口号
        [ConfigEntity setServerPort:[serverPort intValue]];
        // 使用以下代码表示不绑定固定port（由系统自动分配），否则使用默认的7801端口
        //      [ConfigEntity setLocalUdpSendAndListeningPort:-1];

        // RainbowCore核心IM框架的敏感度模式设置
        //      [ConfigEntity setSenseMode:SenseMode10S];
    }
    else
    {
        [self.contentLoadingIndicateView showNothingWithTitle:@"提示" detailText:@"请确保服务端地址和端口号都不为空！"] ;
        return  ;
    }


    // 开启DEBUG信息输出
    [ClientCoreSDK setENABLED_DEBUG:NO];

    // 设置事件回调
    [ClientCoreSDK sharedInstance].chatBaseEvent = self;
    [ClientCoreSDK sharedInstance].chatTransDataEvent = self;
    [ClientCoreSDK sharedInstance].messageQoSEvent = self;

   //  * 设置好服务端反馈的登陆结果观察者（当客户端收到服务端反馈过来的登陆消息时将被通知）【2】

    // * 发送登陆数据包(提交登陆名和密码)
    int code = [[LocalUDPDataSender sharedInstance] sendLogin:_userID
                                                    withToken:_userPwd];
    if(code == COMMON_CODE_OK)
    {
        //@"登陆请求已发出。。。
    }
    else
    {
        //@"登陆请求发送失败，错误码：%d", code];
    }
}

#pragma mark-
-(RH_ChatInputBar *)chatInputBarView
{
    if (!_chatInputBarView){
        CGRect inputBarFrame = CGRectMake(0, self.contentView.boundHeigh - TabBarHeight - kChatViewInputBarHeight,
                                          self.contentView.boundWidth, kChatViewInputBarHeight);
        _chatInputBarView = [[RH_ChatInputBar alloc] initWithFrame:inputBarFrame] ;
        _chatInputBarView.delegate = self ;
    }

    return _chatInputBarView ;
}

#pragma mark-ChatInputBar Delegate
-(void)ChatInputBarInputTextDidChanged:(RH_ChatInputBar*)chatInputBar
{
    CGRect bounds = chatInputBar.textView.bounds;
    ///// 计算 text view 的高度
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [chatInputBar.textView sizeThatFits:maxSize];
    CGFloat newHeight = MAX(kChatViewInputBarHeight, newSize.height + 10) ;
    CGRect oldFrame = chatInputBar.frame ;

    CGRect frame = CGRectZero ;
    if (newHeight > oldFrame.size.height){
        frame = CGRectMake(oldFrame.origin.x,
                                  oldFrame.origin.y - (newHeight-oldFrame.size.height),
                                  oldFrame.size.width, newHeight) ;
    }else{
        frame = CGRectMake(oldFrame.origin.x,
                                  oldFrame.origin.y + (oldFrame.size.height-newHeight),
                                  oldFrame.size.width, newHeight) ;
    }

    [chatInputBar updateFrame:frame] ;
}

-(void)ChatInputBarInputTextTouchSend:(RH_ChatInputBar*)chatInputBar
{

}

//NSString *dicStr = self.messageField.text;
//if ([dicStr length] == 0)
//{
//    [self E_showToastInfo:@"提示" withContent:@"请输入消息内容！" onParent:self.view];
//    return;
//}
//
//NSString *friendIdStr = self.friendId.text;
//if ([friendIdStr length] == 0)
//{
//    [self E_showToastInfo:@"提示" withContent:@"请输入对方id！" onParent:self.view];
//    return;
//}
//
////
//[self showIMInfo_black:[NSString stringWithFormat:@"我对%@说：%@", friendIdStr, dicStr]];
//
//// 发送消息
//int code = [[LocalUDPDataSender sharedInstance] sendCommonDataWithStr:dicStr toUserId:friendIdStr qos:YES fp:nil withTypeu:-1];
//if(code == COMMON_CODE_OK)
//{
//    //      [self showToastInfo:@"提示" withContent:@"您的消息已成功发出。。。"];
//}
//else
//{
//    NSString *msg = [NSString stringWithFormat:@"您的消息发送失败，错误码：%d", code];
//    [self E_showToastInfo:@"错误" withContent:msg onParent:self.view];
//}

#pragma mark-
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return self.chatInputBarView.textView.isEditable ;
}

-(void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.chatInputBarView.textView endEditing:YES] ;
}

-(void)keyboardFrameWillChange
{
    [UIView animateWithDuration:.1f animations:^{
        self.chatInputBarView.frame = CGRectMake(0, self.contentView.boundHeigh -self.chatInputBarView.boundHeigh - MAX(self.keyboardEndFrame.size.height,TabBarHeight),
                                                 self.contentView.boundWidth, self.chatInputBarView.boundHeigh);
    }] ;
    return ;
}

#pragma mark-tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageList.count ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RH_IMMessageTableCell heightForCellWithInfo:nil tableView:tableView context:self.messageList[indexPath.item]] ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RH_IMMessageTableCell *imMessageCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_IMMessageTableCell defaultReuseIdentifier]
                                                                                       forIndexPath:indexPath];

    [imMessageCell updateCellWithInfo:nil context:self.messageList[indexPath.item]] ;
    return imMessageCell ;
}

#pragma mark- chatBaseEvent protocol
- (void) onLoginMessage:(int)dwErrorCode
{
    if (dwErrorCode == 0)
    {
        [self.messageList addObject:[[RH_IMMessageModel alloc] initWithType:IMMessageType_LoginOK UserID:_userID
                                                                MessageCode:dwErrorCode
                                                                MessageInfo:@"IM服务器登录/连接成功！"]];
    }
    else
    {
        [self.messageList addObject:[[RH_IMMessageModel alloc] initWithType:IMMessageType_LoginFail UserID:_userID
                                                                MessageCode:dwErrorCode
                                                                MessageInfo:@"IM服务器登录/连接失败"]];
    }

    [self setNeedUpdateView] ;
}

- (void) onLinkCloseMessage:(int)dwErrorCode
{
    [self.messageList addObject:[[RH_IMMessageModel alloc] initWithType:IMMessageType_LoginClose UserID:_userID
                                                            MessageCode:dwErrorCode
                                                            MessageInfo:@"与IM服务器的网络连接出错关闭了"]];

    [self setNeedUpdateView] ;
}

#pragma mark-chatTransDataEvent protocol
- (void) onTransBuffer:(NSString *)fingerPrintOfProtocal withUserId:(NSString *)dwUserid andContent:(NSString *)dataContent andTypeu:(int)typeu
{
     [self.messageList addObject:[[RH_IMMessageModel alloc] initWithType:IMMessageType_ReceivedUserInfo
                                                                  UserID:dwUserid
                                                             MessageCode:typeu
                                                             MessageInfo:dataContent]];
    [self setNeedUpdateView] ;
}

- (void) onErrorResponse:(int)errorCode withErrorMsg:(NSString *)errorMsg
{
    [self.messageList addObject:[[RH_IMMessageModel alloc] initWithType:IMMessageType_ReceivedServeErrorInfo
                                                                 UserID:nil
                                                            MessageCode:errorCode
                                                            MessageInfo:errorMsg]];
    [self setNeedUpdateView] ;
}

#pragma mark-MessageQosEvent protocol
- (void) messagesLost:(NSMutableArray*)lostMessages
{
//    NSLog(@"【DEBUG_UI】收到系统的未实时送达事件通知，当前共有%li个包QoS保证机制结束，判定为【无法实时送达】！", (unsigned long)[lostMessages count]);
    [self.messageList addObject:[[RH_IMMessageModel alloc] initWithType:IMMessageType_ReceivedQoSError
                                                                 UserID:nil
                                                            MessageCode:[lostMessages count]
                                                            MessageInfo:nil]];
    [self setNeedUpdateView] ;
}

- (void) messagesBeReceived:(NSString *)theFingerPrint
{
    if(theFingerPrint != nil)
    {
//        NSLog(@"【DEBUG_UI】收到对方已收到消息事件的通知，fp=%@", theFingerPrint);
        [self.messageList addObject:[[RH_IMMessageModel alloc] initWithType:IMMessageType_ReceivedQoSOK
                                                                     UserID:nil
                                                                MessageCode:-1
                                                                MessageInfo:theFingerPrint]];
        [self setNeedUpdateView] ;
    }
}

@end
