//
//  RH_BasicHelpView.m
//  TaskTracking
//
//  Created by jinguihua on 2017/4/24.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_BasicHelpView.h"
#import "coreLib.h"

@interface RH_BasicHelpView ()
@end

@implementation RH_BasicHelpView
{
    UIWindow    * _window;
    NSString    * _key;
}

+ (NSUserDefaults *)userDefaultsForHelpView {
    return [NSUserDefaults standardUserDefaults];
}

- (id)initWithFrame:(CGRect)frame {
    return nil;
}

+ (instancetype)createInstanceWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundleOrNil context:(id)context
{
    NSString * key = ConvertToClassPointer(NSString, context);

    if (key && ![[RH_BasicHelpView userDefaultsForHelpView] boolForKey:key]) {

        RH_BasicHelpView * helpView = [super createInstanceWithNibName:nibNameOrNil bundle:bundleOrNil context:context];
        [helpView _setupWithKey:key];

        return helpView;
    }

    return nil;
}

- (id)initWithContext:(id)context {
    return [self initWithKey:ConvertToClassPointer(NSString, context)];
}

- (id)initWithKey:(NSString *)key
{
    if (key && ![[RH_BasicHelpView userDefaultsForHelpView] boolForKey:key]) {

        self = [super initWithFrame:CGRectZero];

        if (self) {
            [self _setupWithKey:key];
        }

        return self;
    }

    return nil;
}

- (void)_setupWithKey:(NSString *)key
{
    if (_key != key) {
        _key = key;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_aplicationWillEnterForegroundNotification:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)_aplicationWillEnterForegroundNotification:(NSNotification *)notification {
    [self startAnimation];
}

- (void)show
{
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.windowLevel = UIWindowLevelStatusBar + 1;
    _window.backgroundColor = BlackColorWithAlpha(0.7f);

    self.frame = _window.bounds;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    //显示时建立引用循环
    [_window addSubview:self];
    [_window setHidden:NO];

    //开始动画
    [self startAnimation];
}

- (void)hidden
{
    if (_window) {

        //设置已显示
        [[RH_BasicHelpView userDefaultsForHelpView] setBool:YES forKey:_key];

        //隐藏
        [UIView animateWithDuration:0.3f animations:^{
            _window.alpha = 0.f;
        } completion:^(BOOL finished){
            [_window setHidden:YES];
            [self removeFromSuperview];
        }];
    }
}

- (void)startAnimation {
    //do nothing
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hidden];

    //    if (self.helpViewDidTapHiddenBlock) {
    //        self.helpViewDidTapHiddenBlock(self);
    //    }
}


@end
