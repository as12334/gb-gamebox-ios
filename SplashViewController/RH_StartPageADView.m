//
//  RH_StartPageADView.m
//  gameBoxEx
//
//  Created by shin on 2018/6/20.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_StartPageADView.h"
#import "MacroDef.h"
#import "UIImageView+WebCache.h"

@interface RH_StartPageADView ()
{
    dispatch_source_t timer;
}

@property (weak, nonatomic) IBOutlet UIImageView *adIMG;
@property (weak, nonatomic) IBOutlet UIButton *skipBt;
@property (copy, nonatomic) GBShowADViewComplete complete;

@end

@implementation RH_StartPageADView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc
{
    
}

- (void)clearTimer
{
    //否则内存泄漏
    if (timer) {
        dispatch_source_cancel(timer);
    }
}

- (void)setAdImageUrl:(NSString *)adImageUrl
{
    _adImageUrl = adImageUrl;
    [self.adIMG sd_setImageWithURL:[NSURL URLWithString:_adImageUrl]];
    
    [self counter];
}

- (void)show:(GBShowADViewComplete)complete
{
    _complete = complete;
}

- (void)counter
{
    if (timer == nil) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW,
                                  1.0 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    }
    __weak typeof(self) weakSelf = self;
    __block int i = 0;
    dispatch_source_set_event_handler(timer, ^() {
        i++;

        if (i<4) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.skipBt setTitle:[NSString stringWithFormat:@"%i秒后跳过", 4-i] forState:UIControlStateNormal];
            });
        }
        else
        {
            dispatch_suspend(timer);
            [weakSelf clearTimer];
            //结束显示
            if (weakSelf.complete) {
                weakSelf.complete();
            }
        }
    });
    
    dispatch_resume(timer);
}

- (IBAction)skip:(id)sender {
    if (self.complete) {
        self.complete();
    }
}

@end
