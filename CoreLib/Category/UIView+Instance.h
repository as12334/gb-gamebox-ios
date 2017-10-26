//
//  UIView+Instance.h
//  TaskTracking
//
//  Created by jinguihua on 2017/2/14.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Instance)
//首先从nib加载不成功则使用默认加载方式
+ (instancetype)createInstance;

+ (instancetype)createInstanceWithContext:(id)context;


+ (instancetype)createInstanceWithNibName:(NSString *)nibNameOrNil
                                   bundle:(NSBundle *)bundleOrNil
                                  context:(id)context;

- (id)initWithContext:(id)context;
- (void)setupViewWithContext:(id)context ;

@end
