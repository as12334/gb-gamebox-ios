//
//  RH_BasicHelpView.h
//  TaskTracking
//
//  Created by jinguihua on 2017/4/24.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RH_BasicHelpView : UIView
+ (NSUserDefaults *)userDefaultsForHelpView;
- (id)initWithKey:(NSString *)key;

- (void)startAnimation;

- (void)show;
- (void)hidden;

@end
