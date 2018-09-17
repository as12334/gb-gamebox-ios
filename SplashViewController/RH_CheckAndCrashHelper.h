//
//  RH_CheckAndCrashHelper.h
//  gameBoxEx
//
//  Created by jun on 2018/9/17.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RH_CheckAndCrashHelper : NSObject
+(instancetype)shared;
-(void)uploadJournalWithMessages:(NSArray *)messages;
- (NSString *)localIPAddress;
@end
