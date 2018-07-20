//
//  RH_CustomPageViewControllerEx.h
//  gameBoxEx
//
//  Created by luis on 2017/10/18.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BasicViewController.h"
#import "ChatBaseEvent.h"
#import "MessageQoSEvent.h"
#import "ChatTransDataEvent.h"

@interface RH_CustomPageViewControllerEx : RH_BasicViewController<ChatBaseEvent,MessageQoSEvent,ChatTransDataEvent>

@end
