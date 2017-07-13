//
//  JsToOc.m
//  webViewtest
//
//  Created by deve dawoo on 2017/6/28.
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import "JsToOc.h"
#import <UIKit/UIKit.h>
#import "CustomVC.h"
#import "ViewController.h"

@implementation TestJSObject

//一下方法都是只是打了个log 等会看log 以及参数能对上就说明js调用了此处的iOS 原生方法
-(void)TestNOParameter
{
    NSLog(@"this is ios TestNOParameter");
}
-(void)TestOneParameter:(NSString *)message
{
    NSLog(@"this is ios TestOneParameter=%@",message);
}
-(void)TestTowParameter:(NSString *)message1 SecondParameter:(NSString *)message2
{
    NSLog(@"this is ios TestTowParameter=%@  Second=%@",message1,message2);
}

-(void)TestLogin:(NSString *)account
{
    NSLog(@"login:%@",account);
}
-(void)GotoCustom
{
    ViewController *mvc = [ViewController new];
}

@end

