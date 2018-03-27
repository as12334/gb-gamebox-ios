//
//  RH_HelpCenterDetailModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/25.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_HelpCenterDetailModel.h"
#import "coreLib.h"

@implementation RH_HelpCenterDetailModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _helpContent = [self filterHTML:[info stringValueForKey:@"helpContent"]];
        _mId = [info integerValueForKey:@"id"] ;
        _helpTitle = [info stringValueForKey:@"helpTitle"] ;
        _local = [info stringValueForKey:@"local"] ;
        _helpDocumentId = [info integerValueForKey:@"helpDocumentId"] ;
    }
    return self ;
}

-(NSString *)filterHTML:(NSString *)html{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

@end


