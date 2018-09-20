//
//  StartPageViewController.h
//  gameBoxEx
//
//  Created by shin on 2018/6/17.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_BasicViewController.h"

typedef void(^GBFetchIPsComplete)(NSDictionary *ips);
typedef void(^GBFetchIPsFailed)(void);

typedef void(^GBFetchIPListComplete)(NSDictionary *ips);
typedef void(^GBFetchIPListFailed)(void);

typedef void(^GBCheckIPFullTypeComplete)(NSString *ip, NSString *type);
typedef void(^GBCheckIPFullTypeFailed)(void);

typedef void(^GBCheckIPComplete)(NSString *type);
typedef void(^GBCheckIPFailed)(void);

typedef void(^GBFetchHostComplete)(NSDictionary *host);
typedef void(^GBFetchHostFailed)(void);

typedef void(^GBCheckAllIPsComplete)(void);
typedef void(^GBCheckAllIPsFailed)(void);

typedef void(^GBShowAdComplete)(void);

typedef void(^GBFetchIPSFromBossComplete)(NSDictionary *ips);
typedef void(^GBFetchIPSFromBossFailed)(void);

typedef void(^GBCheckH5LineComplete)(NSString *h5Host);
typedef void(^GBCheckH5LineFailed)(void);

@class StartPageViewController;
@protocol StartPageViewControllerDelegate

@optional

- (void)startPageViewControllerShowMainPage:(StartPageViewController *)controller;
@end

@interface StartPageViewController : RH_BasicViewController

@property (nonatomic, weak) id <StartPageViewControllerDelegate> delegate;

@end
