//
//  JsToOc.h
//  webViewtest
//
//  Created by deve dawoo on 2017/6/28.
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

//首先创建一个实现了JSExport协议的协议
@protocol TestJSObjectProtocol <JSExport>

//此处我们测试几种参数的情况
-(void)TestNOParameter;
-(void)TestOneParameter:(NSString *)message;
-(void)TestTowParameter:(NSString *)message1 SecondParameter:(NSString *)message2;
-(void)TestLogin:(NSString *)account;
-(void)GotoCustom;



@end

//让我们创建的类实现上边的协议
@interface TestJSObject : NSObject<TestJSObjectProtocol>

@end

